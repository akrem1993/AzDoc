using AppCore.Interfaces;
using AzDoc.BaseControllers;
using AzDoc.Helpers;
using BLL.Adapters;
using BLL.CoreAdapters;
using CustomHelpers;
using Microsoft.Ajax.Utilities;
using Model.Models.File;
using Repository.Infrastructure;
using System;
using System.IO;
using System.Web;
using System.Web.Mvc;

namespace AzDoc.Controllers
{
    public class ESignController : BaseController
    {
        public ESignController(IUnitOfWork unitOfWork) : base(unitOfWork) { }

        [HttpPost]
        public JsonResult ReceiveSignedDoc(HttpPostedFileBase files, string description)
        {
            string filePath = "";

            if (UploadControlHelper.UploadEDocFile(files, ref filePath))
            {
                //var result = SignDoc(description, out int splitDocId);
                using (DocumentAdapter documentAdapter = new DocumentAdapter(unitOfWork))
                {
                    documentAdapter.PostActionOperation(7,
                                                        Token.DocId,
                                                        SessionHelper.WorkPlaceId,
                                                        description,
                                                        out int result);


                    if (result == 7)
                    {
                        using (FileAdapter fileAdapter = new FileAdapter(unitOfWork))
                        {
                            fileAdapter.AddSignedFilesInfo(Token.DocId,
                                                           SessionHelper.WorkPlaceId,
                                                           SessionHelper.UserId,
                                                           20,
                                                           filePath,
                                                           description);
                            return Json(true);
                        }
                    }
                }
            }

            return Json(false);
        }

        public int SignDoc(string desc)
        {
            using (DocumentAdapter documentAdapter = new DocumentAdapter(unitOfWork))
            {
                documentAdapter.PostActionOperation(7,
                                                        Token.DocId,
                                                        SessionHelper.WorkPlaceId,
                                                        desc,
                                                        out int result);
                CacheDoc();
                return result;
            }
        }

        [HttpPost]
        public JsonResult SignDocNotESign(string desc)
        {
            var result = SignDoc(desc) == 7;
            CacheDoc();

            return Json(result);
        }

        [HttpGet]
        public JsonResult GetMainFile()
        {
            using (FileAdapter adapter = new FileAdapter(unitOfWork))
            {
                DocsFileInfoModel mainFile = adapter.GetMainFileByDocId(Token.DocId);

                byte[] fileBuffer = SFTPHelper.DownloadFileBuffer(mainFile.FileInfoPath);

                return new JsonResult
                {
                    Data = new { Base64 = Convert.ToBase64String(fileBuffer), FileName = mainFile.FileInfoName },
                    JsonRequestBehavior = JsonRequestBehavior.AllowGet,
                    MaxJsonLength = int.MaxValue
                };
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public JsonResult GetSignedFile()
        {
            using (FileAdapter adapter = new FileAdapter(unitOfWork))
            {
                DocsFileInfoModel signedFile = adapter.GetSignedFileByDocId(Token.DocId);

                byte[] fileBuffer = SFTPHelper.DownloadEDocFileBuffer(signedFile.FileInfoPath);

                var fileName = Path.GetFileName(signedFile.FileInfoPath);

                return new JsonResult
                {
                    Data = new { Base64 = Convert.ToBase64String(fileBuffer), FileName = fileName },
                    JsonRequestBehavior = JsonRequestBehavior.AllowGet,
                    MaxJsonLength = int.MaxValue
                };
            }
        }
    }
}