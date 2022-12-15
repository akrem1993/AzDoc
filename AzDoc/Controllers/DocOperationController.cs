using AzDoc.BaseControllers;
using AzDoc.Helpers;
using BLL.Common.Enums;
using BLL.CoreAdapters;
using Repository.Infrastructure;
using System.Web.Mvc;

namespace AzDoc.Controllers
{
    [ValidateAntiForgeryToken]
    public class DocOperationController : BaseController
    {
        public DocOperationController(IUnitOfWork unitOfWork) : base(unitOfWork)
        {
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult AcceptViza(string note)
        {
            using (var adapter = new CoreAdapter(unitOfWork))
            {
                adapter.ExecuteOperation(
                    ActionType.Accept,
                    Token.DocId,
                    Token.WorkPlaceId,
                    note,
                    out int result);

                CacheDoc();
                return Json(true, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult ConfirmDocument(string note)
        {
            using (var adapter = new CoreAdapter(unitOfWork))
            {
                adapter.ExecuteOperation(
                    ActionType.Accept,
                    Token.DocId,
                    Token.WorkPlaceId,
                    note,
                    out int result);
                CacheDoc();

                return Json(true, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpPost]
        public ActionResult SendDocument()
        {
            using (var adapter = new CoreAdapter(unitOfWork))
            {
                adapter.ExecuteOperation(
                    ActionType.Send,
                    Token.DocId,
                    Token.WorkPlaceId,
                    string.Empty,
                    out int res);
                CacheDoc();

                return Json(true, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult CancelDocument(string note)
        {
            using (var adapter = new CoreAdapter(unitOfWork))
            {
                adapter.ExecuteOperation(
                    ActionType.Cancel,
                    Token.DocId,
                    Token.WorkPlaceId,
                    note,
                    out int res);
                CacheDoc();

                return Json(true, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult ConfirmSign(string note)
        {
            using (var adapter = new CoreAdapter(unitOfWork))
            {
                adapter.ExecuteOperation(
                    ActionType.Signature,
                    Token.DocId,
                    Token.WorkPlaceId,
                    note,
                    out int res);
                CacheDoc();

                return Json(true, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult ReturnDocument(string note)
        {
            using (var adapter = new CoreAdapter(unitOfWork))
            {
                adapter.ExecuteOperation(
                    ActionType.Return,
                    Token.DocId,
                    Token.WorkPlaceId,
                    note,
                    out int res);
                CacheDoc();

                return Json(true, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult DisposeDocument(string note)
        {
            note.CheckString("Qeyd daxil edin");

            using (var adapter = new CoreAdapter(unitOfWork))
            {
                adapter.ExecuteOperation(
                    ActionType.DisposeDoc,
                    Token.DocId,
                    Token.WorkPlaceId,
                    note,
                    out int res);
                CacheDoc();

                return Json(true, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult RecognizedDocument(int executorId)
        {
            using (var adapter = new CoreAdapter(unitOfWork))
            {
                adapter.ExecuteOperation(
                    ActionType.Recognized,
                    Token.DocId,
                    Token.WorkPlaceId,
                    string.Empty,
                    out int res,
                    executorId);
                CacheDoc();

                return Json(true, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult ApproveDocument(string note)
        {
            using (var adapter = new CoreAdapter(unitOfWork))
            {
                adapter.ExecuteOperation(
                    ActionType.Approve,
                    Token.DocId,
                    Token.WorkPlaceId,
                    note,
                    out int res);
                CacheDoc();

                return Json(res, JsonRequestBehavior.AllowGet);
            }
        }
    }
}