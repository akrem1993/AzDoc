using AzDoc.Attributes;
using AzDoc.BaseControllers;
using AzDoc.Helpers;
using BLL.Common.Enums;
using BLL.CoreAdapters;
using ColleagueRequests.Adapters;
using ColleagueRequests.Model.FormModel;
using CustomHelpers;
using Repository.Infrastructure;
using System;
using System.Web.Mvc;

namespace AzDoc.Areas.ColleagueRequests.Controllers
{
    [DocTypeMark(DocType.ColleagueRequests)]
    public class OperationController : BaseController
    {
        private const int DocTypeId = (int)DocType.ColleagueRequests;

        public OperationController(IUnitOfWork unitOfWork) : base(unitOfWork) { }


        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult CreateDocument(DocumentFormModel model, string fileInfoId)
        {
            if (model is null)
                throw new ArgumentException("Model is null");

            int currentDocId = 0;
            if (!string.IsNullOrEmpty(fileInfoId))
            {
                var controller = new FileAdapter(unitOfWork);
                currentDocId = controller.GetFileInfoIdByDocId(fileInfoId.ToInt());
            }

            int result;
            lock (Session.SyncRoot)
            {
                using (DocumentAdapter adapter = new DocumentAdapter(unitOfWork))
                {

                    adapter.SaveDocument(SessionHelper.WorkPlaceId, DocTypeId, currentDocId, model, out result);
                    if (result == (int)DBResultOutputParameter.Success)
                    {
                        SessionHelper.ClearHelperSession();
                        SessionHelper.ClearDocId();
                    }
                }
            }

            CacheDoc(currentDocId);
            return Json(result == (int)DBResultOutputParameter.Success, JsonRequestBehavior.AllowGet);
        }


        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult EditDocument(DocumentFormModel model)
        {
            if (model is null)
                throw new ArgumentException("Model is null");

            using (DocumentAdapter adapter = new DocumentAdapter(unitOfWork))
            {
                adapter.EditDocument(
                    Token.WorkPlaceId,
                    DocTypeId,
                    Token.DocId,
                    model,
                    out int result);
                CacheDoc();

                return Json(result == (int)DBResultOutputParameter.Success, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult SendDocument(string description)
        {
            using (var adapter = new CoreAdapter(unitOfWork))
            {
                adapter.ExecuteOperation(
                    ActionType.Send,
                    Token.DocId,
                    Token.WorkPlaceId,
                    description,
                    out int result);
                CacheDoc();

                return Json(true, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult RecognizedDocument(string description)
        {
            using (var adapter = new CoreAdapter(unitOfWork))
            {
                adapter.ExecuteOperation(
                    ActionType.Recognized,
                    Token.DocId,
                    Token.WorkPlaceId,
                    description,
                    out int result);
                CacheDoc();

                return Json(true, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult CancelDocument(string description)
        {
            using (var adapter = new CoreAdapter(unitOfWork))
            {
                adapter.ExecuteOperation(
                    ActionType.Cancel,
                    Token.DocId,
                    Token.WorkPlaceId,
                    description,
                    out int result);
                CacheDoc();

                return Json(true, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult ReturnDocument(string description)
        {
            if (string.IsNullOrEmpty(description))
                throw new ArgumentException("Qeyd daxil edin!");

            using (var adapter = new CoreAdapter(unitOfWork))
            {
                adapter.ExecuteOperation(
                    ActionType.Return,
                    Token.DocId,
                    Token.WorkPlaceId,
                    description,
                    out int result);
                CacheDoc();

                return Json(true, JsonRequestBehavior.AllowGet);
            }
        }
    }
}