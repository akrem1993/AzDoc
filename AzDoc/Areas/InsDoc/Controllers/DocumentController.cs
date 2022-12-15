using AzDoc.Attributes;
using AzDoc.BaseControllers;
using AzDoc.Helpers;
using BLL.Common.Enums;
using BLL.CoreAdapters;
using InsDoc.Adapters;
using InsDoc.Model.EntityModel;
using InsDoc.Model.ViewModel;
using Newtonsoft.Json;
using Repository.Infrastructure;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Web.Mvc;
using Widgets.Helpers;
using ActionNameViewModel = BLL.Models.Document.ViewModel.ActionNameViewModel;
using BllDocumentAdapter = BLL.Adapters.DocumentAdapter;

namespace AzDoc.Areas.InsDoc.Controllers
{
    [DocTypeMark(DocType.InsDoc)]
    public class DocumentController : BaseController
    {
        private const int DocTypeId = (int)DocType.InsDoc;

        public DocumentController(IUnitOfWork unitOfWork) : base(unitOfWork)
        {
        }

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

            return View("~/Areas/InsDoc/Views/Document/Index.cshtml");
        }

        [HttpPost]
        public async Task<JsonResult> Document(int? periodId, int pageIndex = 1, int pageSize = 20)
        {
            using (var docAdapter = new DocGridAdapter(unitOfWork))
            {
                SessionHelper.ClearDocId();

                var docs =await docAdapter.GetDocsAsyncNew<DocumentGridModel>(SessionHelper.WorkPlaceId,
                    periodId,
                    DocTypeId,
                    pageIndex,
                    pageSize,
                    Request.ToSqlParams());

                return Json(docs);
            }
        }

        public ActionResult AddNewDocument()
        {
            if (Request.UrlReferrer == null) return Redirect();

            SessionHelper.ClearHelperSession();
            SessionHelper.ClearDocId();

            using (DocumentAdapter adapter = new DocumentAdapter(unitOfWork))
            {
                DocumentViewModel model = new DocumentViewModel(adapter, DocTypeId, SessionHelper.WorkPlaceId);
                ViewData["VizaDataJson"] = model.ChiefModel.VizaDataJson;
                return View("~/Areas/InsDoc/Views/Document/AddNewDocument.cshtml", model);
            }
        }

        [HttpGet]
        public JsonResult GetRelatedDocument()
        {
            using (DocumentAdapter adapter = new DocumentAdapter(unitOfWork))
            {
                List<RelatedDocModel> model = adapter.GetRelatedDocModel();

                return Json(model, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpGet]
        public ActionResult GetDocumentActions(int docId, int menuTypeId, int executorId)
        {
            using (BllDocumentAdapter adapter = new BllDocumentAdapter(unitOfWork))
            {
                SessionHelper.CurrentDocId = docId;
                ActionNameViewModel model = new ActionNameViewModel
                {
                    ActionNameModels = adapter.GetDocumentActions(docId, SessionHelper.WorkPlaceId, menuTypeId, executorId),
                    DocId = docId,
                    Token = TokenHelper.CreateToken(docId),
                    ExecutorId = executorId
                };

                SessionHelper.ResolutionDocId = docId;

                return PartialView("~/Views/Document/ActionNamePartial.cshtml", model);
            }
        }

        public ActionResult EditDocument()
        {
            if (Request.UrlReferrer == null && TempData["IsReturn"] == null)
                return Redirect();

            SessionHelper.ClearDocId();

            using (DocumentAdapter adapter = new DocumentAdapter(unitOfWork))
            {
                DocumentViewModel model = new DocumentViewModel(adapter, DocTypeId, Token.WorkPlaceId, Token.DocId);
                ViewData["VizaDataJson"] = model.DocumentModel.VizaDataJson;
                if (!string.IsNullOrEmpty(model.DocumentModel.CurrentRedirectPersonsJson))
                {
                    model.DocumentModel.CurrentRedirectPersons =
                     JsonConvert.DeserializeObject<IEnumerable<RedirectPersonsView>>(model.DocumentModel.CurrentRedirectPersonsJson);
                }

                return View("~/Areas/InsDoc/Views/Document/EditDocument.cshtml", model);
            }
        }

        public ActionResult ElectronicDocument(int docId, int executorId)
        {
            using (var coreAdapter = new CoreAdapter(unitOfWork))
            using (var docInfoAdapter = new DocInfoAdapter(unitOfWork))
            {
                var workplace = SessionHelper.WorkPlaceId;
                SessionHelper.FileInfoId = docId;

                var model = coreAdapter.ElectronDocView<ElectronicDocumentViewModel>(
                    docId,
                    workplace,
                    1,
                    executorId);

                var fileTask = unitOfWork.GetDocFileViewAsync(model, serverPath);

                coreAdapter.ExecuteDbActionsAsync(() =>
                {
                    model.DocTasks = docInfoAdapter.GetDocTasks(docId);
                    model.DocPlan = docInfoAdapter.GetDocPlan(docId);
                });

                SessionHelper.FileInfoId = docId;
                model.Token = TokenHelper.CreateToken(docId);

                TempData["DocumentView"] = fileTask.GetAwaiter().GetResult();

                return View("~/Areas/InsDoc/Views/Document/ElectronicDocument.cshtml", model);
            }
        }

        [HttpGet]
        public ActionResult DocumentDisplay(int docInfoId)
        {
            var file = unitOfWork.GetDocFileBuffer(docInfoId, serverPath);

            TempData["DocumentView"] = file.LocalTempPath;

            return PartialView("~/Areas/InsDoc/Views/Document/DocumentDisplay.cshtml");
        }

        [HttpPost]
        public ActionResult DeleteDocument(int rowId, int formTypeId)
        {
            if (Request.UrlReferrer == null)
                return Redirect();

            using (DocumentAdapter adapter = new DocumentAdapter(unitOfWork))
            {
                adapter.DeleteDocument(rowId, formTypeId, out int result);

                return Json(result);
            }
        }

        public ActionResult Redirect()
        {
            TempData["IsReturn"] = true;
            return RedirectToRoute("InsDoc");
        }
    }
}