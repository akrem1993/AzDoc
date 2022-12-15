using System;
using System.Threading.Tasks;
using System.Web.Mvc;
using AzDoc.Attributes;
using AzDoc.BaseControllers;
using AzDoc.Helpers;
using BLL.Common.Enums;
using BLL.CoreAdapters;
using Repository.Infrastructure;
using ServiceLetters.Model.EntityModel;
using ServiceLetters.Model.ViewModel;
using Widgets.Helpers;
using ActionNameViewModel = BLL.Models.Document.ViewModel.ActionNameViewModel;
using BllDocumentAdapter = BLL.Adapters.DocumentAdapter;
using DocumentAdapter = ServiceLetters.Adapters.DocumentAdapter;

namespace AzDoc.Areas.ServiceLetters.Controllers
{
    [DocTypeMark(DocType.ServiceLetters)]
    public class DocumentController : BaseController
    {
        private const int DocTypeId = (int)DocType.ServiceLetters;

        public DocumentController(IUnitOfWork unitOfWork) : base(unitOfWork)
        {
        }

        #region BllDocumentAdapter

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
            return View("~/Areas/ServiceLetters/Views/Document/Index.cshtml");
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

        #endregion BllDocumentAdapter

        #region ServiceLetterDocumentAdapter

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

                DocumentViewModel model = new DocumentViewModel(adapter, DocTypeId, SessionHelper.WorkPlaceId);
               ViewData["VizaDataJson"] = model.ChiefModel.VizaDataJson;
                return View("~/Areas/ServiceLetters/Views/Document/AddNewDocument.cshtml", model);
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
        public ActionResult EditDocument()
        {
            if (Request.UrlReferrer == null && TempData["IsReturn"] == null)
                return Redirect();

            ViewBag.Token = Token.RequestToken;
            SessionHelper.ClearDocId();

            using (DocumentAdapter adapter = new DocumentAdapter(unitOfWork))
            {
                DocumentViewModel model = new DocumentViewModel(adapter, DocTypeId, Token.WorkPlaceId, Token.DocId);
                ViewData["VizaDataJson"] = model.DocumentModel.VizaDataJson;

                return View("~/Areas/ServiceLetters/Views/Document/EditDocument.cshtml", model);
            }
        }

        [HttpGet]
        public ActionResult RelateDocumentByServiceLetter()
        {
            if (Request.UrlReferrer == null && TempData["IsReturn"] == null)
                return Redirect();

            SessionHelper.ClearHelperSession();
            SessionHelper.RelatedDocId = Token.DocId;
            SessionHelper.AnswerDocId = -1;
            SessionHelper.DocTypeId = DocTypeId;

            using (DocumentAdapter adapter = new DocumentAdapter(unitOfWork))
            {
                DocumentViewModel model = new DocumentViewModel(adapter, DocTypeId, Token.WorkPlaceId, Token.DocId, 12);
                ViewData["VizaDataJson"] = model.ChiefModel.VizaDataJson;
                return View("~/Areas/ServiceLetters/Views/Document/AddNewDocument.cshtml", model);
            }
        }

        [HttpGet]
        [Permission(RightType.CreateDoc)]
        public ActionResult AnswerByLetter()
        {
            if (Request.UrlReferrer == null)
                return Redirect();

            SessionHelper.ClearHelperSession();
            SessionHelper.AnswerDocId = Token.DocId;
            SessionHelper.RelatedDocId = -1;
            SessionHelper.DocTypeId = DocTypeId;

            using (DocumentAdapter adapter = new DocumentAdapter(unitOfWork))
            {
                DocumentViewModel model = new DocumentViewModel(adapter, DocTypeId, Token.WorkPlaceId, Token.DocId, 11);
                ViewData["VizaDataJson"] = model.ChiefModel.VizaDataJson;

                return View("~/Areas/ServiceLetters/Views/Document/AddNewDocument.cshtml", model);
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
                    1, executorId);

                var fileTask = unitOfWork.GetDocFileViewAsync(model, serverPath);

                coreAdapter.ExecuteDbActionsAsync(() =>
                {
                    model.DocTasks = docInfoAdapter.GetDocTasks(docId);
                    model.DocPlan = docInfoAdapter.GetDocPlan(docId);
                });

                SessionHelper.ResolutionDocId = docId;
                model.Token = TokenHelper.CreateToken(docId);

                TempData["DocumentView"] = fileTask.GetAwaiter().GetResult();

                return View("~/Areas/ServiceLetters/Views/Document/ElectronicDocument.cshtml", model);
            }
        }

        [HttpGet]
        public ActionResult DocumentDisplay(int docInfoId)
        {
            var file = unitOfWork.GetDocFileBuffer(docInfoId, serverPath);

            TempData["DocumentView"] = file.LocalTempPath;

            return PartialView("~/Areas/ServiceLetters/Views/Document/DocumentDisplay.cshtml");
        }

        [HttpGet]
        public FileContentResult DownloadFile(int fileInfoId)
        {
            if (fileInfoId == 0)
                throw new ArgumentException($"Fayl tapılmadı.File Id:{fileInfoId}");

            using (DocumentAdapter adapter = new DocumentAdapter(unitOfWork))
            {
                FileInfoModel model = adapter.ElectronicDocument(fileInfoId);

                if (model == null)
                    return null;

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
            string localTempPath = serverPath.UploadTemp + fileName;

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

                return Json(result, JsonRequestBehavior.AllowGet);
            }
        }

        public ActionResult Redirect()
        {
            TempData["IsReturn"] = true;
            return RedirectToRoute("ServiceLetters");
        }

        [HttpPost]
        public JsonResult AddNewAuthor(FormCollection form)
        {
            using (DocumentAdapter documentAdapter = new DocumentAdapter(unitOfWork))
            {
                return Json(documentAdapter.AddNewAuthor(form));
            }
        }

        [HttpGet]
        public JsonResult GetResult()
        {
            using (DocumentAdapter adapter = new DocumentAdapter(unitOfWork))
            {
                return Json(adapter.GetResultModel(), JsonRequestBehavior.AllowGet);
            }
        }

        [HttpPost]
        public JsonResult DeleteAnswerDoc(int answerDocId)
        {
            using (DocumentAdapter documentAdapter = new DocumentAdapter(unitOfWork))
            {
                var res = documentAdapter.DeleteAnswerDoc(answerDocId, Token.DocId);
                CacheDoc();
                CacheDoc(answerDocId);
                return Json(res);
            }
        }

        [HttpPost]
        public JsonResult AddAnswerDocExecutors(int answerDocId, int? signerWorkPlaceId)
        {
            using (DocumentAdapter documentAdapter = new DocumentAdapter(unitOfWork))
            {
                var res = documentAdapter.AddAnswerDocExecutors(answerDocId,
                    Token.DocId,
                    signerWorkPlaceId,
                    Token.WorkPlaceId);
                CacheDoc();
                CacheDoc(answerDocId);
                return Json(res);
            }
        }

        [HttpPost]
        public JsonResult DeleteWhomAddressed(int taskId)
        {
            using (DocumentAdapter adapter = new DocumentAdapter(unitOfWork))
            {
                return Json(adapter.DeleteWhomAddressed(taskId));
            }
        }

        #endregion ServiceLetterDocumentAdapter
    }
}