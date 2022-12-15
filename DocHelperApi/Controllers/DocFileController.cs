using System;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Hosting;
using System.Web.Http;
using AppCore.Models;
using BLL.Adapters;
using BLL.CoreAdapters;
using BLL.Models.Document;
using CustomHelpers;
using DocFileHelper.Core;
using DocFileHelper.Modifier.Services;
using DocFileHelper.SFTP;
using ORM.Context;
using Repository.UnitOfWork;

namespace DocHelperApi.Controllers
{
    [RoutePrefix("docs")]
    public class DocFileController : BaseApiController
    {
        [HttpGet]
        [Route("e-doc")]
        public HttpResponseMessage ElectronicDocument(string docId)
        {
            try
            {
                var status = int.TryParse(HttpUtility.UrlEncode(CustomHelper.Decrypt(docId)), out int decryptedDocId);

                if (string.IsNullOrWhiteSpace(docId) || !status)
                    return NotFoundMessage();

                using (var unitOfWork = new EFUnitOfWork<DMSContext>())
                using (var fileAdapter = new FileAdapter(unitOfWork))
                using (var docAdapter = new CoreAdapter(unitOfWork))
                {
                    BaseElectronDoc electronDoc = docAdapter.ElectronDocView<BaseElectronDoc>(decryptedDocId, -1);
                    electronDoc.DocId = decryptedDocId;


                    var docFiles = fileAdapter.GetByDocId(decryptedDocId);

                    if (docFiles is null) return NotFoundMessage();

                    var mainFile = docFiles.FirstOrDefault(x => x.FileIsMain && x.SignatureStatusId == 2);

                    if (mainFile is null) return NotFoundMessage();

                    var docFileInfo = fileAdapter.GetFileInfoById(mainFile.FileInfoId);

                    var mainFileBuffer = SFTPHelper.DownloadFileBuffer(docFileInfo.FileInfoPath);

                    string tempFilePath = _appSettingPath.UploadTemp +
                                          $"//{docFileInfo.FileInfoGuId}{docFileInfo.FileInfoExtention}";

                    Directory.CreateDirectory(_appSettingPath.UploadTemp);

                    File.WriteAllBytes(tempFilePath, mainFileBuffer);

                    var convertResult = new FileConverter().ConvertWordToPdf(tempFilePath);

                    if (!convertResult.IsConverted) return NotFoundMessage();

                    DocFileModifier.AppendQrToFile(electronDoc, _appSettingPath, convertResult.TempPath);

                    var result = new HttpResponseMessage(HttpStatusCode.OK)
                    {
                        Content = new StreamContent(File.OpenRead(convertResult.TempPath))
                    };

                    result.Content.Headers.ContentType =
                        new System.Net.Http.Headers.MediaTypeHeaderValue("application/pdf");

                    return result;
                }
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.BadRequest,
                    "Xəta baş verdi! Sənədə uyğun fayl təyin edilməmişdir və ya sənəd düzgün daxil edilməmişdir. Zəhmət olmasa bir daha cəhd edin.ex:" +
                    ex.Message);
            }
        }

        HttpResponseMessage NotFoundMessage()
        {
            return Request.CreateResponse(HttpStatusCode.NotFound, "Sənədin nömrəsini düzgün daxil edin!");
        }

        
    }
}