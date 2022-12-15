using AzDoc.Helpers;
using System;
using System.Linq;
using System.Net;
using System.Web.Mvc;

namespace AzDoc.Attributes
{
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Method)]
    public class SessionExpireFilterAttribute : ActionFilterAttribute
    {
        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            if(IsIgnored(filterContext))
            {
                base.OnActionExecuting(filterContext);
                return;
            }
            
            if(SessionHelper.WorkPlaceId == -1)
            {
                if(filterContext.HttpContext.Request.IsAjaxRequest())
                {
                    filterContext.HttpContext.Response.StatusCode = (int)HttpStatusCode.Unauthorized;
                    filterContext.Result = AjaxResult();
                }
                else
                {
                    filterContext.Result = RedirectToRoute();
                }
            }

            base.OnActionExecuting(filterContext);
        }

        private bool IsIgnored(ActionExecutingContext filterContext)
        {
            return filterContext.ActionDescriptor.
                GetCustomAttributes(typeof(IgnoreSessionExpireAttribute), false)
                .Any();
        }

        private JsonResult AjaxResult() => new JsonResult
        {
            JsonRequestBehavior = JsonRequestBehavior.AllowGet,
            Data = "Sessiyanız bitib,zəhmət olmasa səhifəni yeniləyin"//Dile gore deyiisilmelidi
        };

        private RedirectToRouteResult RedirectToRoute() => new RedirectToRouteResult(
                new System.Web.Routing.RouteValueDictionary(
                    new
                    {
                        controller = "Account",
                        action = "TimeoutRedirect",
                        area = ""
                    }
                ));
    }

    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Method)]
    public class IgnoreSessionExpireAttribute : Attribute
    {
    }
}