using AzDoc.App_LocalResources;
using CustomHelpers;
using System.Net;
using System.Web.Mvc;

namespace AzDoc.Attributes
{
    public class CheckSftpAttribute : ActionFilterAttribute
    {
        public override void OnActionExecuting(ActionExecutingContext actionContext)
        {
#if !DEBUG
            if (!CustomHelper.CheckSFTPServer())

            {
                actionContext.HttpContext.Response.StatusCode = (int)HttpStatusCode.ServiceUnavailable;

                actionContext.Result = AjaxResult(RLang.SftpWarning);
            }
#endif

            base.OnActionExecuting(actionContext);
        }

        private JsonResult AjaxResult(string message) => new JsonResult
        {
            JsonRequestBehavior = JsonRequestBehavior.AllowGet,
            Data = message
        };
    }
}