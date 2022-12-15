using System.Web.Mvc;

namespace AzDoc.Attributes
{
    public class TimeoutAttribute : ActionFilterAttribute
    {
        private readonly uint timeOut;
        public TimeoutAttribute(uint seconds) => timeOut = seconds;

        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            filterContext.RequestContext.HttpContext.Server.ScriptTimeout = (int)timeOut;
            base.OnActionExecuting(filterContext);
        }
    }
}