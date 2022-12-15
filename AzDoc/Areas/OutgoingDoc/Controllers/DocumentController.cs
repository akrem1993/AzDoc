using System.Collections.Generic;
using System.Threading.Tasks;
using System.Web.Mvc;
using System.Web.Routing;
using AzDoc.Attributes;
using AzDoc.BaseControllers;
using AzDoc.Helpers;
using BLL.Common.Enums;
using BLL.CoreAdapters;
using CustomHelpers;
using OutgoingDoc.Adapters;
using OutgoingDoc.Model.EntityModel;
using OutgoingDoc.Model.FormModel;
using OutgoingDoc.Model.ViewModel;
using Repository.Infrastructure;
using Widgets.Helpers;
using BllAdapter = BLL.Adapters.DocumentAdapter;


namespace AzDoc.Areas.OutgoingDoc.Controllers
{
    [DocTypeMark(DocType.OutGoing)]
    public class DocumentController : BaseController
    {
        private const int DocTypeId = (int) DocType.OutGoing;

        public DocumentController(IUnitOfWork unitOfWork) : base(unitOfWork)
        {
        }

        public ActionResult Index(int docType)
        {
            if (Request.UrlReferrer == null && TempData["IsReturn"] == null)
                return Redirect();

            SessionHelper.DocTypeId = docType;

            using (BllAdapter adapter = new BllAdapter(unitOfWork))
            {
                var documentGroup = adapter.GetDocumentGroupModel(docType);

                if (documentGroup != null)
                {
                    ViewData["DocTypeName"] = documentGroup.TreeName;
                    ViewData["DocTypeGroupName"] = documentGroup.DocTypeGroupName;
                }
            }

            return View();
        }

        [HttpGet]
        public ActionResult ActionName(int docId, int menuTypeId, int docType, int executorId)
        {
            using (BllAdapter adapter = new BllAdapter(unitOfWork))
            {
                var data = new BLL.Models.Document.ViewModel.ActionNameViewModel
                {
                    ActionNameModels =
                        adapter.GetDocumentActions(docId, SessionHelper.WorkPlaceId, menuTypeId, executorId),
                    DocId = docId,
                    Token = TokenHelper.CreateToken(docId)
                };
                SessionHelper.ResolutionDocId = docId;
                return PartialView("~/Views/Document/ActionNamePartial.cshtml", data);
            }
        }

        [HttpPost]
        public ActionResult ActionOperation(int actionId, string description)
        {
            if (actionId == -1)
                return null;

            var action = (ActionType) actionId;

            switch (actionId)
            {
                case 8: //derkenar ucun
                    return Json(new
                    {
                        ActionId = actionId,
                        DocId = SessionHelper.ResolutionDocId
                    });

                case 7: //sign
                {
                    int signStatus;
                    lock (Session.SyncRoot)
                    {
                        using (var adapter = new CoreAdapter(unitOfWork))
                        {
                            signStatus = adapter.ExecuteOperation(action,
                                Token.DocId,
                                Token.WorkPlaceId,
                                description,
                                out int res);
                        }
                    }

                    CacheDoc();

                    return Json(signStatus);
                }


                default:
                    using (var adapter = new CoreAdapter(unitOfWork))
                    {
                        int operationStatus = adapter.ExecuteOperation(action,
                            Token.DocId,
                            Token.WorkPlaceId,
                            description,
                            out int res);
                        CacheDoc();

                        return Json(operationStatus);
                    }
            }
        }

        [HttpGet]
        [CheckSftp]
        [Permission(RightType.CreateDoc)]
        public ActionResult AddNewDocument(int docType)
        {
            if (Request.UrlReferrer == null)
                return Redirect();

            SessionHelper.ClearHelperSession();
            SessionHelper.ClearDocId();

            if (docType != -1)
            {
                var model = unitOfWork.GetOutgoingDocViewModel(docType, SessionHelper.WorkPlaceId);
                ViewData["VizaDataJson"] = model.ChiefModel.VizaDataJson;
                return View(model);
            }

            return null;
        }

        [HttpPost]
        [Permission(RightType.CreateDoc)]
        public ActionResult AddNewDocument(DocumentFormModel model, int docType, string fileInfoId)
        {
            if (Request.UrlReferrer == null)
                return Redirect();

            int currentDocId = 0;
            if (!string.IsNullOrEmpty(fileInfoId))
            {
                var controller = new FileAdapter(unitOfWork);
                currentDocId = controller.GetFileInfoIdByDocId(fileInfoId.ToInt());
            }


            if (docType != -1)
            {
                int result;
                lock (Session.SyncRoot)
                {
                    unitOfWork.SaveDocument(SessionHelper.WorkPlaceId, docType, model, currentDocId,
                        out result);
                    if (result == (int) (DBResultOutputParameter.Success))
                    {
                        SessionHelper.ClearDocId();
                    }
                }

                CacheDoc(currentDocId);

                return Json(new {result, url = Url.Action("Index", "Document", new {docType})});
            }

            return View();
        }

        public ActionResult Redirect()
        {
            var values = new RouteValueDictionary()
            {
                {"docType", DocTypeId}
            };

            TempData["IsReturn"] = true;
            return RedirectToAction("Index", "Document", values);
        }

        [HttpPost]
        public async Task<JsonResult> Document(int? periodId, int pageIndex = 1, int docType = 12, int pageSize = 20)
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

        public ActionResult ElectronicDocument(int docId, int docType, int executorId)
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

                coreAdapter.ExecuteDbActionsAsync(() => { model.DocPlan = docInfoAdapter.GetDocPlan(docId); });

                SessionHelper.FileInfoId = docId;
                model.Token = TokenHelper.CreateToken(docId);

                TempData["DocumentView"] = fileTask.GetAwaiter().GetResult();

                return View(model);
            }
        }


        [HttpGet]
        public FileContentResult DownloadFile(int fileInfoId)
        {
            FileInfoModel model = unitOfWork.ElectronicDocument(fileInfoId);
            if (model == null)
                return null;

            byte[] fileBuffer = SFTPHelper.DownloadFileBuffer(model.FileInfoPath);

            string fileName = model.FileInfoGuId + model.FileInfoExtention;

            MapForDocumentViewer(fileName, fileBuffer);

            return File(fileBuffer, System.Net.Mime.MediaTypeNames.Application.Octet, fileName);
        }

        [HttpGet]
        public ActionResult DocumentDisplay(int docInfoId)
        {
            var file = unitOfWork.GetDocFileBuffer(docInfoId, serverPath);

            TempData["DocumentView"] = file.LocalTempPath;

            return PartialView("~/Areas/outgoingDoc/Views/Shared/_DocumentDisplay.cshtml");
        }

        [HttpGet]
        public JsonResult GetDocumentViewDisplay(int docInfoId)
        {
            var file = DownloadFile(docInfoId);
            TempData["DocumentView"] = serverPath.UploadTemp + file.FileDownloadName;
            return Json(true, JsonRequestBehavior.AllowGet);
        }

        [HttpGet]
        public ActionResult EditDocument(int docType)
        {
            if (Request.UrlReferrer == null && TempData["IsReturn"] == null)
                return Redirect();

            ViewBag.Token = Token.RequestToken;

            SessionHelper.ClearDocId();

            if (docType != -1)
            {
                var model = unitOfWork.GetOutgoingDocViewModel(
                    docType,
                    Token.WorkPlaceId,
                    Token.DocId);
                ViewData["VizaDataJson"] = model.DocumentModel.VizaDataJson;

                return View(model);
            }

            return null;
        }

        [HttpPost]
        public ActionResult EditDocument(DocumentFormModel model, int docType)
        {
            if (Request.UrlReferrer == null && TempData["IsReturn"] == null)
                return Redirect();

            if (docType != -1)
            {
                unitOfWork.EditDocument(Token.WorkPlaceId, docType, Token.DocId, model, out int result);
                CacheDoc();

                if (result == (int) (DBResultOutputParameter.Success))
                {
                    SessionHelper.ClearDocId();
                    return Json(new {result = "true", url = Url.Action("Index", "Document", new {docType = docType})});
                }
            }

            return View();
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
        public JsonResult DeleteAnswerDoc(int answerDocId)
        {
            var res = unitOfWork.DeleteAnswerDoc(answerDocId, Token.DocId);
            CacheDoc();
            CacheDoc(answerDocId);
            return Json(res);
        }


        [HttpPost]
        public ActionResult DeleteDocument(int rowId, int docType, int formTypeId)
        {
            if (Request.UrlReferrer == null)
                return Redirect();

            if (docType != -1)
            {
                unitOfWork.DeleteDocument(rowId, formTypeId, out int result);
                CacheDoc();
                return Json(result);
            }

            return null;
        }

        [HttpGet]
        [Permission(RightType.CreateDoc)]
        public ActionResult AnswerByOutgoingDoc()
        {
            if (Request.UrlReferrer == null && TempData["IsReturn"] == null)
                return Redirect();

            SessionHelper.ClearHelperSession();
            SessionHelper.AnswerDocId = Token.DocId;
            SessionHelper.RelatedDocId = -1;
            SessionHelper.DocTypeId = DocTypeId;

            if (DocTypeId != -1)
            {
                var model = unitOfWork.GetOutgoingDocViewModel(DocTypeId, Token.WorkPlaceId, Token.DocId, 13);
                ViewData["VizaDataJson"] = model.ChiefModel.VizaDataJson;
                return View("AddNewDocument", model);
            }
        }

        public ActionResult RelatedDocByOutgoingDoc()
        {
            if (Request.UrlReferrer == null && TempData["IsReturn"] == null)
                return Redirect();

            SessionHelper.ClearHelperSession();
            SessionHelper.RelatedDocId = Token.DocId;
            SessionHelper.AnswerDocId = -1;
            SessionHelper.DocTypeId = DocTypeId;

            if (DocTypeId != -1)
            {
                var model = unitOfWork.GetOutgoingDocViewModel(DocTypeId, Token.WorkPlaceId, Token.DocId, 14);
                ViewData["VizaDataJson"] = model.ChiefModel.VizaDataJson;
                return View("AddNewDocument", model);
            }
        }

        [HttpPost]
        public JsonResult AddAnswerDocExecutors(int answerDocId, int? signerWorkPlaceId)
        {
            var res = unitOfWork.AddAnswerDocExecutors(answerDocId,
                Token.DocId,
                signerWorkPlaceId,
                Token.WorkPlaceId);
            CacheDoc(answerDocId);
            CacheDoc();
            return Json(res);
        }

        [HttpGet]
        public JsonResult GetResult()
        {
            return Json(unitOfWork.GetResultModel(), JsonRequestBehavior.AllowGet);
        }

        public ActionResult AddReserveDocument(int docType)
        {
            if (Request.UrlReferrer == null)
                return Redirect();

            SessionHelper.ClearHelperSession();
            SessionHelper.ClearDocId();

            if (docType != -1)
            {
                var model = unitOfWork.GetOutgoingReserveDocViewModel(docType, SessionHelper.WorkPlaceId);
                return View("_AddReserveDocumentPartial", model);
            }

            return null;
        }

        [HttpPost]
        public ActionResult AddReserveDocument(DocumentFormModel model, int docType)
        {
            if (Request.UrlReferrer == null)
                return Redirect();

            if (docType != -1)
            {
                unitOfWork.SaveReserveDocument(SessionHelper.WorkPlaceId, docType, model, SessionHelper.CurrentDocId,
                    out int result);
                if (result == (int) (DBResultOutputParameter.Success))
                {
                    return Json(new {result = "true", url = Url.Action("Index", "Document", new {docType})});
                }
            }

            return View();
        }

        [HttpPost]
        public JsonResult AddNewAuthor(FormCollection form)
        {
            return Json(unitOfWork.AddNewAuthor(form));
        }


        [HttpPost]
        public JsonResult GetAuthorInfo(string data, int next)
        {
            var authors = unitOfWork.GetAuthorInfo(data, next, SessionHelper.WorkPlaceId, SessionHelper.DocTypeId) ??
                          new List<AuthorModel>();
            authors.ForEach(x => { x.Token = TokenHelper.CreateToken(x.AuthorId); });

            return new JsonResult
            {
                Data = authors,
                MaxJsonLength = int.MaxValue
            };
        }

        [HttpGet]
        public ActionResult DocNote()
        {
            return View("_DocNotePartial");
        }


        [HttpPost]
        public JsonResult DocNote(string note)
        {
            var controller = new Journal.Controllers.HomeController(unitOfWork);

            var result = controller.EditNote(note, SessionHelper.ResolutionDocId);
            CacheDoc(SessionHelper.ResolutionDocId);
            return Json(result);
        }
    }
}