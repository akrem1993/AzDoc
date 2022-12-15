using AppCore.Interfaces;
using AzDoc.Attributes;
using AzDoc.Helpers;
using BLL.Common.Enums;
using Newtonsoft.Json;
using ReserveDocs.Adapters;
using ReserveDocs.Model.EntityModel;
using Repository.Infrastructure;
using System.Linq;
using System.Web.Mvc;
using System.Web.Routing;
using Widgets.Helpers;
using CustomHelpers;
using ReserveDocs.Model.FormModel;
using BLL.Models.Direction.Common;
using System.Collections.Generic;
using System.Web;
using System;

namespace AzDoc.Areas.ReserveDocs.Controllers
{
    [DocTypeMark(DocType.ReserveDocs)]
    public class DocumentController : Controller
    {
        private readonly IUnitOfWork _unitOfWork;
        private readonly IServerPath serverPath;
        private const int DocTypeId = (int)DocType.ReserveDocs;
        // GET: ReserveDocs/Document

        public DocumentController(IUnitOfWork unitOfWork, IServerPath serverPath)
        {
            _unitOfWork = unitOfWork;
            this.serverPath = serverPath;
        }

        public ActionResult Index()
        {
            if (Request.UrlReferrer == null && TempData["IsReturn"] == null)
                return Redirect();

            SessionHelper.DocTypeId = DocTypeId;

            using (BLL.Adapters.DocumentAdapter adapter = new BLL.Adapters.DocumentAdapter(_unitOfWork))
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
        public ActionResult Redirect()
        {
            var values = new RouteValueDictionary()
            {
                { "docType", DocTypeId}
            };

            TempData["IsReturn"] = true;
            return RedirectToAction("Index", "Document", values);
        }
        [HttpPost]
        public JsonResult Document(int? periodId, int pageIndex = 1, int docType = 12, int pageSize = 20)
        {
            SessionHelper.ClearDocId();

            int skipped = pageSize * (pageIndex - 1);

            var docs = _unitOfWork.GetDocumentGridModel(SessionHelper.WorkPlaceId,
                periodId,
                DocTypeId,
                pageIndex,
                pageSize, out int totalCount);
            docs.TotalCount = totalCount;

            return Json(docs);
        }
        [HttpGet]
        // [Permission(RightType.CreateDoc)]
        public ActionResult AddNewDocument()
        {
            if (Request.UrlReferrer == null)
                return Redirect();

            SessionHelper.ClearHelperSession();
            SessionHelper.ClearDocId();

            if (DocTypeId != -1)
            {
                return View(_unitOfWork.GetOutgoingReserveDocViewModel(DocTypeId, SessionHelper.WorkPlaceId));
            }

            return null;
        }
        [HttpPost]
        public ActionResult AddNewDocument(DocumentFormModel model)
        {
            if (Request.UrlReferrer == null)
                return Redirect();

            if (DocTypeId != -1)
            {
                _unitOfWork.SaveReserveDocument(SessionHelper.WorkPlaceId, DocTypeId, model, SessionHelper.CurrentDocId, out int result);
                if (result == (int)(DBResultOutputParameter.Success))
                {
                    SessionHelper.ClearHelperSession();
                    SessionHelper.ClearDocId();
                    return Json(result == (int)DBResultOutputParameter.Success, JsonRequestBehavior.AllowGet);
                }
            }
            return View();
        }
        [HttpGet]
        public ActionResult SetReserveNumber()
        {
            var token = Request.QueryString["token"];
            if (token == null)
                return Redirect();
            ViewData["DocId"] = token;
            var splitWorkPlaceId = CustomHelper.Decrypt(HttpUtility.UrlDecode(this.GetToken())).Split('-')[0].ToInt();
            var splitDocId = CustomHelper.Decrypt(HttpUtility.UrlDecode(this.GetToken())).Split('-')[2].ToInt();
            SessionHelper.ClearDocId();
            List<ReserveNumbers> model = _unitOfWork.GetReserveNumbers(splitWorkPlaceId, splitDocId);
            if (model.Count != 0 && model.FirstOrDefault().ReserveDocdId == 0)
            {
                return Json(false, JsonRequestBehavior.AllowGet);
            }
            return View("_SetReserveDocument", model);

        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult SetReserveNumber(ReserveNumbers model)
        {
            var token = CustomHelper.Decrypt(HttpUtility.UrlDecode(this.GetToken()));
            var splitWorkPlaceId = token.Split('-')[0].ToInt();
            var splitDocId = token.Split('-')[2].ToInt();
            _unitOfWork.SetReserveNumbers(model, splitDocId, out int result);
            return Json(result == (int)DBResultOutputParameter.Success, JsonRequestBehavior.AllowGet);

        }
    }
}