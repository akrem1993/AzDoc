using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;
using System.Web.Mvc;
using AzDoc.Attributes;
using AzDoc.BaseControllers;
using AzDoc.Helpers;
using BLL.Adapters;
using BLL.Common.Enums;
using BLL.CoreAdapters;
using BLL.Models.DocInfo;
using BLL.Models.Document.EntityModel;
using BLL.Models.Document.ViewModel;
using Newtonsoft.Json;
using Repository.Infrastructure;
using Widgets.Helpers;

namespace AzDoc.Controllers
{
    [DocTypeMark(DocType.None)]
    public class DocumentController : BaseController
    {
        private const int DocTypeId = (int)DocType.None;

        public DocumentController(IUnitOfWork unitOfWork) : base(unitOfWork)
        {
        }

        public ActionResult Index()
        {
            if (Request.UrlReferrer == null && TempData["IsReturn"] == null)
                return Redirect();

            using (DocumentAdapter adapter = new DocumentAdapter(unitOfWork))
            {
                var documentGroup = adapter.GetDocumentGroupModel(DocTypeId);

                if (documentGroup != null)
                {
                    ViewData["DocTypeName"] = documentGroup.TreeName;
                    ViewData["DocTypeGroupName"] = documentGroup.DocTypeGroupName;
                }

                DocCountViewModel docCountViewModel = new DocCountViewModel
                {
                    DocCountModels = adapter.GetDocCountModel(null, SessionHelper.WorkPlaceId)
                };

                return View("~/Views/Document/Index.cshtml", docCountViewModel);
            }
        }

        private ActionResult Redirect()
        {
            TempData["IsReturn"] = true;
            return RedirectToRoute("UnreadDocuments");
        }

        [HttpPost]
        public async Task<JsonResult> Document(int? periodId, int? sendStatusId, int? pageIndex, int docType, int pageSize = 20)
        {
            using (DocumentAdapter adapter = new DocumentAdapter(unitOfWork))
            {
                SessionHelper.ClearDocId();
                int workPlace = SessionHelper.WorkPlaceId;

                var data = await adapter.GetDocumentGridModelAsync(workPlace,
                    sendStatusId,
                    periodId,
                    DocTypeId,
                    pageIndex,
                    pageSize,
                    Request.ToSqlParams());

                return Json(data);
            }
        }

        [HttpGet]
        public ActionResult ElectronicDocument(int docId, int executorId)
        {
            using (DocumentAdapter adapter = new DocumentAdapter(unitOfWork))
            {
                DocType docType = (DocType)adapter.GetDocumentType(docId);
                SessionHelper.ResolutionDocId = docId;
                SessionHelper.DocTypeId = (int)docType;
                var routeVals = new System.Web.Routing.RouteValueDictionary
                {
                    { "controller", "Document" },
                    { "action", "ElectronicDocument" },
                    { "docId", docId },
                    { "executorId",executorId}
                };

                CacheDoc(docId);
                switch (docType)
                {
                    case DocType.OrgRequests:
                        //return new Areas.OrgRequests.Controllers.DocumentController(unitOfWork).ElectronicDocument(docId);
                        return RedirectToRoute("OrgRequestsDefault", routeVals);

                    case DocType.CitizenRequests:
                        //return new Areas.CitizenRequests.Controllers.DocumentController(unitOfWork).ElectronicDocument(docId);
                        return RedirectToRoute("CitizenRequestsDefault", routeVals);

                    case DocType.ColleagueRequests:
                        //return new Areas.ColleagueRequests.Controllers.DocumentController(unitOfWork).ElectronicDocument(docId);
                        return RedirectToRoute("ColleagueRequestsDefault", routeVals);

                    case DocType.InsDoc:
                        //return new Areas.InsDoc.Controllers.DocumentController(unitOfWork).ElectronicDocument(docId);
                        return RedirectToRoute("InsDocDefault", routeVals);

                    case DocType.ServiceLetters:
                        //return new Areas.ServiceLetters.Controllers.DocumentController(unitOfWork).ElectronicDocument(docId);
                        return RedirectToRoute("ServiceLettersDefault", routeVals);

                    case DocType.OutGoing:
                        //return new Areas.OutgoingDoc.Controllers.DocumentController(unitOfWork).ElectronicDocument(docId,(int)DocType.OutGoing);
                        return RedirectToRoute("OutgoingDoc_WithAction", new System.Web.Routing.RouteValueDictionary
                        {
                            { "controller", "Document" },
                            { "action", "ElectronicDocument" },
                            { "docId", docId },
                            { "docType", (int)DocType.OutGoing },
                            { "executorId", executorId}
                        });

                    default:
                        return HttpNotFound();
                }
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Printed()
        {
            var controller = new Areas.OutgoingDoc.Controllers.DocumentController(unitOfWork);
            controller.TempData["token"] = Token.RequestToken;
            return controller.ActionOperation(15, null);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Mailed()
        {
            var controller = new Areas.OutgoingDoc.Controllers.DocumentController(unitOfWork);
            controller.TempData["token"] = Token.RequestToken;
            return controller.ActionOperation(16, null);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult RecognizedDocument(int executorId)
        {
            using (var adapter = new CoreAdapter(unitOfWork))
            {
                adapter.ExecuteOperation(ActionType.Recognized, Token.DocId,
                    Token.WorkPlaceId, string.Empty, out int result, executorId);
                CacheDoc();

                return Json(true, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpGet]
        public FileContentResult DownloadFile(int docId, int fileInfoId)
        {
            using (DocumentAdapter adapter = new DocumentAdapter(unitOfWork))
            {
                FileInfoModel model = adapter.FileInfoDocument(docId, fileInfoId);

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
            string localTempPath = Server.MapPath(@"~\App_Data\UploadTemp") + "\\" + fileName;

            System.IO.File.WriteAllBytes(localTempPath, fileBuffer);
        }

        [HttpGet]
        public ActionResult EditDocument()
        {
            if (Request.UrlReferrer == null && TempData["IsReturn"] == null)
                return Redirect();

            using (DocumentAdapter adapter = new DocumentAdapter(unitOfWork))
            {
                DocType docType = (DocType)adapter.GetDocumentType(Token.DocId);

                var routeVals = new System.Web.Routing.RouteValueDictionary
                {
                    { "controller", "Document" },
                    { "action", "EditDocument" },
                    { "token",  Token.RequestToken }
                };

                SessionHelper.DocTypeId = (int)docType;
                switch (docType)
                {
                    case DocType.OrgRequests:
                        return RedirectToRoute("OrgRequestsDefaultToken", routeVals);

                    case DocType.CitizenRequests:
                        return RedirectToRoute("CitizenRequestsDefaultToken", routeVals);

                    case DocType.ColleagueRequests:
                        return RedirectToRoute("ColleagueRequestsDefaultToken", routeVals);

                    case DocType.InsDoc:
                        return RedirectToRoute("InsDocDefault", routeVals);

                    case DocType.ServiceLetters:
                        return RedirectToRoute("ServiceLettersDefaultToken", routeVals);

                    case DocType.OutGoing:
                        return Redirect($"~/az/outgoing/Document/EditDocument/?docType=12&token={Token.RequestToken}");

                    default:
                        return HttpNotFound();
                }
            }
        }

        [HttpGet]
        public ActionResult DocInfo(int docId)
        {
            if (docId < 1)
                return HttpNotFound();

            var result = TokenHelper.CreateToken(docId);

            return Json(result, JsonRequestBehavior.AllowGet);
        }

        [HttpGet]
        public ActionResult GetDocView()
        {
            if (TempData["DocumentView"] == null)
            {
                TempData["DocumentView"] = "";
                ViewData["token"] = Token.RequestToken;
            }

            int docId = Token.DocId;

            using (DocumentAdapter adapter = new DocumentAdapter(unitOfWork))
            using (DocInfoAdapter docInfoAdpater = new DocInfoAdapter(unitOfWork))
            {
                DocType docType = (DocType)adapter.GetDocumentType(docId);

                var docTypeName = DocTypeAreaName(docType);

                dynamic model = null;

                switch (docType)
                {
                    case DocType.OrgRequests:
                        model = docInfoAdpater.GetDocView<OrgRequests.Model.ViewModel.DocumentInfoViewModel>(docId);
                        break;

                    case DocType.CitizenRequests:
                        model = docInfoAdpater.GetDocView<CitizenRequests.Model.ViewModel.DocumentInfoViewModel>(docId);
                        using (var citizenAdapter = new CitizenRequests.Adapters.DocumentAdapter(unitOfWork))
                        {
                            citizenAdapter.ExecuteDbActionsAsync(
                                 () => model.PreviosRequests = citizenAdapter.GetDocPreviousRequests(docId),
                                 () => model.Applicants = citizenAdapter.GetDocApplicants(docId)
                                );
                        }
                        break;

                    case DocType.ColleagueRequests:
                        model = docInfoAdpater.GetDocView<ColleagueRequests.Model.ViewModel.DocumentInfoViewModel>(docId);
                        using (var colleagueAdapter = new ColleagueRequests.Adapters.DocumentAdapter(unitOfWork))
                        {
                            colleagueAdapter.ExecuteDbActionsAsync(
                                 () => model.PreviosRequests = colleagueAdapter.GetDocPreviousRequests(docId),
                                 () => model.Applicants = colleagueAdapter.GetDocApplicants(docId)
                                );
                        }
                        break;

                    case DocType.InsDoc:
                        model = docInfoAdpater.GetDocView<InsDoc.Model.ViewModel.DocumentInfoViewModel>(docId);
                        break;

                    case DocType.ServiceLetters:
                        model = docInfoAdpater.GetDocView<ServiceLetters.Model.ViewModel.DocumentInfoViewModel>(docId);
                        break;

                    case DocType.OutGoing:
                        model = docInfoAdpater.GetDocView<OutgoingDoc.Model.ViewModel.DocumentInfoViewModel>(docId);
                        break;

                    default:
                        return null;
                }

                docInfoAdpater.SetAllBaseInfo((BaseDocInfo)model, docId);

                string taskPrefix = (model is ITaskModel t && t.IsTask) ? "Task" : string.Empty;

                return View($"~/Areas/{docTypeName}/Views/Document/Doc{taskPrefix}Info.cshtml", model);
            }
        }

        private string DocTypeAreaName(DocType docType)
        {
            switch (docType)
            {
                case DocType.OutGoing:
                    return "OutgoingDoc";

                default:
                    return docType.ToString();
            }
        }

        [HttpGet]
        public ActionResult GetDocumentActions(int docId, int executorId, int menuTypeId)
        {
            using (var adapter = new CoreAdapter(unitOfWork))
            {
                var actions = adapter.GetDocumentActions(docId, SessionHelper.WorkPlaceId, menuTypeId, executorId);

                ActionNameViewModel model = new ActionNameViewModel
                {
                    ActionNameModels = actions,
                    DocId = docId,
                    Token = TokenHelper.CreateToken(docId),
                    ExecutorId = executorId
                };
                SessionHelper.ResolutionDocId = docId;
                return PartialView("~/Views/Document/ActionNamePartial.cshtml", model);
            }
        }

        [HttpPost]
        public ActionResult PostActionDocument(int actionId, string description)
        {
            if (actionId == -1)
                return null;

            switch (actionId)
            {
                case 8://derkenar ucun
                    return Json(new
                    {
                        ActionId = actionId,
                        DocId = SessionHelper.ResolutionDocId
                    });

                default:
                    using (DocumentAdapter adapter = new DocumentAdapter(unitOfWork))
                    {
                        int actionOperation = adapter.PostActionOperation(actionId, SessionHelper.ResolutionDocId,
                             SessionHelper.WorkPlaceId, description, out int result);
                        CacheDoc(SessionHelper.ResolutionDocId);

                        return Json(actionOperation);
                    }
            }
        }

        [HttpPost]
        public JsonResult GetAuthorInfo(string data, int next)
        {
            using (DocumentAdapter documentAdapter = new DocumentAdapter(unitOfWork))
            {
                var authors = documentAdapter.GetAuthorInfo(data, next, SessionHelper.WorkPlaceId, SessionHelper.DocTypeId) ??
                    new List<AuthorModel>();

                authors.ForEach(x =>
                    {
                        x.Token = TokenHelper.CreateToken(x.AuthorId);
                    });

                return new JsonResult
                {
                    Data = authors,
                    MaxJsonLength = int.MaxValue
                };
            }
        }

        [HttpGet]
        public JsonResult SendForInformation()
        {
            using (DocumentAdapter adapter = new DocumentAdapter(unitOfWork))
            {
                List<SendForInformationViewModel> model = adapter.GetSendForInformation(Token.WorkPlaceId, Token.DocId);

                return Json(new
                {
                    Model = model,
                    Token = Token.RequestToken
                },
                JsonRequestBehavior.AllowGet);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult SendForInformation(SendForInformationModel model)
        {
            using (DocumentAdapter adapter = new DocumentAdapter(unitOfWork))
            {
                adapter.PostSendForInformationModel(model, Token.WorkPlaceId, Token.DocId,
                    out int result);
                
                CacheDoc();
                return Json(result == (int)DBResultOutputParameter.Success, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpPost]
        public ActionResult SendForInformationDelete(int workPlaceId)
        {
            using (DocumentAdapter adapter = new DocumentAdapter(unitOfWork))
            {
                adapter.DeleteSendForInformation(workPlaceId, Token.DocId, out int result);
                
                CacheDoc();
                return Json(result == (int)DBResultOutputParameter.Success, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpGet]
        public JsonResult ValidateSign()
        {
            using (var adapter = new DocumentAdapter(unitOfWork))
            {
                adapter.ValidateSign(Token.WorkPlaceId, Token.DocId);
            }

            return Json(true, JsonRequestBehavior.AllowGet);
        }
    }
}