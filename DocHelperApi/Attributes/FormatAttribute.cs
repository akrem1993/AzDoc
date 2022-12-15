using DocHelperApi.Models.Concrete;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Formatting;
using System.Web;
using System.Web.Http;
using System.Web.Http.Controllers;
using System.Web.Http.Filters;

namespace DocHelperApi.Attributes
{
    public class FormatAttribute : ActionFilterAttribute
    {
        static List<string> formatTypeList = new List<string>() { "xml", "json" };
        public override void OnActionExecuting(HttpActionContext actionContext)
        {
            //string queryString = actionContext.Request.RequestUri.Query;
            //var queryDictionary = HttpUtility.ParseQueryString(queryString);
            //var formatTypeArray = queryDictionary.GetValues("format")?.ToList() ?? new List<string>() { "json" };
            //string formatType = formatTypeArray[0];
            string formatType = actionContext.RequestContext.RouteData.Values["format"]?.ToString() ?? "json";

            formatType = formatType.ToString().ToLower().Trim();

            if (!formatTypeList.Contains(formatType))
            {
                HttpResponseMessage response = new HttpResponseMessage();
                response.Content =
                    new ObjectContent<Response<string>>
                    (new Response<string>()
                    { Status = ResponseStatus.InputError, StatusMessage = $"'{formatType}' formatı mövcud deyil" },
                    GlobalConfiguration.Configuration.Formatters.JsonFormatter, "application/json");

                actionContext.Response = response;
            }

            if (!string.IsNullOrEmpty(formatType.ToString()))
            {
                GlobalConfiguration.Configuration.Formatters.JsonFormatter.MediaTypeMappings.Clear();
                GlobalConfiguration.Configuration.Formatters.XmlFormatter.MediaTypeMappings.Clear();

                if (formatType.ToString() == "xml")
                {
                    //actionContext.Request.Headers.Remove("Accept");
                    //actionContext.Request.Headers.Add("Accept", "text/xml");
                    var mapping = new RequestHeaderMapping("Accept", "text/html", StringComparison.InvariantCultureIgnoreCase, true, "application/xml");
                    if (!GlobalConfiguration.Configuration.Formatters.XmlFormatter.MediaTypeMappings.Any(a => a.MediaType.MediaType == "application/xml"))
                    {
                        GlobalConfiguration.Configuration.Formatters.XmlFormatter.MediaTypeMappings.Add(mapping);
                        GlobalConfiguration.Configuration.Formatters.XmlFormatter.UseXmlSerializer = true;
                    }
                }
                else
                {
                    //actionContext.Request.Headers.Remove("Accept");
                    //actionContext.Request.Headers.Add("Accept", "application/json");
                    var mapping = new RequestHeaderMapping("Accept", "text/html", StringComparison.InvariantCultureIgnoreCase, true, "application/json");
                    if (!GlobalConfiguration.Configuration.Formatters.JsonFormatter.MediaTypeMappings.Any(a => a.MediaType.MediaType == "application/json"))
                    {
                        GlobalConfiguration.Configuration.Formatters.JsonFormatter.MediaTypeMappings.Add(mapping);
                    }
                }
            }

            base.OnActionExecuting(actionContext);
        }
    }
}