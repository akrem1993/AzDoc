using DMSModel;
using System;
using System.IO;
using System.Text;
using System.Web;
using iTextSharp.text.pdf;
using iTextSharp.text.pdf.parser;
using Model.Models.File;
using LogHelpers;
using Path = System.IO.Path;

namespace AzDoc.Helpers
{
    public class UploadControlHelper
    {
        /// <summary>
        /// File stream ile isleyir deye daha tez isleyir
        /// </summary>
        /// <param name="uploadedFile"></param>
        /// <param name="fileInfo"></param>
        /// <param name="result"></param>
        public static void UploadFile(HttpPostedFileBase uploadedFile, DocsFileInfoModel fileInfo, ref bool result)
        {
            if (uploadedFile == null || uploadedFile.ContentLength == 0)
                return;

            try
            {
                fileInfo.FileInfoGuId = Guid.NewGuid().ToString();
                fileInfo.FileInfoWorkplaceId = SessionHelper.WorkPlaceId;
                fileInfo.FileInfoCapacity = uploadedFile.ContentLength;
                fileInfo.FileInfoName = uploadedFile.FileName;
                fileInfo.FileInfoExtention = Path.GetExtension(uploadedFile.FileName);
                fileInfo.FileInfoInsertdate = DateTime.Now;
                fileInfo.FileInfoVersion = 1;


                string path = Helper.GetFilePath(); //Faylın yolu: 2018/1/4/9 (il,təşkilatın id-si,ay,gün)

                string fileName =
                    string.Concat(fileInfo.FileInfoGuId, fileInfo.FileInfoExtention); //Faylin tam adini aliriq

                fileInfo.FileInfoPath = $"{path}/{fileName}"; //Faylın yolu adı ilə birlikdə: 2018/1/4/9/xxx.doc

                string localTempPath = HttpContext.Current.Server.MapPath($@"~\App_Data\UploadTemp\{fileName}");
                uploadedFile.SaveAs(localTempPath);

                SFTPHelper.UploadLocalTempFile(localTempPath, fileName); //Yazılan faylı sftp-iyə göndəririk

                result = true; //Əməliyyat xətasız olarsa client side -a ok sözü göndərilir
            }
            catch (Exception ex)
            {
                SessionHelper.TempFile = null;
                Log.AddError(ex.Message, ex.Source, "UploadFile Sftp");
                result = false;
                throw;
            }
        }

        //public static bool UploadEDocFile(HttpPostedFileBase uploadedFile, ref string filePath)
        //{
        //    if(uploadedFile == null || uploadedFile.ContentLength == 0)
        //        return false;

        //    try
        //    {
        //        string path = Helper.GetFilePath();//Faylın yolu: 2018/1/4/9 (il,təşkilatın id-si,ay,gün)
        //        filePath = $"{Helper.EdocServerPath}'/'{Helper.GetFilePath()}";//Faylın yolu adı ilə birlikdə: 2018/1/4/9/xxx.doc
        //        string localTempPath = HttpContext.Current.Server.MapPath($@"~\App_Data\UploadTemp\{uploadedFile.FileName}");
        //        uploadedFile.SaveAs(localTempPath);

        //        SFTPHelper.UploadEDocTempFile(localTempPath, uploadedFile.FileName);//Yazılan faylı sftp-iyə göndəririk

        //        return true;
        //    }
        //    catch(Exception ex)
        //    {
        //        SessionHelper.TempFile = null;
        //        Log.AddError(ex.Message, ex.Source, "UploadEDocFile Sftp");
        //        return false;
        //    }
        //}
        public static bool UploadEDocFile(HttpPostedFileBase uploadedFile, ref string filePath)
        {
            if (uploadedFile == null || uploadedFile.ContentLength == 0)
                return false;

            try
            {
                var fileName = uploadedFile.FileName;
                filePath = $"{Helper.GetFilePath()}/{fileName}"; //Faylın yolu adı ilə birlikdə: 2018/1/4/9/xxx.doc
                string localTempPath = HttpContext.Current.Server.MapPath($@"~\App_Data\UploadTemp\{fileName}");
                uploadedFile.SaveAs(localTempPath);

                SFTPHelper.UploadEDocTempFile(localTempPath, uploadedFile.FileName); //Yazılan faylı sftp-iyə göndəririk

                return true;
            }
            catch (Exception ex)
            {
                SessionHelper.TempFile = null;
                Log.AddError(ex.Message, ex.Source, "UploadEDocFile Sftp");
                return false;
            }
        }


        /// <summary>
        /// Gec isleyir byte array ile islediyi ucun
        /// </summary>
        /// <param name="uploadedFile"></param>
        /// <param name="fileInfo"></param>
        /// <param name="result"></param>
        public static void UploadFileWithBuffer(HttpPostedFileBase uploadedFile, DocsFileInfoModel fileInfo,
            ref bool result)
        {
            if (uploadedFile == null || uploadedFile.ContentLength == 0)
                return;

            try
            {
                fileInfo.FileInfoGuId = Guid.NewGuid().ToString();
                fileInfo.FileInfoWorkplaceId = SessionHelper.WorkPlaceId;
                fileInfo.FileInfoCapacity = uploadedFile.ContentLength;
                fileInfo.FileInfoName = uploadedFile.FileName;
                fileInfo.FileInfoExtention = Path.GetExtension(uploadedFile.FileName);
                fileInfo.FileInfoInsertdate = DateTime.Now;
                fileInfo.FileInfoVersion = 1;

                string path = Helper.GetFilePath(); //Faylın yolu: 2018/1/4/9 (il,təşkilatın id-si,ay,gün)

                fileInfo.FileInfoPath =
                    $"{path}/{fileInfo.FileInfoGuId}{fileInfo.FileInfoExtention}"; //Faylın yolu adı ilə birlikdə: 2018/1/4/9/xxx.doc

                string fileName =
                    string.Concat(fileInfo.FileInfoGuId, fileInfo.FileInfoExtention); //Faylin tam adini aliriq

                byte[] fileBuffer = ReadStreamByte(uploadedFile.InputStream); //Faylin bufferini aliriq

                SFTPHelper.UploadFile(fileName, fileBuffer); //Yazılan faylı sftp-iyə göndəririk

                result = true; //Əməliyyat xətasız olarsa client side -a ok sözü göndərilir
            }
            catch (Exception ex)
            {
                SessionHelper.TempFile = null;
                Log.AddError(ex.Message, ex.Source, "UploadFile Sftp");
                result = false;
            }
        }

        private static byte[] ReadStreamByte(Stream stream)
        {
            using (MemoryStream memory = new MemoryStream())
            {
                stream.CopyTo(memory);
                return memory.ToArray();
            }
        }

        public static DOCS_FILEINFO UploadDocsFile(HttpPostedFileBase uploadedFile)
        {
            if (uploadedFile == null || uploadedFile.ContentLength == 0)
                return null;

            try
            {
                DOCS_FILEINFO fileInfo = new DOCS_FILEINFO
                {
                    FileInfoGuId = Guid.NewGuid().ToString(),
                    FileInfoWorkplaceId = SessionHelper.WorkPlaceId,
                    FileInfoCapacity = uploadedFile.ContentLength,
                    FileInfoName = uploadedFile.FileName,
                    FileInfoExtention = Path.GetExtension(uploadedFile.FileName),
                    FileInfoInsertdate = DateTime.Now,
                    FileInfoVersion = 1
                };

                string path = Helper.GetFilePath(); //Faylın yolu: 2018/1/4/9 (il,təşkilatın id-si,ay,gün)

                fileInfo.FileInfoPath =
                    $"{path}/{fileInfo.FileInfoGuId}{fileInfo.FileInfoExtention}"; //Faylın yolu adı ilə birlikdə: 2018/1/4/9/xxx.doc

                string fileName =
                    string.Concat(fileInfo.FileInfoGuId, fileInfo.FileInfoExtention); //Faylin tam adini aliriq

                byte[] fileBuffer = ReadStreamByte(uploadedFile.InputStream); //Faylin bufferini aliriq

                SFTPHelper.UploadFile(fileName, fileBuffer); //Yazılan faylı sftp-iyə göndəririk

                return fileInfo;
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, ex.Source, "UploadDocsFile Sftp");
                return null;
            }
        }
    }
}