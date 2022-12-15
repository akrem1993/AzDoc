using AzDoc.Attributes;
using AzDoc.BaseControllers;
using AzDoc.Helpers;
using BLL.Common.Enums;
using BLL.CoreAdapters;
using CustomHelpers;
using InsDoc.Model.FormModel;
using Repository.Infrastructure;
using System;
using System.Linq;
using System.Web.Mvc;
using InsDoc.Adapters;

namespace AzDoc.Areas.InsDoc.Controllers
{
    [DocTypeMark(DocType.InsDoc)]
    public class OperationController : BaseController
    {
        private const int DocTypeId = (int) DocType.InsDoc;

        public OperationController(IUnitOfWork unitOfWork) : base(unitOfWork)
        {
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult AcceptViza(string description)
        {
            using (var adapter = new CoreAdapter(unitOfWork))
            {
                adapter.ExecuteOperation(
                    ActionType.Accept,
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
        public ActionResult SignDocument(string description)
        {
            lock (Session.SyncRoot)
            {
                using (var adapter = new CoreAdapter(unitOfWork))
                {
                    adapter.ExecuteOperation(
                        ActionType.Signature,
                        SessionHelper.CurrentDocId,
                        SessionHelper.WorkPlaceId,
                        description,
                        out int result);

                }
            }
            
            CacheDoc();
            return Json(true, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [Permission(RightType.CreateDoc)]
        public ActionResult CreateDocument(DocumentFormModel model, string fileInfoId)
        {
            if (model is null)
                throw new ArgumentException("Model is null");

            if (model.TaskFormModels is null)
                throw new ArgumentException("Task model is null");


            int currentDocId = 0;
            if (!string.IsNullOrEmpty(fileInfoId))
                currentDocId = new FileAdapter(unitOfWork).GetFileInfoIdByDocId(fileInfoId.ToInt());

            if (model.RedirectPersonInput != null)
            {
                model.RedirectPersonInput = model.RedirectPersonInput
                    .GroupBy(x => x.PersonWorkPlace)
                    .Select(x => x.FirstOrDefault())
                    .ToList();
            }

            int result;
            lock (Session.SyncRoot)
            {
                using (DocumentAdapter adapter = new DocumentAdapter(unitOfWork))
                {
                    adapter.SaveDocument(SessionHelper.WorkPlaceId, DocTypeId, currentDocId, model, out result);
                    if (result == (int) DBResultOutputParameter.Success)
                    {
                        SessionHelper.ClearHelperSession();
                        SessionHelper.ClearDocId();
                    }
                }
            }
            
            CacheDoc(currentDocId);
            return Json(result, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult EditDocument(DocumentFormModel model)
        {
            if (model is null)
                throw new ArgumentException("Model is null");

            using (DocumentAdapter adapter = new DocumentAdapter(unitOfWork))
            {
                adapter.EditDocument(Token.WorkPlaceId, DocTypeId, Token.DocId, model, out int result);
                if (result == (int) DBResultOutputParameter.Success)
                {
                    SessionHelper.ClearHelperSession();
                    SessionHelper.ClearDocId();
                }

                CacheDoc();
                return Json(result == (int) DBResultOutputParameter.Success, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteRedirectedPerson(int redirectId)
        {
            using (DocumentAdapter adapter = new DocumentAdapter(unitOfWork))
            {
                adapter.DeleteRedirect(redirectId);
                CacheDoc();

                return Json(true);
            }
        }

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
                throw new ArgumentException("Qeyd daxil edin");

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