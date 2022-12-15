using AzDoc.Attributes;
using AzDoc.Helpers;
using BLL.Common.Enums;
using Journal.Adapters;
using Journal.Model.EntityModel;
using Repository.Infrastructure;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using Widgets.Helpers;
using BllDocumentAdapter = BLL.Adapters.DocumentAdapter;

//using System;
//using CustomHelpers;
//using System.Web;

namespace AzDoc.Areas.Journal.Controllers
{
    public class HomeController : Controller
    {
        // GET: Journal/Home

        private readonly IUnitOfWork _unitOfWork;
        private int _CurrentPage = 1;
        private object unitOfWork;

        public HomeController(IUnitOfWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        [HttpGet]
        public ActionResult Index()
        {
            using (BllDocumentAdapter adapter = new BllDocumentAdapter(_unitOfWork))
            {
                var documentGroup = adapter.GetDocumentGroupModel(12);

                if (documentGroup != null)
                {
                    ViewData["DocTypeName"] = "Göndərilən sənədlərin qeydə alınması e-kitabı";
                    ViewData["DocTypeGroupName"] = documentGroup.DocTypeGroupName;
                }
            }

            return View();
        }

        [HttpGet]
        public ActionResult GetNoteArchive(int docid)
        {
            var model = _unitOfWork.GetNoteArchive(1, docid, 0, 0);

            var viewModel = new JournalLib.Model.EntityModel.DocumentInfoModel
            {
                Data = model,
                Pager = new BLL.Models.Report.Paging.Pager(model.Count(), 1, 50)
            };

            return View("~/Areas/Journal/Views/Home/ArchiveNotes.cshtml", viewModel);
        }

        [HttpPost]
        //[ValidateAntiForgeryToken]
        public ActionResult EditNote(string note, int docid)
        {
            _unitOfWork.EditNote(docid, note, SessionHelper.UserId, 0);

            return Json(null);
        }

        [HttpPost]
        public JsonResult Document(int year = 0, int pageIndex = 1, int pageSize = 35)
        {
            if (Request.UrlReferrer == null)
                return Json("Referer not exist", JsonRequestBehavior.AllowGet);
            
            int doctype =int.Parse(HttpUtility.ParseQueryString(Request.UrlReferrer.Query)["docType"]);
            
            var model = _unitOfWork.GetJournal(0, 0, year, pageIndex, pageSize, SessionHelper.OrganizationId, doctype,
                Request.ToSqlParams());
            //model = model.Skip(skipped).Take(pageSize);
            return Json(model, JsonRequestBehavior.AllowGet);
        }

        [HttpGet]
        public ActionResult RequestsIndex(int docType)
        {
            using (BllDocumentAdapter adapter = new BllDocumentAdapter(_unitOfWork))
            {
                var documentGroup = adapter.GetDocumentGroupModel(docType);

                if (documentGroup != null)
                {
                    ViewData["DocTypeName"] = "Daxil olan " + documentGroup.TreeName + "nin qeydə alınması e-kitabı";
                    ViewData["DocTypeGroupName"] = documentGroup.DocTypeGroupName;
                }
            }
            
            if(docType==3)
                return View("~/Areas/Journal/Views/Home/InsDocsJournal.cshtml");
            
            if(docType==12)
                return View("~/Areas/Journal/Views/Home/Index.cshtml");

            return View("~/Areas/Journal/Views/Home/RequestsIndex.cshtml");
        }

        [HttpPost]
        public JsonResult Requests(int year = 0, int pageIndex = 1, int pageSize = 35)
        {
            if (Request.UrlReferrer == null)
                return Json("Referer not exist", JsonRequestBehavior.AllowGet);
            
            int doctype =int.Parse(HttpUtility.ParseQueryString(Request.UrlReferrer.Query)["docType"]);

            var model =doctype==12 ? _unitOfWork.GetRequestInfo(0, 0, year, pageIndex, pageSize, SessionHelper.OrganizationId,
                doctype, Request.ToSqlParams()) : 
                _unitOfWork.GetRequestInfoForOtherDocTypes(0, 0, year, pageIndex, pageSize, SessionHelper.OrganizationId,
                    doctype, Request.ToSqlParams());
            return Json(model, JsonRequestBehavior.AllowGet);
        }


        [HttpGet]
        public ActionResult GetBlankType()
        {
            var model = _unitOfWork.GetBlankType(null, null, 0, 0, 0);

            return View("~/Areas/Journal/Views/Home/BlankType.cshtml", model);
        }


        [HttpPost]
        public JsonResult EditBlank(string prevblank, int newblanktype, int newblankno, int docid)
        {
            _unitOfWork.EditBlank(prevblank, newblanktype, newblankno, 1, docid);

            return Json(null);
        }
    }
}