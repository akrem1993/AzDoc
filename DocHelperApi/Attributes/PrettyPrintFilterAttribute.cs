using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http.Filters;

namespace DocHelperApi.Attributes
{
    public class PrettyPrintFilterAttribute : ActionFilterAttribute
    {
        const string prettyPrintConstant = "?pretty";
        const string prettyPrintConstants = "&pretty";

        public override void OnActionExecuted(HttpActionExecutedContext actionExecutedContext)
        {
            System.Web.Http.GlobalConfiguration.Configuration.Formatters.JsonFormatter.SerializerSettings.Formatting = Newtonsoft.Json.Formatting.None;

            var querystring = actionExecutedContext.ActionContext.Request.RequestUri;
            if (!string.IsNullOrWhiteSpace(querystring.ToString()))
            {
                if (querystring.ToString().ToLower().Contains(prettyPrintConstant) || querystring.ToString().ToLower().Contains(prettyPrintConstants))
                {
                    System.Web.Http.GlobalConfiguration.Configuration.Formatters.JsonFormatter.SerializerSettings.Formatting = Newtonsoft.Json.Formatting.Indented;
                }
            }
            base.OnActionExecuted(actionExecutedContext);
        }

    }
}