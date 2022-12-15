using Helpers;
using Smdo.AzDoc.Models;
using System;
using System.Collections.Generic;
using XmlModels;

namespace Smdo.Helpers
{
    public class DocsXmlGenerator
    {

        public const string dateFormat = "yyyy-MM-ddTHH:mm:sszzz";
        public const string shortDateFormat = "yyyy-MM-dd";
        public const string regnumDate = "dd.mm.yyyy";
        public static Sender Sender;
        public static Receiver Receiver;

        public DocsXmlGenerator()
        {
            Sender = new Sender
            {
                Id = "AZ001",//
                Name = "Министерство транспорта, связи и высоких технологий",
                SysId = "4f7a4bb0-3e66-487d-b913-812f0509d226",
                System = "ESD",//
                SystemDetails = "0"//
            };


            Receiver = new Receiver
            {
                Id = "RB001",
                Name = "Министертсво связи и информатизации Республики Беларусь"
            };
        }

        public static string GetSerializedDoc(DocModel docModel, GridViewDoc doc)
        {
            var docGuid = doc.DocMsgGuid;
            int docId = doc.DocId;
            var docDate = doc.DocEnterDate.ToString("dd.MM.yyyy");

            docModel.Subject = $"исх. № {docId} от {docDate}г";

            var envelope = new Envelope<Document>
            {
                DtsTamp = DateTime.Now.ToString(dateFormat),
                Subject = docModel.Subject,
                Type = "SDIP-2.1.1",
                MsgId = docGuid
            };

            var header = new Header
            {
                MsgType = "1",
                MsgAcknow = "2"
            };

            var sender = Sender;

            var receiver = Receiver;

            var receiverOrganization = new Organization
            {
                Address = "г. Минск, ул. Берсона 14",
                OrganizationString = "Министертсво связи и информатизации Республики Беларусь",
                FullName = "Министертсво связи и информатизации Республики Беларусь",
                ShortName = "Минсвязи РБ"
            };
            receiver.Organization = receiverOrganization;


            var body = new Body<Document>();

            var document = new Document
            {
                IdNumber = docId.ToString(),
                Kind = "Письмо",
                Type = "1",
                RegNumber = new RegNumber { RegDate = doc.DocEnterDate.ToString(shortDateFormat), Text = docId.ToString() },
                Pages = "5",
                Title = $"Заголовок от № {docId}"
            };

            var confident = new Confident
            {
                Flag = "0",
                Text = "общий"
            };

            var docTransfer = new DocTransfer
            {
                Name = doc.DocFilePath,
                Data = new Data { ReferenceId = "attach1" }
            };

            var signs = new Signature
            {
                Signer = "Министерство транспорта, связи и высоких технологий , Министр Рамин Гулузаде",
                SignTime = doc.DocEnterDate.AddDays(-5).ToString(dateFormat),
                Text = docModel.Signature
            };

            var author = new Author
            {
                OrganizationWithSign = new OrganizationWithSign
                {
                    OrganizationString = receiver.Organization.OrganizationString,
                    OfficialPersonWithSign = new OfficialPersonWithSign { Name = "А.Абдуллаев" }
                }
            };


            envelope.Header = header;

            header.Sender = sender;
            header.Receiver = new List<Receiver> { receiver };

            body.BodyData = document;

            document.Confident = confident;
            document.DocTransfer = docTransfer;
            docTransfer.Signature = new[] { signs };
            document.Author = author;
            envelope.Body = body;

            string xml = envelope.Serialize();

            return xml;
        }



        #region Acknowledgement
        public static Envelope<Acknowledgement> GetSerializedAcknowledgement(int ackType, string envelopeMessageId, string envelopeDocId, int? savedDocId)
        {
            var guid = Guid.NewGuid();


            string subjectText = "";
            string ackResultText = "";


            if (ackType == 1)
            {
                subjectText = $"уведомление о доставке №";
                ackResultText = $"документ доставлен в систему документооборота [{DateTime.Now.ToString()}]";
            }
            else
            {
                subjectText = $"уведомление о регистрации №";
                ackResultText = $"документ зарегистрирован номером {savedDocId} от {DateTime.Now.ToString("dd.MM.yyyy")}";
            }


            var subject = $"{subjectText} {envelopeDocId} от {DateTime.Now.ToString("dd.MM.yyyy")}";

            //№ { docId} от

            var envelope = new Envelope<Acknowledgement>
            {
                DtsTamp = DateTime.Now.ToString(dateFormat),
                Subject = subject,
                Type = "SDIP-2.1.1",
                MsgId = guid.ToString()
            };

            var header = new Header
            {
                MsgType = "0",
                MsgAcknow = "0"
            };


            var sender = Sender;

            var receiver = Receiver;

            var receiverOrganization = new Organization
            {
                Address = "г. Минск, ул. Берсона 14",
                OrganizationString = "Министертсво связи и информатизации Республики Беларусь",
                ShortName = "Минсвязи РБ",
                FullName = "Министертсво связи и информатизации Республики Беларусь"
            };
            receiver.Organization = receiverOrganization;


            var regNumber = new RegNumber
            {
                RegDate = DateTime.Now.ToString(shortDateFormat),
                Text = envelopeDocId
            };


            IncNumber inc = null;

            if (ackType == 2)
            {
                inc = new IncNumber
                {
                    RegDate = DateTime.Now.ToString(shortDateFormat),
                    Text = savedDocId.ToString()
                };
            }

            var ackResult = new AckResult
            {
                ErrorCode = "0",
                Text = ackResultText
            };

            var body = new Body<Acknowledgement>();


            var acknowledgement = new Acknowledgement
            {
                MsgId = envelopeMessageId,
                AckType = ackType.ToString(),
                AckResult = ackResult,
                RegNumber = regNumber,
                IncNumber = inc
            };

            body.BodyDataAck = acknowledgement;

            /*№ {docId} от */

            header.Sender = sender;
            header.Receiver = new List<Receiver> { receiver };

            envelope.Header = header;
            envelope.Body = body;


            return envelope;

        }

        #endregion

    }
}
