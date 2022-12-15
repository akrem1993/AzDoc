using System;
using System.Threading.Tasks;
using System.Web.Mvc;
using AzDoc.Attributes;
using AzDoc.BaseControllers;
using AzDoc.Helpers;
using BLL.Common.Enums;
using BLL.CoreAdapters;
using OrgRequests.Model.EntityModel;
using OrgRequests.Model.ViewModel;
using Repository.Infrastructure;
using Widgets.Helpers;
using ActionNameViewModel = BLL.Models.Document.ViewModel.ActionNameViewModel;
using BllDocumentAdapter = BLL.Adapters.DocumentAdapter;
using DocumentAdapter = OrgRequests.Adapters.DocumentAdapter;
using ElectronicDocumentViewModel = OrgRequests.Model.ViewModel.ElectronicDocumentViewModel;

namespace AzDoc.Areas.OrgRequests.Controllers
{
    [DocTypeMark(DocType.OrgRequests)]
    public class DocumentController : BaseController
    {
        private const int DocTypeId = (int)DocType.OrgRequests;

        public DocumentController(IUnitOfWork unitOfWork) : base(unitOfWork) { }

        public ActionResult Index()
        {
            if (Request.UrlReferrer == null && TempData["IsReturn"] == null)
                return Redirect();

            SessionHelper.DocTypeId = DocTypeId;

            using (BllDocumentAdapter adapter = new BllDocumentAdapter(unitOfWork))
            {
                var documentGroup = adapter.GetDocumentGroupModel(DocTypeId);

                if (documentGroup != null)
                {
                    ViewData["DocTypeName"] = documentGroup.TreeName;
                    ViewData["DocTypeGroupName"] = documentGroup.DocTypeGroupName;
                }
            }
            return View("~/Areas/OrgRequests/Views/Document/Index.cshtml");
        }

        [HttpPost]
        public async Task<JsonResult> Document(int? periodId, int pageIndex = 1, int pageSize = 20)
        {
            using (var docAdapter = new DocGridAdapter(unitOfWork))
            {
                SessionHelper.ClearDocId();

                var docs = await docAdapter.GetDocsAsyncNew<DocumentGridModel>(SessionHelper.WorkPlaceId,
                    periodId,
                    DocTypeId,
                    pageIndex,
                    pageSize,
                    Request.ToSqlParams());

                return Json(docs);
            }
        }



        [HttpGet]
        [CheckSftp]
        [Permission(RightType.CreateDoc)]
        public ActionResult AddNewDocument()
        {
            if (Request.UrlReferrer == null)
                return Redirect();

            SessionHelper.ClearHelperSession();
            SessionHelper.ClearDocId();
            using (DocumentAdapter adapter = new DocumentAdapter(unitOfWork))
            {
                DocumentViewModel model = new DocumentViewModel(
                    adapter,
                    DocTypeId,
                    SessionHelper.WorkPlaceId);

                return View("~/Areas/OrgRequests/Views/Document/AddNewDocument.cshtml", model);
            }
        }


        [HttpGet]
        public JsonResult GetRelatedDocument()
        {
            using (DocumentAdapter adapter = new DocumentAdapter(unitOfWork))
            {
                var model = adapter.GetRelatedDocModel();
                return Json(model, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpGet]
        public ActionResult GetDocumentActions(int docId, int menuTypeId, int executorId)
        {
            using (BllDocumentAdapter adapter = new BllDocumentAdapter(unitOfWork))
            {
                ActionNameViewModel model = new ActionNameViewModel
                {
                    ActionNameModels = adapter.GetDocumentActions(docId, SessionHelper.WorkPlaceId, menuTypeId, executorId),
                    DocId = docId,
                    Token = TokenHelper.CreateToken(docId)
                };

                SessionHelper.ResolutionDocId = docId;

                return PartialView("~/Views/Document/ActionNamePartial.cshtml", model);
            }
        }



        [HttpGet]
        public ActionResult EditDocument()
        {
            SessionHelper.ClearDocId();

            using (DocumentAdapter adapter = new DocumentAdapter(unitOfWork))
            {
                DocumentViewModel model = new DocumentViewModel(adapter, DocTypeId, Token.WorkPlaceId, Token.DocId);
                return View("~/Areas/OrgRequests/Views/Document/EditDocument.cshtml", model);
            }
        }


        [HttpGet]
        public ActionResult ElectronicDocument(int docId, int executorId)
        {
            using (var coreAdapter = new CoreAdapter(unitOfWork))
            using (var docInfoAdapter = new DocInfoAdapter(unitOfWork))
            {
                var workplace = SessionHelper.WorkPlaceId;

                var model = coreAdapter.ElectronDocView<ElectronicDocumentViewModel>(
                    docId,
                    workplace,
                    1,
                    executorId);

                var fileTask = unitOfWork.GetDocFileViewAsync(model, serverPath);

                SessionHelper.ResolutionDocId = docId;
                model.Token = TokenHelper.CreateToken(docId);

                TempData["DocumentView"] = fileTask.GetAwaiter().GetResult();

                return View("~/Areas/OrgRequests/Views/Document/ElectronicDocument.cshtml", model);
            }
        }

        [HttpGet]
        public ActionResult DocumentDisplay(int docInfoId)
        {
            var file = DownloadFile(docInfoId);
            TempData["DocumentView"] = string.Format(@"~/App_Data/UploadTemp/" + file.FileDownloadName);
            return PartialView("~/Areas/OrgRequests/Views/Document/DocumentDisplay.cshtml");
        }


        [HttpGet]
        public FileContentResult DownloadFile(int fileInfoId)
        {
            if (fileInfoId == default(int))
                throw new ArgumentException($"Fayl tapılmadı.File Id:{fileInfoId}");

            using (DocumentAdapter adapter = new DocumentAdapter(unitOfWork))
            {
                FileInfoModel model = adapter.ElectronicDocument(fileInfoId);

                if (model == null) return null;

                byte[] fileBuffer = SFTPHelper.DownloadFileBuffer(model.FileInfoPath);

                string fileName = model.FileInfoGuId + model.FileInfoExtention;

                MapForDocumentViewer(fileName, fileBuffer);
                return File(fileBuffer, System.Net.Mime.MediaTypeNames.Application.Octet, fileName);
            }
        }


        /// <summary>
        /// Muveqqeti DocumentViewer ucun
        /// </summary>
        private void MapForDocumentViewer(string fileName, byte[] fileBuffer)
        {
            string localTempPath = Server.MapPath(@"~\App_Data\UploadTemp") + "\\" + fileName;

            System.IO.File.WriteAllBytes(localTempPath, fileBuffer);
        }



        [HttpPost]
        public ActionResult DeleteDocument(int rowId, int formTypeId)
        {
            if (Request.UrlReferrer == null)
                return Redirect();

            using (DocumentAdapter adapter = new DocumentAdapter(unitOfWork))
            {
                adapter.DeleteDocument(rowId, formTypeId, out int result);
                CacheDoc();

                return Json(result);
            }
        }

        [HttpPost]
        public JsonResult AddNewAuthor(FormCollection form)
        {
            using (DocumentAdapter documentAdapter = new DocumentAdapter(unitOfWork))
            {
                return Json(documentAdapter.AddNewAuthor(form));
            }
        }

        public ActionResult Redirect()
        {
            TempData["IsReturn"] = true;
            return RedirectToRoute("OrgRequests");
        }
    }
}