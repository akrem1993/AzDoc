using BLL.Models.Document;
using CustomHelpers;
using DocFileHelper.Base64Service;
using DocFileHelper.QrCreator.Models;
using QRCoder;
using System.Collections.Generic;

namespace DocFileHelper.QrCreator.Services
{
    public class DocQrCode
    {
        readonly string ServiceUrl;
        public DocQrCode(string serviceUrl) => ServiceUrl = serviceUrl;

        public QrData GenerateQrCodeImage(int docId)
        {
            var qrDocUrl = $"{ServiceUrl}?docId={CustomHelper.Encrypt(docId.ToString())}";

            QRCodeGenerator qrGenerator = new QRCodeGenerator();
            QRCodeData qrCode = qrGenerator.CreateQrCode(qrDocUrl, QRCodeGenerator.ECCLevel.L);
            QRCode codeData = new QRCode(qrCode);

            using (qrGenerator)
            using (qrCode)
            using (codeData)
            {
                var bitmap = codeData.GetGraphic(10);
                var base64 = bitmap.ToBase64();

                return new QrData
                {
                    QrDocUrl = qrDocUrl,
                    ImageBase64 = base64,
                    ImageData = bitmap
                };
            }
        }


        public QrData GetQrDataList(BaseElectronDoc doc)
        {
            if (doc.FileSignatureStatus != 2) return null;

            var qrKeys = new List<string>();

            qrKeys.Add($"Qurumun adı: {doc.DocOrganization}");
            qrKeys.Add($"Sənədin elektron imzalanma tarixi: { doc.SignTime.Value.ToShortDateString()}");

            if (!string.IsNullOrEmpty(doc.DocEnterNo))
            {
                qrKeys.Add($"Sənədin qeydiyyat nömrəsi: { doc.DocEnterNo}");
            }
            else
            {
                qrKeys.Add($"Layihə nömrəsi: {doc.DocDocNo}");
            }

            qrKeys.Add($"Imza edən şəxs: {doc.SignerPerson}");

            var qrData = GenerateQrCodeImage(doc.DocId);
            doc.Base64QrCode = qrData.ImageBase64;
            qrData.Input = qrKeys;

            return qrData;
        }


    }
}
