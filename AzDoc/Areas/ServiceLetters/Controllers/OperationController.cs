using AzDoc.Attributes;
using AzDoc.Helpers;
using BLL.Common.Enums;
using BLL.CoreAdapters;
using CustomHelpers;
using Repository.Infrastructure;
//using ServiceLetters.Common.Enums;
using ServiceLetters.Model.FormModel;
using System;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using AzDoc.BaseControllers;
using BLL.Common.Enums.DMSEnums;
using BllAdapter = BLL.Adapters.DocumentAdapter;
using DocType = BLL.Common.Enums.DocType;
using RightType = BLL.Common.Enums.RightType;
using ServiceAdapter = ServiceLetters.Adapters.DocumentAdapter;
using Newtonsoft.Json;
using Model.Models.Viza;

namespace AzDoc.Areas.ServiceLetters.Controllers
{
    [DocTypeMark(DocType.ServiceLetters)]
    public class OperationController : BaseController
    {

        private const int DocTypeId = (int)DocType.ServiceLetters;

        public OperationController(IUnitOfWork unitOfWork) : base(unitOfWork)
        {
        }


        [HttpPost]
        [ValidateAntiForgeryToken]
        //[Permission(RightType.AcceptViza)]
        public ActionResult AcceptViza(string description)
        {
            var token = CustomHelper.Decrypt(HttpUtility.UrlDecode(Request.QueryString["token"]));
            if (token == null)
                return Json(false, JsonRequestBehavior.AllowGet);

            var splitWorkPlaceId = Convert.ToInt32(token.Split('-')[0]);
            var splitDocId = Convert.ToInt32(token.Split('-')[2]);

            using (BllAdapter adapter = new BllAdapter(unitOfWork))
            {
                adapter.PostActionOperation((int)ActionType.Accept, splitDocId,
                    splitWorkPlaceId, description, out int result);
                CacheDoc();

                return Json(true, JsonRequestBehavior.AllowGet);
            }
        }


        [HttpPost]
        [ValidateAntiForgeryToken]
        //[Permission(RightType.SignDocument)]
        public ActionResult SignDocument(string description)
        {
            int result;
            lock (Session.SyncRoot)
            {
                using (BllAdapter adapter = new BllAdapter(unitOfWork))
                {
                    adapter.PostActionOperation((int)ActionType.Signature, SessionHelper.CurrentDocId,
                         SessionHelper.WorkPlaceId, description, out result);
                }
            }
            
            CacheDoc();

            return Json(true, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
#if !DEBUG
        [Permission(RightType.CreateDoc)]
#endif
        public ActionResult CreateDocument(DocumentFormModel model, string fileInfoId)
        {
            if (model is null) Thrower.Args("Model is null");

            lock (Session.SyncRoot)
            {
                int currentDocId = 0;
                if (!string.IsNullOrEmpty(fileInfoId))
                    currentDocId = new FileAdapter(unitOfWork).GetFileInfoIdByDocId(fileInfoId.ToInt());


                using (ServiceAdapter adapter = new ServiceAdapter(unitOfWork))
                {
                    adapter.SaveDocument(SessionHelper.WorkPlaceId, DocTypeId, currentDocId, model, out int result);
                    CacheDoc(currentDocId);
                    CacheDoc(SessionHelper.AnswerDocId);
                    if (result == (int)DBResultOutputParameter.Success)
                    {
                        SessionHelper.ClearHelperSession();
                        SessionHelper.ClearDocId();
                    }
                    return Json(result, JsonRequestBehavior.AllowGet);
                }
            }
        }


        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult EditDocument(DocumentFormModel model)
        {
            if (model is null)
                throw new ArgumentException("Model is null");


            using (ServiceAdapter adapter = new ServiceAdapter(unitOfWork))
            {
                adapter.EditDocument(Token.WorkPlaceId, DocTypeId, Token.DocId, model, out int result);
                CacheDoc();
                if (result == (int)DBResultOutputParameter.Success)
                {
                    SessionHelper.ClearHelperSession();
                    SessionHelper.ClearDocId();
                }
                return Json(result == (int)DBResultOutputParameter.Success, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        //[Permission(RightType.AcceptViza)]
        public ActionResult AcceptDocument(string description)
        {
            var token = CustomHelper.Decrypt(HttpUtility.UrlDecode(Request.QueryString["token"]));
            if (token == null)
                return Json(false, JsonRequestBehavior.AllowGet);
            var splitWorkPlaceId = Convert.ToInt32(token.Split('-')[0]);
            var splitDocId = Convert.ToInt32(token.Split('-')[2]);

            using (BllAdapter adapter = new BllAdapter(unitOfWork))
            {
                adapter.PostActionOperation((int)ActionType.Accept, splitDocId,
                    splitWorkPlaceId, description, out int result);
                CacheDoc();

                return Json(true, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        //[Permission(RightType.SendToPerson)]
        public ActionResult SendDocument(string description)
        {
            using (BllAdapter adapter = new BllAdapter(unitOfWork))
            {
                adapter.PostActionOperation((int)ActionType.Send, Token.DocId,
                    Token.WorkPlaceId, description, out int result);
                CacheDoc();

                return Json(true, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult RecognizedDocument(string description)
        {
            using (BllAdapter adapter = new BllAdapter(unitOfWork))
            {
                adapter.PostActionOperation((int)ActionType.Recognized, Token.DocId,
                    Token.WorkPlaceId, description, out int result);
                CacheDoc();

                return Json(true, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        //[Permission(RightType.ReturnDocument)]
        public ActionResult CancelDocument(string description)
        {
            using (BllAdapter adapter = new BllAdapter(unitOfWork))
            {
                adapter.PostActionOperation((int)ActionType.Cancel, Token.DocId,
                    Token.WorkPlaceId, description, out int result);
                CacheDoc();

                return Json(true, JsonRequestBehavior.AllowGet);
            }
        }


        [HttpPost]
        [ValidateAntiForgeryToken]
        // [Permission(RightType.ReturnDocument)]
        public ActionResult ReturnDocument(string description)
        {
            if (string.IsNullOrEmpty(description))
                throw new ArgumentException("Qeyd daxil edin");

            using (BllAdapter adapter = new BllAdapter(unitOfWork))
            {
                adapter.PostActionOperation((int)ActionType.Return, Token.DocId,
                    Token.WorkPlaceId, description, out int result);
                CacheDoc();

                return Json(true, JsonRequestBehavior.AllowGet);
            }
        }
    }
}