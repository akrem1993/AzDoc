using AppCore.Interfaces;
using AzDoc.Helpers;
using AzDoc.Models.Application;
using Repository.Infrastructure;
using System.Web.Mvc;
using BLL.CoreAdapters;
using ORM.Context;
using Repository.UnitOfWork;

namespace AzDoc.BaseControllers
{
    public abstract class BaseController : Controller
    {
        protected readonly IUnitOfWork unitOfWork;
        protected readonly IServerPath serverPath;
        protected IUserToken Token;

        protected BaseController(IUnitOfWork unitOfWork)
        {
            this.unitOfWork = unitOfWork;
            serverPath = new ServerPathHandler();
        }

        protected override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            base.OnActionExecuting(filterContext);
            Token = Request?.GetToken();
        }

        protected void CacheDoc()
        {
            using (var adapter = new CoreAdapter(unitOfWork))
            {
                adapter.CacheDoc(SessionHelper.CurrentDocId);
                adapter.CacheDoc(Token.DocId);
            }
        }
        
        protected void CacheDoc(int docId)
        {
            if (docId < 1)
                return;
            using (var adapter = new CoreAdapter(unitOfWork))
            {
                adapter.CacheDoc(docId);
            }
        }

        [ChildActionOnly]
#if !DEBUG
        [OutputCache(Duration = 14400, VaryByParam = "none")]
#endif
        public ActionResult GetGridView()
        {
            return PartialView("GridViewPartial");
        }
    }
}