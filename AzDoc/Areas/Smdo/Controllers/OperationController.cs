using AzDoc.Attributes;
using AzDoc.Helpers;
using BLL.Common.Enums;
using Repository.Infrastructure;
using Smdo.AzDoc.Models;
using Smdo.Enums;
using System;
using System.IO;
using System.Web;
using System.Web.Mvc;
using SmdoAdapter = Smdo.AzDoc.Adapters.DocumentAdapter;

namespace AzDoc.Areas.Smdo.Controllers
{
    [DocTypeMark(DocType.Smdo)]
    public class OperationController : Controller
    {
        private readonly IUnitOfWork unitOfWork;

        private const int DocTypeId = (int)DocType.Smdo;
        public OperationController(IUnitOfWork unitOfWork) => this.unitOfWork = unitOfWork;

        [HttpPost]
        public ActionResult SignDocument()
        {
            using (SmdoAdapter adapter = new SmdoAdapter(unitOfWork))
            {
                adapter.ChangeDocStatus(SessionHelper.CurrentDocId, (int)DocStatus.Signed);

                return Json(true, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpPost]
        public ActionResult SendDocument()
        {
            using (SmdoAdapter adapter = new SmdoAdapter(unitOfWork))
            {
                adapter.ChangeDocStatus(SessionHelper.CurrentDocId, (int)DocStatus.Sended);

                return Json(true, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpPost]
        public ActionResult CreateReceivedDoc()
        {
            using (SmdoAdapter adapter = new SmdoAdapter(unitOfWork))
            {
                adapter.CreateReceivedDoc();

                return Json(true, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpPost]
        public ActionResult CreateDocument(HttpPostedFileBase fileBase)
        {
            SmdoDocumentModel model = new SmdoDocumentModel();
            model.IsNew = true;
            model.DocCreatorWorkPlace = SessionHelper.WorkPlaceId;
            model.Guid = Guid.NewGuid().ToString();
            model.DocFormId = 34;
            model.SendFormId = 8;
            model.Note = "Qisa mezmun";
            var form =new FormCollection().GetValue("Note");
            //if (model is null) throw new ArgumentException("Model is null");

            //var files = Request.Files;
            if (fileBase is null) throw new ArgumentException("file is null");

            using (SmdoAdapter adapter = new SmdoAdapter(unitOfWork))
            {
                if (!string.IsNullOrEmpty(SessionHelper.SmdoDocGuid))
                {
                    string path1 = Server.MapPath($@"~\App_Data\UploadTemp\{SessionHelper.SmdoDocGuid}");

                    DirectoryInfo info = new DirectoryInfo(path1);

                    foreach (var file in info.GetFiles())
                    {
                        file.Delete();
                    }

                    fileBase.SaveAs(path1 + $"/{fileBase.FileName}");

                    adapter.ChangeFile(SessionHelper.SmdoDocGuid, fileBase.FileName);

                    return Json(true, JsonRequestBehavior.AllowGet);
                }


                //model.IsNew = true;
                //model.DocCreatorWorkPlace = SessionHelper.WorkPlaceId;
                //model.Guid = Guid.NewGuid().ToString();
                //model.DocFormId = 34;
                //model.SendFormId = 8;

                string path = Server.MapPath($@"~\App_Data\UploadTemp\{model.Guid}");
                Directory.CreateDirectory(path);

                fileBase.SaveAs(path + $"/{fileBase.FileName}");
                model.FileName = fileBase.FileName;

                SessionHelper.CurrentDocId = adapter.SaveDocument(model);
                SessionHelper.SmdoDocGuid = model.Guid;

                return Json(true, JsonRequestBehavior.AllowGet);
            }
        }
    }

}