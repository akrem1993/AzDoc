using Repository.Infrastructure;
using BLL.Adapters;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using AzDoc.BaseControllers;
using AzDoc.Helpers;
using BLL;
using BLL.Common.Enums.DMSEnums;
using BLL.Common.Enums;
using Widgets.Helpers;
using BLL.CoreAdapters;
using CustomHelpers;
using Newtonsoft.Json;
using BLL.Models.Document.ViewModel;
using DocType = BLL.Common.Enums.DMSEnums.DocType;

namespace AzDoc.Controllers
{
    public class WaitingDocsController : BaseController
    {
        private const int DocTypeId = (int)DocType.WaitingDocs;
        public WaitingDocsController(IUnitOfWork unitOfWork):base(unitOfWork)
        { }
        //// GET: WaitingDocs
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

            }
            return View();


            }
        private ActionResult Redirect()
        {
            TempData["IsReturn"] = true;
            return RedirectToRoute("UnreadDocuments");
        }

        [HttpPost]
        public JsonResult Document(int? periodId, int? sendStatusId, int? pageIndex, int docType, int pageSize = 20)
        {
            SessionHelper.ClearDocId();
            int workPlace = SessionHelper.WorkPlaceId;

            var data = unitOfWork.GetDocumentGridModel(workPlace,
                sendStatusId,
                periodId,
                DocTypeId,
                pageIndex,
                pageSize,
                Request.ToSqlParams());

            return Json(data);

        }
        public ActionResult GetDocView()
        {
            var token = CustomHelper.Decrypt(HttpUtility.UrlDecode(Request.QueryString["token"]));
            if (token == null)
                return HttpNotFound();
            var splitWorkPlaceId = token.Split('-')[0].ToInt();
            var splitDocId = token.Split('-')[2].ToInt();
            if (splitWorkPlaceId != SessionHelper.WorkPlaceId)
                return HttpNotFound();
          
                string data = unitOfWork.GetDocView(splitDocId, splitWorkPlaceId, out int docTypeId);

                if (string.IsNullOrEmpty(data))
                    return HttpNotFound();

            DocType docType = (DocType)docTypeId;

                switch (docType)
                {
                    case DocType.OrgRequests:
                        var orgRequestsModel = JsonConvert.DeserializeObject<IEnumerable<OrgRequests.Model.ViewModel.DocumentInfoViewModel>>(data).First();
                        return View("~/Areas/OrgRequests/Views/Document/DocInfo.cshtml", orgRequestsModel);

                    case DocType.CitizenRequests:
                        var citizensModel = JsonConvert.DeserializeObject<IEnumerable<CitizenRequests.Model.ViewModel.DocumentInfoViewModel>>(data).First();
                        return View("~/Areas/CitizenRequests/Views/Document/DocInfo.cshtml", citizensModel);

                    case DocType.InsDoc:
                        var insDocModel = JsonConvert.DeserializeObject<IEnumerable<InsDoc.Model.ViewModel.DocumentInfoViewModel>>(data).First();
                        return View("~/Areas/InsDoc/Views/Document/DocInfo.cshtml", insDocModel);

                    case DocType.ServiceLetters:
                        var serviceLetterModel = JsonConvert.DeserializeObject<IEnumerable<ServiceLetters.Model.ViewModel.DocumentInfoViewModel>>(data).First();
                        return View("~/Areas/ServiceLetters/Views/Document/DocInfo.cshtml", serviceLetterModel);

                    case DocType.OutGoing:
                        var outgoingModel = JsonConvert.DeserializeObject<IEnumerable<OutgoingDoc.Model.ViewModel.DocumentInfoViewModel>>(data).First();
                        return View("~/Areas/OutgoingDoc/Views/Document/DocInfo.cshtml", outgoingModel);

                    default:
                        return HttpNotFound();
                }
          
        }
        public JsonResult GetInfo(string docnumber)
        {
            var result = unitOfWork.GetInfo(docnumber);
            return Json(result,JsonRequestBehavior.AllowGet);

        }
        [HttpGet]
        public ActionResult ElectronicDocument(int docId)
        {

            DocType docType = (DocType)unitOfWork.GetDocumentType(docId);
            SessionHelper.ResolutionDocId = docId;

            ElectronicDocumentViewModel model = unitOfWork.WaitingDocsElectronicDocument(docId,/* (int)docType,*/ SessionHelper.WorkPlaceId);
          //  model.Token = HttpUtility.UrlEncode(CustomHelper.Encrypt($"{SessionHelper.WorkPlaceId}-{DateTime.Now:dd.MM.yyyyHH:mm:ss}-{docId}"));
            if (model.FileInfoId == 0)
                throw new ArgumentException($"Fayl tapılmadı.File Id:{model.FileInfoId}");

            //var file = DownloadFile(model.FileInfoId);
            //TempData["DocumentView"] = string.Format(@"~/App_Data/UploadTemp/" + file.FileDownloadName);
            SessionHelper.ResolutionDocId = docId;
            return View(model);


        }

    }
}