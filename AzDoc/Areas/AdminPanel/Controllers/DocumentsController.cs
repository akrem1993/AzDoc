using Repository.Infrastructure;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Admin.Adapters;
using Admin.Model.ViewModel;
using AzDoc.Helpers;
using Admin.Model.ViewModel.EditDocument;
using AzDoc.BaseControllers;

namespace AzDoc.Areas.AdminPanel.Controllers
{
    public class DocumentsController : BaseController
    {
        public DocumentsController(IUnitOfWork unitOfWork): base(unitOfWork)
        {
        }

        // GET: AdminPanel/Documents
        public ActionResult Index()
        {
            return View();
        }

        [HttpPost]
        public JsonResult DeleteResolution(string docenterno = "0", int pageIndex = 1, int pageSize = 35)
        {

            var model = unitOfWork.GetInfo(docenterno, pageIndex, pageSize);
            CacheDoc();
            //return View("~/Areas/AdminPanel/Views/Documents/DeleteResolution.cshtml",model);
            return Json(model, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public int DeleteResolutionInfo(int docid, int executorworkplaceid, int directionid, int operationtype, int sendstatus)
        {

            unitOfWork.DeleteResolutionInfo(docid, executorworkplaceid, directionid, operationtype, SessionHelper.WorkPlaceId, Request.UserHostAddress, sendstatus);

            CacheDoc(docid);
            return 1;
        }

        [HttpGet]
        public ActionResult SelectUser()
        {

            var model = unitOfWork.SelectUser();

            return View("~/Areas/AdminPanel/Views/Documents/CreateResolutionRole.cshtml", model);
        }
        [HttpGet]
        public ActionResult SelectUser2()
        {

            var model = unitOfWork.SelectUser();

            return View("~/Areas/AdminPanel/Views/Documents/AddDeleteExecutor.cshtml", model);
        }

        [HttpPost]
        public int AddResolutionRole(int workplaceid1, int workplaceid2)
        {

            unitOfWork.AddResolutionUser(workplaceid1, workplaceid2, SessionHelper.WorkPlaceId, Request.UserHostAddress);
            CacheDoc();

            return 1;
        }
        [HttpPost]
        public int AddDeleteExecutorForDirection(int directionworkplaceid, int executorworkplaceid, string checkvalue)
        {

            unitOfWork.AddExecutorForDirection(directionworkplaceid, executorworkplaceid, checkvalue, DateTime.Now.Date, SessionHelper.WorkPlaceId);
            CacheDoc();

            return 1;
        }

        [HttpGet]
        public ActionResult GetExecutor(int doctype, string docno)
        {
            var model = unitOfWork.GetExecutor(doctype, docno);
            CacheDoc();
            return View("~/Areas/AdminPanel/Views/Documents/GetExecutorSelectPicker.cshtml", model);
        }

        [HttpPost]
        public int AddEditWorkplace(int doctype, string docno, int execworkplaceid)
        {
            var model = unitOfWork.AddDocsEditWorkplace(doctype, docno, execworkplaceid, SessionHelper.WorkPlaceId, Request.UserHostAddress);
            CacheDoc();
            return 1;
        }

        [HttpGet]
        public ActionResult EditDoc(int docId)
        {
            var doc = unitOfWork.GetDocById(docId);

            var editModel = new EditDocumentViewModel
            {
                DocId = docId,
                Status = (int)doc.DocDocumentstatusId,
                StatusList = unitOfWork.GetDocStatusList(),
                DocUndercontrolStatusList = unitOfWork.GetDocUnderControlStatusList(),
                DocUndercontrolStatusId = (int)doc.DocUndercontrolStatusId
            };

            return PartialView("~/Areas/AdminPanel/Views/Documents/_EditDoc.cshtml", editModel);
        }


        [HttpPost]
        public ActionResult EditDoc(int docId, int statusId,int undercontrolstatusId)
        {
            unitOfWork.ChangeDocStatus(docId, statusId, undercontrolstatusId);
            CacheDoc();

            return Json(1);
        }
    }
}