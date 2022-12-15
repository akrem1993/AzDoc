using DocFileHelper.Modifier.Models;
using GleamTech.DocumentUltimate;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using DocFileHelper.Core;
using iTextSharp.text.pdf;
using Tesseract;


namespace DocFileHelper.Modifier.Services
{
    public class FileConverter
    {
        public FileConvertResult ConvertWordToPdf(string filePath)
        {
            if (!File.Exists(filePath)) throw new ArgumentException("File not exist");

            var fileExtension = Path.GetExtension(filePath).ToLower();

            if (fileExtension != ".docx" && fileExtension != ".doc")
                return new FileConvertResult
                {
                    TempPath = filePath,
                    IsConverted = true,
                    FileExtension = fileExtension
                };

            var currentFileFormat = fileExtension == ".docx"
                ? DocumentFormat.Docx
                : DocumentFormat.Doc;

            var converter = new DocumentConverter(filePath, currentFileFormat);

            if (!converter.CanConvertTo(DocumentFormat.Pdf)) throw new Exception("Cannot convert this file to pdf");

            var res = converter.ConvertTo(DocumentFormat.Pdf);

            if (res.OutputFiles.Any())
            {
                return new FileConvertResult
                {
                    FileExtension = fileExtension + ".pdf",
                    TempPath = res.OutputFiles.First(),
                    IsConverted = true
                };
            }

            return null;
        }

        public FileConvertResult ConvertTo(Stream stream, string fileName)
        {
            DocumentFormat docFormat = DocumentFormat.Pdf;
            var converter = new DocumentConverter(stream, docFormat);

            if (!converter.CanConvertTo(docFormat))
                throw new Exception("Cannot convert this file to pdf");

            var res = converter.ConvertTo(DocumentFormat.Pdf);

            if (res.OutputFiles.Any())
            {
                return new FileConvertResult
                {
                    FileExtension = fileName + "." + docFormat.ToString().ToLower(),
                    TempPath = res.OutputFiles.First(),
                    IsConverted = true
                };
            }

            return null;
        }

        private DocumentFormat FileFormat(string fileName)
        {
            var fileExtension = Path.GetExtension(fileName).ToLower();
            switch (fileExtension)
            {
                case ".pdf": return DocumentFormat.Pdf;
                case ".png": return DocumentFormat.Jpg;
                case ".jpg": return DocumentFormat.Jpg;
                case ".doc":
                case ".docx": return DocumentFormat.Docx;

                default:
                    return DocumentFormat.Pdf;
            }
        }

        public async Task<string> GetStringFromFile(string fileTempPath, Stream fileStream, string fileName,
            string fileLang)
        {
            var fileExtension = Path.GetExtension(fileName);

            if (!new[] {".pdf", ".png", ".jpg", ".doc", ".docx"}.Contains(fileExtension.ToLower()))
                return string.Empty;

            var res = new StringBuilder();

            if (new[] {".pdf", ".doc", ".docx"}.Contains(fileExtension))
            {
                var converter = new DocumentConverter(fileTempPath, FileFormat(fileName));

                if (!converter.CanConvertTo(DocumentFormat.Jpg))
                    return string.Empty;

                var converterResult = converter.ConvertTo(DocumentFormat.Jpg);

                if (!converterResult.OutputFiles.Any())
                    return string.Empty;

                res.Append((await GetTextFromFiles(converterResult.OutputFiles, fileLang)));
            }
            else
            {
                res.Append((await GetTextFromFiles(new[] {fileTempPath}, fileLang)));
            }

            File.Delete(fileTempPath);
            return res.ToString();
        }


        class UploadFiles
        {
            public int Order { get; set; }

            public string FilePath { get; set; }

            public string FileText { get; set; }
        }

        private static async Task<string> GetTextFromFiles(string[] files, string lang)
        {
            if (!files.Any())
                return string.Empty;

            var enginePath = HttpContext.Current.Server.MapPath(@"~/tessdata");

            var uploadFiles = new List<UploadFiles>();
            for (int i = 0; i < files.Count(); i++)
            {
                uploadFiles.Add(new UploadFiles {Order = i, FilePath = files[i]});
            }

            Parallel.ForEach(uploadFiles, x =>
            {
                using (var engine = new TesseractEngine(enginePath, lang, EngineMode.Default))
                using (var img = Pix.LoadFromFile(x.FilePath))
                using (var page = engine.Process(img))
                {
                    x.FileText = page.GetText();
                    File.Delete(x.FilePath);
                }
            });

            var res = uploadFiles
                .OrderBy(x => x.Order)
                .Select(x => x.FileText)
                .Aggregate((x, y) => x + y);

            return await Task.FromResult(res);
        }

        private static byte[] ImageToBytes(Image image)
        {
            ImageConverter converter = new ImageConverter();
            return (byte[]) converter.ConvertTo(image, typeof(byte[]));
        }

        private static byte[] StreamToByteArray(Stream input)
        {
            using (MemoryStream ms = new MemoryStream())
            {
                input.CopyTo(ms);
                return ms.ToArray();
            }
        }
    }
}