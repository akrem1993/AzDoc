using System;
using AzDoc.Helpers;
using BLL.Adapters;
using BLL.Models.Document;
using Model.DB_Views;
using Model.Models.File;
using Repository.Infrastructure;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using BLL.CoreAdapters;
using CustomHelpers;
using Microsoft.Ajax.Utilities;
using AppCore.Interfaces;
using AzDoc.BaseControllers;
using System;
using AzDoc.Helpers;
using BLL.Adapters;
using BLL.Models.Document;
using Model.DB_Views;
using Model.Models.File;
using Repository.Infrastructure;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using BLL.CoreAdapters;
using CustomHelpers;
using Microsoft.Ajax.Utilities;
using AppCore.Interfaces;
using AzDoc.BaseControllers;
using DMSModel;
using ORM.Context;
using Repository.UnitOfWork;
using RestSharp;

namespace AzDoc.Controllers
{
    public class FileController : BaseController
    {
        public FileController(IUnitOfWork unitOfWork) : base(unitOfWork)
        {
        }

        /// <summary>
        /// Qosma senedler bolmesinde file upload etdikden sonra elave edilmis file-lari grid-e elave edir
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("/{lang}/InsDoc/File/CallBackUploadFilesPartial")]
        public ActionResult CallBackUploadFilesPartial()
        {
            int splitDocId = -1;

            if (Request.QueryString["token"] != null)
            {
                var token = CustomHelper.Decrypt(HttpUtility.UrlDecode(Request.QueryString["token"]));
                splitDocId = token.Split('-')[2].ToInt();
            }

            using (var adapter = new FileAdapter(unitOfWork))
            {
                var data = adapter.GetByDocId(splitDocId);
                return PartialView("CallBackUploadFilesPartial", data);
            }
        }

        /// <summary>
        /// File upload olan zaman fayli SFTP servere yazmaq ve fayli baglamaq ucun lazim olan documenti yaradir
        /// </summary>
        /// <param name="hFileInfoId">Yuklenmis fayl deyisilen zaman evvelki faylin id-sini saxlayir</param>
        /// <returns></returns>
        [HttpPost]
        public JsonResult UploadFileAction(string hFileInfoId)
        {
            bool result = false;
            int parentId = -1;
            int splitDocId = -1;

            if (!string.IsNullOrEmpty(hFileInfoId))
                parentId = int.Parse(hFileInfoId);

            var token = CustomHelper.Decrypt(HttpUtility.UrlDecode(Request.QueryString["token"]));

            if (!token.IsNullOrWhiteSpace())
                splitDocId = token.Split('-')[2].ToInt();

            DocsFileInfoModel fileInfo = new DocsFileInfoModel();

            foreach (string fileName in Request.Files)
            {
                UploadControlHelper.UploadFile(Request.Files[fileName], fileInfo, ref result);
            }

            int newDocId = -1;
            if (result)
            {
                using (FileAdapter fileAdapter = new FileAdapter(unitOfWork))
                {
                    newDocId = fileAdapter.CreateOrChangeFile(fileInfo,
                        parentId,
                        splitDocId,
                        SessionHelper.WorkPlaceId,
                        SessionHelper.DocTypeId);
                }
            }

            if (newDocId != -1)
                return Json(TokenHelper.CreateToken(newDocId));

            return Json(newDocId);
        }

        public int GetByCurrentDocId(string fileInfoId)
        {
            using (var adapter = new FileAdapter(unitOfWork))
            {
                return adapter.GetFileInfoIdByDocId(fileInfoId.ToInt());
            }
        }

        /// <summary>
        /// Yuklenmis faylin seyfe ve nusxe sayini update edir
        /// </summary>
        /// <param name="fileInfoId">secilmis fayl</param>
        /// <param name="page">seyfe sayi</param>
        /// <param name="copy">nusxe sayi</param>
        /// <returns></returns>
        [HttpPost]
        public JsonResult FileInfoUpdate(int fileInfoId, int page, int copy)
        {
            using (FileAdapter fileAdapter = new FileAdapter(unitOfWork))
            {
                bool result = fileAdapter.FileInfoUpdate(fileInfoId, page, copy);

                CacheDoc();
                return Json(result);
            }
        }


        /// <summary>
        /// Secilmis fayli esas fayl kimi teyin edir
        /// </summary>
        /// <param name="fileInfoId">secilmis fayl</param>
        /// <param name="signerWorkPlaceId">imza eden wexsin WorkPlaceId-si</param>
        /// <param name="answerDocIds">elave edilen cavab senedleri</param>
        /// <returns></returns>
        [HttpPost]
        public ActionResult SetMainFile(int fileInfoId, int? signerWorkPlaceId, string answerDocIds)
        {
            using (FileAdapter fileAdapter = new FileAdapter(unitOfWork))
            {
                DocsFileInfoModel file = fileAdapter.GetFileInfoById(fileInfoId);

                if (file == null)
                    return HttpNotFound();

                Task.Factory.StartNew(async () =>
                {
                    var doc = file.FileDocId;
                    byte[] fileBuffer = SFTPHelper.DownloadFileBuffer(file.FileInfoPath);
                    using (var context = new EFUnitOfWork<DMSContext>())
                    {
                        var fileInfoEntity = context.GetRepository<DOCS_FILEINFO>().GetByIdAsync(fileInfoId).Result;
                        fileInfoEntity.FileExtractedText = await ReadFileWithOcrAsync(fileBuffer, file.FileInfoName);
                        context.SaveChanges();
                        CacheDoc(doc);
                    }
                });


                bool result = fileAdapter.DefaultAgreementScheme(fileInfoId,
                    answerDocIds,
                    SessionHelper.RelatedDocId,
                    signerWorkPlaceId,
                    SessionHelper.WorkPlaceId,
                    SessionHelper.DocTypeId);

                CacheDoc(file.FileDocId);

                return Json(result);
            }
        }


        private async Task<string> ReadFileWithOcrAsync(byte[] buffer, string name)
        {
            using (var client = new RestClient("https://docs.rabita.az/ocr/readFile"))
            {
                var request = new RestRequest
                {
                    Method = Method.Post,
                    AlwaysMultipartFormData = true,
                    Timeout = -1
                };

                request.AddFile("file", buffer, name);

                var response = await client.ExecuteAsync(request);

                if (response.IsSuccessful)
                {
                    return response.Content;
                }

                return string.Empty;
            }
        }

        /// <summary>
        /// Secilmis fayli silir
        /// </summary>
        /// <param name="fileInfoId">secilmis fayl</param>
        /// <returns></returns>
        [HttpPost]
        public JsonResult DeleteFile(int fileInfoId)
        {
            using (FileAdapter fileAdapter = new FileAdapter(unitOfWork))
            {
                bool result = fileAdapter.DeleteFile(fileInfoId);

                CacheDoc();
                return Json(result);
            }
        }

        public ActionResult DownloadFile(int fileInfoId)
        {
            using (FileAdapter adapter = new FileAdapter(unitOfWork))
            {
                DocsFileInfoModel file = adapter.GetFileInfoById(fileInfoId);

                if (file == null)
                    return HttpNotFound();

                byte[] fileBuffer = SFTPHelper.DownloadFileBuffer(file.FileInfoPath);

                return File(fileBuffer, System.Net.Mime.MediaTypeNames.Application.Octet, file.FileInfoName);
            }
        }


        /// <summary>
        /// Razilasma sxemi grid
        /// </summary>
        /// <param name="fileInfoId">secilmis fayl</param>
        /// <returns></returns>
        [HttpGet]
        public ActionResult AgreementSchemeGridPartial(int fileInfoId)
        {
            using (VizaAdapter vizaAdapter = new VizaAdapter(unitOfWork))
            {
                List<VW_DOCS_VIZA> model = vizaAdapter
                    .GetVizaByFileInfoId(SessionHelper.FileInfoId = fileInfoId)
                    .ToList();

                return PartialView("_AgreementScheme", model);
            }
        }

        [HttpGet]
        public JsonResult AddNewVizaExecutors(int toPersonWorkPlaceId, int orderIndex)
        {
            var token = CustomHelper.Decrypt(HttpUtility.UrlDecode(Request.QueryString["token"]));
            int splitDocId = 0;

            if (!token.IsNullOrWhiteSpace())
                splitDocId = token.Split('-')[2].ToInt();

            using (VizaAdapter vizaAdapter = new VizaAdapter(unitOfWork))
            {
                int result = vizaAdapter.AddNewVizaExecutors(
                    SessionHelper.FileInfoId,
                    splitDocId,
                    orderIndex,
                    SessionHelper.WorkPlaceId,
                    toPersonWorkPlaceId);
                CacheDoc();

                return Json(result, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpPost]
        public JsonResult VizaDelete(int vizaId)
        {
            using (VizaAdapter vizaAdapter = new VizaAdapter(unitOfWork))
            {
                var res = vizaAdapter.VizaDelete(vizaId);
                CacheDoc();
                return Json(res);
            }
        }
    }
}