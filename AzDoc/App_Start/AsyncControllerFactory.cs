using System;
using System.Web.Mvc;
using System.Web.Routing;
using System.Web.SessionState;

namespace AzDoc
{
    public class AsyncControllerFactory : DefaultControllerFactory
    {
        protected override SessionStateBehavior GetControllerSessionBehavior(RequestContext requestContext, Type controllerType)
        {
            var actionName = requestContext.RouteData.Values["action"].ToString();

            if (requestContext.HttpContext.Request.HttpMethod == "POST" && actionName == "Document")
            {
                return SessionStateBehavior.ReadOnly;
            }

            return base.GetControllerSessionBehavior(requestContext, controllerType);
        }
    }
}