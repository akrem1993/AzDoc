using Smdo.EmailModels;
using Smdo.Enums;
using System.Net;
using System.Net.Mail;
using System.Text;

namespace Smdo.Smpt
{
    public class SendMail
    {
        public void SendEmail(EmailForm requestData)
        {
            string emailHost = "10.10.1.1";
            string smtpEmail = "az001@prb.by";
            string smtpPassword = "123456";
            const int port = 225;

            SmtpClient smtpClient = new SmtpClient(emailHost)
            {
                Port = port,
                EnableSsl = false,
                UseDefaultCredentials = false,
                Credentials = new NetworkCredential(smtpEmail, smtpPassword),
                DeliveryMethod = SmtpDeliveryMethod.Network
            };

            MailMessage mailMessage = new MailMessage(smtpEmail, requestData.ToEmail,
                requestData.Subject, requestData.Body)
            {
                From = new MailAddress(smtpEmail),
                Subject = requestData.Subject,
                SubjectEncoding = Encoding.UTF8,
                IsBodyHtml = true,
                Body = requestData.Body,
                BodyEncoding = Encoding.UTF8
            };

            requestData.Attaches.ForEach(x =>
            {
                mailMessage.Attachments.Add(CreateAttachment(x));
            });

            using (smtpClient)
            {
                using (mailMessage)
                {
                    smtpClient.Send(mailMessage);
                }
            }
        }

        Attachment CreateAttachment(AttachFile file)
        {
            var attachment = new Attachment(file.AttachPath);

            if (file.AttachType == AttachType.Other)
            {
                attachment.Name = file.FileName;
            }

            return attachment;
        }

    }
}
