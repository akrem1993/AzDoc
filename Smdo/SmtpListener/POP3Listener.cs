using EAGetMail;
using Helpers;
using ORM.Context;
using Repository.UnitOfWork;
using Smdo.AzDoc.Adapters;
using Smdo.EmailModels;
using Smdo.Helpers;
using Smdo.Smpt;
using System;
using System.IO;
using System.Linq;
using System.Timers;
using System.Xml;
using XmlModels;

namespace Smdo.SmtpListener
{
    public static class POP3Listener
    {
        static MailServer mailServer;
        static MailClient mailClient;


        const string emailHost = "10.10.1.1";
        const string smtpEmail = "az001@prb.by";
        const string smtpPassword = "123456";
        const int port = 1100;


        private static string ServerPath;
        private static bool IsActive;
        private static bool ReadNow;
        private static Timer aTimer;

        public static string MsgPath { get; set; }

        public static void Start(string serverPath, bool isActive)
        {
            if (aTimer == null || !aTimer.Enabled)
            {
                ServerPath = serverPath;
                StartTimeOut();

                IsActive = true;
            }
        }

        static void StartTimeOut()
        {
            aTimer = new Timer();
            aTimer.Interval = 60000;
            aTimer.Elapsed += (s, e) => ListenEmail();
            aTimer.Enabled = true;
        }

        static void ListenEmail()
        {
            try
            {
                if (ReadNow) return;

                if (mailServer is null) mailServer = new MailServer(emailHost, smtpEmail, smtpPassword, ServerProtocol.Pop3)
                {
                    SSLConnection = false,
                    Port = port
                };

                if (mailClient is null)
                {
                    mailClient = new MailClient("TryIt");
                    mailClient.OnAuthorized += OnAuthorized;
                    mailClient.OnConnected += OnConnected;
                    mailClient.OnIdle += OnIdle;
                    mailClient.OnSecuring += OnSecuring;
                    mailClient.OnReceivingDataStream += OnReceivingDataStream;
                }

                if (mailClient != null && !mailClient.Connected) mailClient.Connect(mailServer);

                MailInfo[] infos = mailClient.GetMailInfos();

                if (infos.Length > 0)
                {
                    foreach (var mailInfo in infos)
                    {
                        ReadNow = true;
                        Mail receivedMail = mailClient.GetMail(mailInfo);

                        SaveMail(receivedMail);
                        ReadNow = false;
                        //mailClient.Delete(mailInfo);
                    }
                }

                mailClient.Quit();
            }
            catch (Exception ex)
            {
                //LogHelpers.Log.AddError(ex.Message,"POP3 LISTENER ERROR","");
                ReadNow = false;
            }
        }



        static void SaveMail(Mail mail)
        {
            if (mail is null || mail.Attachments.Length == 0) return;

            ReadNow = true;

            foreach (var attach in mail.Attachments)
            {
                string extension = Path.GetExtension(attach.Name);

                if (extension == ".xml" && attach.Name.Contains("_data"))
                {
                    var docEnvelope = GetReceivedXml(attach);

                    if (IsDocExists(docEnvelope.Envelope.MsgId)) return;

                    MsgPath = $"{ServerPath}/{docEnvelope.Envelope.MsgId}";

                    Directory.CreateDirectory(MsgPath);

                    SaveIOAttach(attach, attach.Name);

                    SaveAttachData(mail.Attachments,
                                   docEnvelope.Envelope.Body.BodyData.DocTransfer.Data.ReferenceId,
                                   docEnvelope.Envelope.Body.BodyData.DocTransfer.Name);

                    SaveSign(docEnvelope.Envelope.Body.BodyData.DocTransfer.Signature.Last()?.Text);


                    SendAck(1, docEnvelope.Envelope.MsgId,
                        docEnvelope.Envelope.Body.BodyData.RegNumber.Text,
                        null);

                    int incDocId = SaveDoc(docEnvelope.Envelope, new AttachFile
                    {
                        FileName = docEnvelope.Envelope.Body.BodyData.DocTransfer.Name
                    });

                    SendAck(2, docEnvelope.Envelope.MsgId,
                        docEnvelope.Envelope.Body.BodyData.RegNumber.Text,
                        incDocId);

                    AddDocSubject(incDocId, docEnvelope.Envelope.Subject);
                    //XmlLog("", true, docEnvelope.LogId);

                    return;
                }
            }
        }

        static void SaveSign(string signToken)
        {
            var buffer = Convert.FromBase64String(signToken);

            File.WriteAllBytes($"{MsgPath}/sign.p7s", buffer);
        }

        static void SaveAttachData(Attachment[] attachments, string referenceId, string fileName)
        {
            var attachData = attachments.FirstOrDefault(x => x.Name.Replace(".txt", "") == referenceId);

            if (attachData is null) return;

            using (Stream contentStream = new MemoryStream(attachData.Content))
            {
                using (var fileStream = new FileStream($"{MsgPath}/{fileName}", FileMode.Create, FileAccess.Write))
                    contentStream.CopyTo(fileStream);
            }
        }

        static void AddDocSubject(int docId, string subject)
        {
            using (DocumentAdapter adapter = new DocumentAdapter(new EFUnitOfWork<DMSContext>()))
            {
                adapter.AddDocSubject(docId, subject);
            }
        }


        static void SaveIOAttach(Attachment attachment, string attachName)
        {
            using (Stream contentStream = new MemoryStream(attachment.Content))
            {
                using (var fileStream = new FileStream(MsgPath + $"/{attachName}", FileMode.Create, FileAccess.Write))
                    contentStream.CopyTo(fileStream);
            }
        }


        public static TempData GetReceivedXml(Attachment xml)
        {
            string localTempPath = $"{ServerPath}/{Guid.NewGuid().ToString()}.xml";

            var fileStream = new FileStream(localTempPath, FileMode.Create, FileAccess.Write);

            using (Stream contentStream = new MemoryStream(xml.Content))//byte array => contentStream)
            {
                using (fileStream) contentStream.CopyTo(fileStream);

                XmlDocument doc = new XmlDocument(); doc.Load(localTempPath);
                string xmlContent = doc.InnerXml;

                if (xmlContent.Length == 0) throw new ArgumentException(" attach xml is null");

                int logId = XmlLog(xmlContent, false, 0);

                var envelope = xmlContent.Deserialize<Envelope<Document>>();
                return new TempData
                {
                    LogId = logId,
                    Envelope = envelope
                };

            }
        }


        static int SaveDoc(Envelope<Document> envelope, AttachFile file)
        {
            using (DocumentAdapter adapter = new DocumentAdapter(new EFUnitOfWork<DMSContext>()))
            {
                return adapter.CreateReceivedDoc(envelope, file);
            }
        }

        static int XmlLog(string xml, bool status, int id)
        {
            using (DocumentAdapter adapter = new DocumentAdapter(new EFUnitOfWork<DMSContext>()))
            {
                return adapter.XmlLog(xml, status, id);
            }
        }

        static bool IsDocExists(string guid)
        {
            using (DocumentAdapter adapter = new DocumentAdapter(new EFUnitOfWork<DMSContext>()))
            {
                var res = adapter.IsDocExist(guid);

                return res == "1";
            }

        }


        public static void SendAck(int ackType, string envelopeMessageId, string envelopeDocId, int? savedDocId)
        {
            try
            {
                new DocsXmlGenerator();
                var xml = DocsXmlGenerator.GetSerializedAcknowledgement(ackType, envelopeMessageId, envelopeDocId,
                    savedDocId);

                var path = MsgPath + $"/{xml.MsgId}_ack.xml";

                using (StreamWriter writer = new StreamWriter(path))
                {
                    writer.Write(xml.Serialize());
                }

                EmailForm form = new EmailForm();
                form.Subject = xml.Subject;
                form.Attaches.Add(new AttachFile { AttachPath = path, AttachType = Enums.AttachType.Xml });


                SendMail sendMail = new SendMail();
                sendMail.SendEmail(form);
            }
            catch (Exception ex)
            {
                LogHelpers.Log.AddError(ex.Message, "POP3 LISTENER ERROR", "");
            }
        }



        #region POP3

        static void OnConnected(object sender, ref bool cancel) { }

        static void OnQuit(object sender, ref bool cancel) { }

        static void OnReceivingDataStream(object sender,
           MailInfo info, int received, int total, ref bool cancel)
        { }

        static void OnIdle(object sender, ref bool cancel) { }

        static void OnAuthorized(object sender, ref bool cancel) { }

        static void OnSecuring(object sender, ref bool cancel) { }

        #endregion
    }
}
