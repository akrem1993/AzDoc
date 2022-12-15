using AppCore.Interfaces;
using AzDoc.Attributes;
using BLL.Common.Enums;
using Repository.Infrastructure;
using System.Web.Mvc;

namespace AzDoc.BaseControllers
{
    public abstract class BaseDocumentController : BaseController
    {
        protected BaseDocumentController(IUnitOfWork unitOfWork) : base(unitOfWork) { }

        [HttpGet]
        public abstract ActionResult Index();

        [HttpGet]
        [Permission(RightType.CreateDoc)]
        [CheckSftp]
        public abstract ActionResult AddNewDocument();

        [HttpGet]
        [CheckSftp]
        public abstract ActionResult EditDocument();

        [HttpGet]
        public abstract ActionResult DocInfo(int docId);

        [HttpGet]
        [CheckSftp]
        public abstract ActionResult ElectronicDocument(int docId, int executorId);

        [HttpGet]
        [CheckSftp]
        public abstract FileContentResult DownloadFile(int fileInfoId);

    }
}