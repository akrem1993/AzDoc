using Repository.Infrastructure;
using System.Web.Mvc;

namespace AzDoc.BaseControllers
{
    public abstract class BaseOperationController : AntiForgeryController
    {
        protected BaseOperationController(IUnitOfWork unitOfWork) : base(unitOfWork) { }
        
        public abstract ActionResult SendDocument(string description);
    }


    public abstract class AntiForgeryController : BaseController
    {
        protected AntiForgeryController(IUnitOfWork unitOfWork) : base(unitOfWork) { }

        protected override void OnAuthorization(AuthorizationContext filterContext)
        {
            if (filterContext.RequestContext.HttpContext.Request.HttpMethod != "POST")
                return;

            new ValidateAntiForgeryTokenAttribute().OnAuthorization(filterContext);

            base.OnAuthorization(filterContext);
        }
    }
}