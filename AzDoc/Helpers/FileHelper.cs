using AppCore.Interfaces;
using BLL.CoreAdapters;
using BLL.Models.Document;
using DocFileHelper.Core;
using DocFileHelper.Modifier.Services;
using Model.Models.File;
using Repository.Infrastructure;
using System;
using System.IO;
using System.Threading.Tasks;

namespace AzDoc.Helpers
{
    public static class FileHelper
    {
        public static DocsFileInfoModel GetDocFileBuffer(this IUnitOfWork unitOfWork, int fileInfoId, IServerPath serverPath)
        {
            using (var adapter = new FileAdapter(unitOfWork))
            {
                DocsFileInfoModel file = adapter.GetFileInfoById(fileInfoId);

                if (file is null)
                    throw new Exception("FILE NOT FOUND");

                var fileBuffer = SFTPHelper.DownloadFileBuffer(file);
                file.FileInfoBinary = fileBuffer;

                file.SaveToTemp(serverPath);

                return file;
            }
        }

        public static DocsFileInfoModel GetEDocFileBuffer(this IUnitOfWork unitOfWork, int docId)
        {
            using (var adapter = new FileAdapter(unitOfWork))
            {
                DocsFileInfoModel file = adapter.GetSignedFileByDocId(docId);

                if (file is null)
                    throw new Exception("FILE NOT FOUND");

                file.FileInfoBinary = SFTPHelper.DownloadEDocFileBuffer(file.FileInfoPath);

                return file;
            }
        }

        public static DocsFileInfoModel GetDocFileBuffer(this IUnitOfWork unitOfWork, BaseElectronDoc model, IServerPath serverPath)
        {
            var file = GetDocFileBuffer(unitOfWork, model.FileInfoId, serverPath);

            model.MainFileInfo = new DocFileInfo
            {
                Base64 = Convert.ToBase64String(file.FileInfoBinary),
                Name = file.FileInfoName
            };

            return file;
        }

        public static void SaveToTemp(this DocsFileInfoModel file, IServerPath serverPath)
        {
            string fileName = file.FileInfoGuId + file.FileInfoExtention;
            string tempPath = serverPath.UploadTemp + fileName;

            File.WriteAllBytes(tempPath, file.FileInfoBinary);

            file.LocalTempPath = tempPath;
        }

        public static string AppendQr(this DocsFileInfoModel file, BaseElectronDoc model, IServerPath serverPath)
        {
            if (model.FileSignatureStatus == 2)
            {
                var result = new FileConverter().ConvertWordToPdf(file.LocalTempPath);

                var filePath = result.IsConverted ? result.TempPath : file.LocalTempPath;

                DocFileModifier.AppendQrToFile(model, serverPath, filePath);

                return filePath;
            }

            return file.LocalTempPath;
        }

        public static async Task<string> GetDocFileViewAsync(this IUnitOfWork unitOfWork, BaseElectronDoc model, IServerPath serverPath)
        {
            //if (model.FileSignatureStatus == 2)
            //{
            //    await Task.Run(() =>
            //    {
            //        var file = GetEDocFileBuffer(unitOfWork, model.DocId);

            //        model.SignedFileInfo = new DocFileInfo
            //        {
            //            Base64 = Convert.ToBase64String(file.FileInfoBinary),
            //            Name = Path.GetFileName(file.FileInfoPath)
            //        };
            //    }).ConfigureAwait(false);
            //}

            return await Task.Run(() => GetDocFileView(unitOfWork, model, serverPath)).ConfigureAwait(false);
        }

        public static string GetDocFileView(this IUnitOfWork unitOfWork, BaseElectronDoc model, IServerPath serverPath)
        {
            if (model.FileInfoId > 0)
            {
                var file = unitOfWork.GetDocFileBuffer(model, serverPath);

                return AppendQr(file, model, serverPath);
            }

            return string.Empty;
        }
    }
}