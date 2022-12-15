using AzDoc.Attributes;
using AzDoc.Helpers;
using BLL.Common.Enums;
using Repository.Infrastructure;
using Smdo.AzDoc.Models;
using Smdo.Enums;
using Smdo.SmtpListener;
using System;
using System.IO;
using System.Linq;
using System.Web.Mvc;
using SmdoAdapter = Smdo.AzDoc.Adapters.DocumentAdapter;

namespace AzDoc.Areas.Smdo.Controllers
{
    [DocTypeMark(DocType.Smdo)]
    public class DocumentController : Controller
    {
        private readonly IUnitOfWork unitOfWork;

        private const int DocTypeId = (int)DocType.Smdo;
        private const string FilePath = "~/App_Data/UploadTemp/NDA_ДТС_РФ-АР.docx";
        public DocumentController(IUnitOfWork unitOfWork) => this.unitOfWork = unitOfWork;


        public ActionResult IndexSended()
        {
            string path = Server.MapPath(@"~\App_Data\UploadTemp\");

            //POP3Listener.Start(path, false);

            SessionHelper.DocTypeId = DocTypeId;
            ViewBag.Sended = true;
            return View("~/Areas/Smdo/Views/Document/Index.cshtml");
        }

        public ActionResult IndexReceived()
        {
            string path = Server.MapPath(@"~\App_Data\UploadTemp\");

            //POP3Listener.Start(path, false);
            SessionHelper.DocTypeId = DocTypeId;
            ViewBag.Sended = false;
            return View("~/Areas/Smdo/Views/Document/Index.cshtml");
        }

        [HttpGet]
        public ActionResult AddNewDocument()
        {
            SessionHelper.ClearHelperSession();
            SessionHelper.ClearDocId();

            using (SmdoAdapter adapter = new SmdoAdapter(unitOfWork))
            {
                SmdoDocumentModel model = new SmdoDocumentModel(adapter, SessionHelper.WorkPlaceId)
                {
                    IsNew = true,
                    HasSign = false,
                    IsCreated = false,
                    DocFormId = 34,
                    SendFormId = 8
                };
                TempData["DocumentView"] = Server.MapPath(FilePath);

                return View("~/Areas/Smdo/Views/Document/AddNewDocument.cshtml", model);
            }
        }

        [HttpPost]
        public JsonResult GetReceivedDocs()
        {
            using (var adapter = new SmdoAdapter(unitOfWork))
            {
                var data = adapter.GetDocs(DocReceived.Received);

                return Json(new { totalCount = data.Count(), Items = data }, JsonRequestBehavior.AllowGet);
            }
        }


        [HttpPost]
        public JsonResult GetSendedDocs()
        {
            using (var adapter = new SmdoAdapter(unitOfWork))
            {
                var data = adapter.GetDocs(DocReceived.Sended);

                return Json(new { totalCount = data.Count(), Items = data }, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpGet]
        public ActionResult ElectronicDocument(int docId)
        {
            using (var adapter = new SmdoAdapter(unitOfWork))
            {
                var doc = adapter.GetCurrentDoc(docId);

                if (doc is null) throw new ArgumentException("Data is null");

                SessionHelper.CurrentDocId = docId;
                SessionHelper.SmdoDocGuid = doc.DocMsgGuid;

                string path = Server.MapPath($"~/App_Data/UploadTemp/{doc.DocMsgGuid}/");

                TempData["DocumentView"] = doc.IsReceived ? $"{path}{doc.AttachName}" : $"{path}{doc.DocFilePath}";

                return View("~/Areas/Smdo/Views/Document/ElectronicDocument.cshtml", doc);
            }
        }

        [HttpGet]
        public ActionResult GetFileBase64()
        {
            using (var adapter = new SmdoAdapter(unitOfWork))
            {
                var doc = adapter.GetCurrentDoc(SessionHelper.CurrentDocId);
                string path = Server.MapPath("~/App_Data/UploadTemp/");
                using (var stream = System.IO.File.Open(path + $"/{doc.DocMsgGuid}/{doc.DocFilePath}", FileMode.Open))
                {
                    using (var mStream = new MemoryStream())
                    {
                        stream.CopyTo(mStream);

                        var buffer = mStream.ToArray();

                        return Json(new
                        {
                            base64 = Convert.ToBase64String(buffer),
                            fileName = doc.DocFilePath
                        }, JsonRequestBehavior.AllowGet);
                    }
                }
            }
        }

        [HttpGet]
        public ActionResult GetDocView()
        {
            using (var adapter = new SmdoAdapter(unitOfWork))
            {
                var doc = adapter.GetCurrentDoc(SessionHelper.CurrentDocId);
                string path = Server.MapPath("~/App_Data/UploadTemp/");

                TempData["DocumentView"] = $"{path}/{doc.DocMsgGuid}/{doc.DocFilePath}";

                return View("~/Areas/Smdo/Views/Document/DocumentDisplay.cshtml");
            }
        }

        [HttpPost]
        public ActionResult WriteP7S(string p7SBase64)
        {
            if (!string.IsNullOrEmpty(p7SBase64))
            {
                var buffer = Convert.FromBase64String(p7SBase64);

                using (var adapter = new SmdoAdapter(unitOfWork))
                {
                    var doc = adapter.GetCurrentDoc(SessionHelper.CurrentDocId);

                    System.IO.File.WriteAllBytes($"{Server.MapPath("~/App_Data/UploadTemp/")}{doc.DocMsgGuid}/sign.p7s", buffer);

                    adapter.ChangeDocStatus(SessionHelper.CurrentDocId, (int)DocStatus.Signed);

                    return Json(true, JsonRequestBehavior.AllowGet);
                }
            }

            return Json(false, JsonRequestBehavior.AllowGet);
        }
    }

}