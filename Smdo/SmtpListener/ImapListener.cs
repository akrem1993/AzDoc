using Helpers;
using ORM.Context;
using Repository.UnitOfWork;
using S22.Imap;
using Smdo.AzDoc.Adapters;
using Smdo.EmailModels;
using System;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Threading;
using System.Threading.Tasks;
using System.Xml;
using XmlModels;

namespace Smdo.SmtpListener
{
    public class ImapListener
    {
        static ImapClient Client;
        const string emailHost = "10.10.1.1";
        const string smtpEmail = "az001@prb.by";
        const string smtpPassword = "123456";
        static int port = 1143;

        private static string ServerPath;
        private static bool IsActive;
        public static string MsgPath { get; set; }
        public ImapListener()
        {
            SetImap();

            
        }

        static void SetImap()
        {
            //ImapClient client = new ImapClient(emailHost,
            //                                      port,
            //                                      smtpEmail,
            //                                      smtpPassword,
            //                                      AuthMethod.Login,
            //                                      false);

            //if (!client.Supports("IDLE"))
            //    throw new Exception("Server does not support IMAP");

            // Client = client;

        }

        public void Start(string serverPath)
        {
            if (Client is null) SetImap();

            if (!IsActive)
            {
                ServerPath = serverPath;
                //Client.NewMessage += OnNewMessage;

                //Task.Factory.StartNew(() =>
                //{
                //    Thread.Sleep(60000);
                //    Client.()


                //    //SaveMail(m);
                //});

                IsActive = true;
            }
        }

        public void OnNewMessage(object sender, IdleMessageEventArgs e)
        {
            MailMessage m = e.Client.GetMessage(e.MessageUID, FetchOptions.Normal);

            SaveMail(m);

            //Task.Factory.StartNew(delegate
            //{
            //    SaveMail(m);
            //});
        }



        public void SaveMail(MailMessage mail)
        {
            if (mail is null || mail.Attachments.Count == 0) return;

            foreach (var attach in mail.Attachments)
            {
                string extension = Path.GetExtension(attach.Name);

                if (extension == ".xml" || attach.Name.Contains("_data"))
                {
                    var docEnvelope = GetReceivedXml(attach);

                    MsgPath = $"{ServerPath}/{docEnvelope.Envelope.MsgId}";

                    Directory.CreateDirectory(MsgPath);

                    SaveIOAttach(attach);

                    SaveAttachData(mail.Attachments,
                                   docEnvelope.Envelope.Body.BodyData.DocTransfer.Data.ReferenceId,
                                   docEnvelope.Envelope.Body.BodyData.DocTransfer.Name);

                    SaveSign(docEnvelope.Envelope.Body.BodyData.DocTransfer.Signature[1].Text);

                    SaveDoc(docEnvelope.Envelope, new AttachFile
                    {
                        FileName = docEnvelope.Envelope.Body.BodyData.DocTransfer.Name
                    });

                    XmlLog("", true, docEnvelope.LogId);

                    break;
                }
            }
        }

        private void SaveSign(string signToken)
        {
            var buffer = Convert.FromBase64String(signToken);

            File.WriteAllBytes($"{MsgPath}/sign.p7s", buffer);
        }

        private void SaveAttachData(AttachmentCollection attachments, string referenceId, string fileName)
        {
            var attachData = attachments.FirstOrDefault(x => x.Name == referenceId);

            if (attachData is null) return;

            using (var fileStream = new FileStream($"{MsgPath}/{fileName}", FileMode.Create, FileAccess.Write))
                attachData.ContentStream.CopyTo(fileStream);
        }


        private void SaveIOAttach(Attachment attachment)
        {
            using (var fileStream = new FileStream(MsgPath, FileMode.Create, FileAccess.Write))
                attachment.ContentStream.CopyTo(fileStream);
        }

        //private AttachFile GetAndSaveAttach(AttachmentCollection attachments, string fileName)
        //{
        //    foreach (var attach in attachments)
        //    {
        //        string extension = Path.GetExtension(attach.Name);

        //        if (extension == ".xml") continue;

        //        var file = SaveAttachFile(attach, fileName);

        //        return file;
        //    }

        //    return null;
        //}

        private AttachFile SaveAttachFile(Attachment attachment, string fileName)
        {
            SaveIOAttach(attachment);

            var fileGuid = Guid.NewGuid().ToString();

            return new AttachFile
            {
                AttachPath = "",
                Extension = Path.GetExtension(attachment.Name),
                FileName = fileName,
                Guid = fileGuid
            };
        }

        public static TempData GetReceivedXml(Attachment xml)
        {
            string localTempPath = $"{ServerPath}/{Guid.NewGuid().ToString()}.xml";

            var fileStream = new FileStream(localTempPath, FileMode.Create, FileAccess.Write);

            using (fileStream) xml.ContentStream.CopyTo(fileStream);

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

        private static void SaveDoc(Envelope<Document> envelope, AttachFile file)
        {
            using (DocumentAdapter adapter = new DocumentAdapter(new EFUnitOfWork<DMSContext>()))
            {
                adapter.CreateReceivedDoc(envelope, file);
            }
        }

        private static int XmlLog(string xml, bool status, int id)
        {
            using (DocumentAdapter adapter = new DocumentAdapter(new EFUnitOfWork<DMSContext>()))
            {
                return adapter.XmlLog(xml, status, id);
            }
        }
    }


    public class TempData
    {
        public Envelope<Document> Envelope { get; set; }

        public int LogId { get; set; }
    }


}
