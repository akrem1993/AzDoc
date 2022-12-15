using Smdo.AzDoc.Models;
using Smdo.Enums;
using Smdo.Models;
using System;
using System.IO;
using System.Net.Mail;

namespace Smdo.Helpers
{
    public class EmailHelper
    {
        private readonly string gettingFileFolder;
        private readonly string savingFolder;


        public EmailHelper(string outServerPath, string inServerPath)
        {
            gettingFileFolder = outServerPath;
            savingFolder = inServerPath;
        }

        private string packagePathForFile { get; set; }

        private int counter { get; set; }

        internal void SaveMailAttachment(Attachment attachment)
        {
            var packageName = Guid.NewGuid().ToString().ToUpper();
            string extension = Path.GetExtension(attachment.Name);
            byte[] allBytes = new byte[attachment.ContentStream.Length];
            int bytesRead = attachment.ContentStream.Read(allBytes, 0, (int)attachment.ContentStream.Length);


            string destinationFile = "";

            if (attachment.Name.Contains("_ack"))
            {
                destinationFile = Path.Combine(savingFolder, packageName, packageName + "_ack" + extension);
                packagePathForFile = Path.Combine(savingFolder, packageName);
            }
            else if (attachment.Name.Contains("_data"))
            {
                destinationFile = Path.Combine(savingFolder, packageName, packageName + "_data" + extension);
                packagePathForFile = Path.Combine(savingFolder, packageName);
            }
            else
            {
                counter++;
                destinationFile = Path.Combine(packagePathForFile, "attach" + counter + extension);
            }

            if (!Directory.Exists(packagePathForFile))
            {
                Directory.CreateDirectory(packagePathForFile);
            }

            BinaryWriter writer = new BinaryWriter(new FileStream(destinationFile, FileMode.OpenOrCreate, FileAccess.Write, FileShare.None));
            writer.Write(allBytes);
            writer.Close();
        }

        private byte[] GetBinaryFile(string filePath)
        {
            using (FileStream file = new FileStream(filePath, FileMode.Open, FileAccess.Read))
            {
                byte[] bytes = new byte[file.Length];
                file.Read(bytes, 0, (int)file.Length);

                return bytes;
            }
        }

        public string SaveXmlFile(DocXml docXml, MailType mailType)
        {
            string filePath;

            switch (mailType)
            {
                case MailType.Mail:
                    filePath = gettingFileFolder + docXml.DocGuid + "_data.xml";
                    break;
                case MailType.Kvitansiya:
                    filePath = gettingFileFolder + docXml.DocGuid + "_ack.xml";
                    break;
                default: return string.Empty;
            }

            using (StreamWriter writer = new StreamWriter(filePath))
            {
                writer.Write(docXml.DocDataXml);
            }

            if (string.IsNullOrWhiteSpace(filePath))
                throw new Exception("xmlDataFilePath is empty");

            return filePath;
        }

        private string GetSignBase64()
        {
            var fileSignaturePath = gettingFileFolder + "sign.p7s";
            var byteSign = GetBinaryFile(fileSignaturePath);
            var signBase = Convert.ToBase64String(byteSign);

            return signBase;
        }

        public DocXml GetDocXml(GridViewDoc doc)
        {
            var docModel = new DocModel
            {
                Signature = GetSignBase64(),
                DocGuid = doc.DocMsgGuid
            };
            new DocsXmlGenerator();
            var docXml = DocsXmlGenerator.GetSerializedDoc(docModel, doc);

            return new DocXml
            {
                DocGuid = doc.DocMsgGuid,
                DocDataXml = docXml,
                Subject = docModel.Subject
            };
        }
    }
}
