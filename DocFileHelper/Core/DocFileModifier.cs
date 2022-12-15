using AppCore.Interfaces;
using BLL.Models.Document;
using DocFileHelper.Modifier.Models;
using DocFileHelper.Modifier.Models.Interfaces;
using DocFileHelper.Modifier.Services.Pdf;
using DocFileHelper.QrCreator.Models;
using DocFileHelper.QrCreator.Services;
using System.IO;

namespace DocFileHelper.Core
{
    public static class DocFileModifier
    {
        public static void AppendQrToFile(BaseElectronDoc model, IServerPath serverPath, string filePath)
        {
            if (model.FileSignatureStatus != 2) return;

            var qrGenerator = new DocQrCode(serverPath.QrService);
            var qrData = qrGenerator.GetQrDataList(model);

            IModifiedDoc modifiedDoc = new MissingDoc();

            var ext = Path.GetExtension(filePath);

            switch (ext.ToLower())
            {
                case ".docx":
                case ".doc":
                    //modifiedDoc = new SpireService(serverPath, fileInfo.FileName);
                    break;

                case ".pdf":
                    modifiedDoc = new PdfService(serverPath, filePath);
                    break;
            }

            AddQrCodeNote(qrData);
            modifiedDoc.ModifyDoc(qrData);
        }

        static void AddQrCodeNote(QrData qrData)
        {
            qrData.Input.Add($"Sənədin elektron yüklənmə ünvanı: {qrData.QrDocUrl}");

            qrData.Input.Add("Qeyd: 'Elektron imza və elektron sənəd haqqında' Azərbaycan Respublikası Qanununun 3-cü maddəsinə əsasən elektron imza əl imzası ilə bərabər");

            qrData.Input.Add(" hüquqi qüvvəyə malikdir.Elektron imza şəxsin kağız daşıyıcı üzərindəki möhürlə təsdiq edilmiş əl imzasına bərabər tutulur.");
        }
    }

}
