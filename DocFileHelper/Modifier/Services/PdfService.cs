using AppCore.Interfaces;
using DocFileHelper.Modifier.Models.Interfaces;
using DocFileHelper.QrCreator.Models;
using iTextSharp.text;
using iTextSharp.text.pdf;
using System;
using System.Drawing.Imaging;
using System.IO;

namespace DocFileHelper.Modifier.Services.Pdf
{
    public class PdfService : BaseDocFileService, IModifiedDoc
    {
        public PdfService(IServerPath serverPath, string filePath) : base(serverPath, filePath) { }

        public void ModifyDoc(QrData qrData)
        {
            //var qrImageLocation = SaveImage(qrData.ImageData);
            string outPdf = $"{ServerPath.UploadTemp}{Guid.NewGuid()}.pdf";

            var inPdfStream = new FileStream(FileLocation, FileMode.Open, FileAccess.Read, FileShare.Read);
            var outPdfStream = new FileStream(outPdf, FileMode.Create, FileAccess.Write, FileShare.None);

            using (inPdfStream)
            using (outPdfStream)
            {
                var reader = new PdfReader(inPdfStream);
                var stamper = new PdfStamper(reader, outPdfStream);
                var pdfContentByte = stamper.GetOverContent(reader.NumberOfPages);

                using (reader)
                using (stamper)
                {
                    Image image = Image.GetInstance(qrData.ImageData,ImageFormat.Jpeg);
                    image.Alignment = Element.ALIGN_LEFT;
                    image.SetAbsolutePosition(20f, 30f);
                    image.ScaleAbsolute(65f, 65f);
                    pdfContentByte.AddImage(image);

                    AddQrText(pdfContentByte, qrData);

                    inPdfStream.Close();
                }
            }

            File.Delete(FileLocation);
            File.Move(outPdf, FileLocation);
        }

        private void AddQrText(PdfContentByte content, QrData data)
        {
            content.BeginText();

            float fontSize = 10f;

            string fontPlace = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.Fonts), "times.TTF");

            var baseFont = BaseFont.CreateFont(fontPlace, BaseFont.IDENTITY_H, BaseFont.EMBEDDED);

            content.SetFontAndSize(baseFont, fontSize-2f);
            

            float xPoint = 85f;
            float yPoint = 82f;

            foreach (var dataText in data.Input)
            {
                content.ShowTextAligned(PdfContentByte.ALIGN_LEFT, dataText, xPoint, yPoint, 0);

                yPoint -= fontSize + 1;
            }

            content.EndText();
        }
    }
}
