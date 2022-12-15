using System;
using System.Threading.Tasks;
using System.Web.Mvc;
using AzDoc.Attributes;
using AzDoc.BaseControllers;
using AzDoc.Helpers;
using BLL.Common.Enums;
using BLL.CoreAdapters;
using CitizenRequests.Model.EntityModel;
using CitizenRequests.Model.ViewModel;
using Repository.Infrastructure;
using Widgets.Helpers;
using ActionNameViewModel = BLL.Models.Document.ViewModel.ActionNameViewModel;
using BllDocumentAdapter = BLL.Adapters.DocumentAdapter;
using DocumentAdapter = CitizenRequests.Adapters.DocumentAdapter;

namespace AzDoc.Areas.CitizenRequests.Controllers
{
    [DocTypeMark(DocType.CitizenRequests)]
    public class DocumentController : BaseController
    {
        private const int DocTypeId = (int)DocType.CitizenRequests;

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
            return View("~/Areas/CitizenRequests/Views/Document/Index.cshtml");
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
                var model = new DocumentViewModel(
                    adapter,
                    DocTypeId,
                    SessionHelper.WorkPlaceId);

                return View("~/Areas/CitizenRequests/Views/Document/AddNewDocument.cshtml", model);
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
        public JsonResult GetSubordinate(int organizationId, int docTopicId)
        {
            using (DocumentAdapter adapter = new DocumentAdapter(unitOfWork))
            {
                var model = adapter.GetSubordinateModel(organizationId, docTopicId);

                return Json(model, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpGet]
        public JsonResult GetSubtitle(int topicTypeId)
        {
            using (DocumentAdapter adapter = new DocumentAdapter(unitOfWork))
            {
                var model = adapter.GetSubtitleModel(topicTypeId);

                return Json(model, JsonRequestBehavior.AllowGet);
            }
        }


        [HttpGet]
        public JsonResult GetSubtitleOrgan(int topicId)
        {
            using (DocumentAdapter adapter = new DocumentAdapter(unitOfWork))
            {

                var model = adapter.GetSubtitleOrgan(topicId, SessionHelper.WorkPlaceId);

                return Json(model, JsonRequestBehavior.AllowGet);
            }
        }



        [HttpGet]
        public JsonResult GetRegion(int countryId)
        {
            using (DocumentAdapter adapter = new DocumentAdapter(unitOfWork))
            {
                var model = adapter.GetRegionModel(countryId);

                return Json(model, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpGet]
        public JsonResult GetVillage(int regionId)
        {
            using (DocumentAdapter adapter = new DocumentAdapter(unitOfWork))
            {
                var model = adapter.GetVillageModel(regionId);

                return Json(model, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpPost]
        public JsonResult GetApplyAgain(int docType, string surName, string firstName)
        {
            using (DocumentAdapter adapter = new DocumentAdapter(unitOfWork))
            {
                var model = adapter.GetApplyAgainModel(docType, surName, firstName, SessionHelper.OrganizationId);
                model.ForEach(x =>
                {
                    x.Token = TokenHelper.CreateToken(x.DocId);
                });

                return Json(model, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpPost]
        public JsonResult GetApplyAgainDocId(int docId)
        {
            using (DocumentAdapter adapter = new DocumentAdapter(unitOfWork))
            {
                var model = adapter.GetApplyAgainModel(docId);

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
            if (Request.UrlReferrer == null && TempData["IsReturn"] == null)
                return Redirect();

            SessionHelper.ClearDocId();

            using (DocumentAdapter adapter = new DocumentAdapter(unitOfWork))
            {
                DocumentViewModel model = new DocumentViewModel(adapter, DocTypeId, Token.WorkPlaceId, Token.DocId);
                return View("~/Areas/CitizenRequests/Views/Document/EditDocument.cshtml", model);
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

                return View("~/Areas/CitizenRequests/Views/Document/ElectronicDocument.cshtml", model);
            }
        }

        [HttpGet]
        public ActionResult DocumentDisplay(int docInfoId)
        {
            var file = DownloadFile(docInfoId);
            TempData["DocumentView"] = serverPath.UploadTemp + file?.FileDownloadName;
            return PartialView("~/Areas/CitizenRequests/Views/Document/DocumentDisplay.cshtml");
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

                return Json(result);
            }
        }

        public ActionResult Redirect()
        {
            TempData["IsReturn"] = true;
            return RedirectToRoute("CitizenRequests");
        }

        [HttpPost]
        public JsonResult AddNewAuthor(FormCollection form)
        {
            using (DocumentAdapter documentAdapter = new DocumentAdapter(unitOfWork))
            {
                return Json(documentAdapter.AddNewAuthor(form));
            }
        }

    }
}