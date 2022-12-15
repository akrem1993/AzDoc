using System.Linq;
using System.Text;
using System.Web.Mvc;
using AzDoc.Helpers;
using LogHelpers;
using Model.Models.Log;

namespace AzDoc.Attributes
{
    public class LogActionAttribute : ActionFilterAttribute
    {
        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            var token = filterContext.RequestContext.HttpContext.Request.GetToken();

            LogModel log = new LogModel
            {
                ActionName = filterContext.ActionDescriptor.ActionName,
                ControllerName = filterContext.ActionDescriptor.ControllerDescriptor.ControllerName,
                Parameters = filterContext.ActionParameters,
                RequestData = GetRequestString(filterContext),
                DocId = string.IsNullOrWhiteSpace(token.DocId.ToString()) ? SessionHelper.CurrentDocId.ToString() : token.DocId.ToString(),
                Url = Log.GetUrl(),
                Message = "INFO",
                LogType = "INFO",
                UserIp = Log.GetIP(),
                UserName = SessionHelper.UserName,
                WorkPlace = string.IsNullOrWhiteSpace(token.WorkPlaceId.ToString()) ? SessionHelper.WorkPlaceId.ToString() : token.WorkPlaceId.ToString()
            };

            LogData(log);

            //if (DmsSecurity.IsVulnerable(log.RequestData))
            //{
            //    filterContext.HttpContext.Response.StatusCode = (int)HttpStatusCode.BadRequest;
            //    string ms = "Bextinizi bir daha sinayin ;)";

            //    if (filterContext.HttpContext.Request.IsAjaxRequest())
            //    {
            //        filterContext.Result = AjaxResult(ms);
            //    }
            //    else
            //    {
            //        filterContext.Result = new ContentResult { Content = ms };
            //    }
            //}

            base.OnActionExecuting(filterContext);
        }

        private string GetRequestString(ActionExecutingContext filterContext)
        {
            var stream = filterContext.HttpContext.Request.InputStream;
            var data = new byte[stream.Length];
            stream.Read(data, 0, data.Length);
            return Encoding.UTF8.GetString(data);
        }

        private void LogData(LogModel model)
        {
            StringBuilder builder = new StringBuilder();
            builder.Append($"Controller:{model.ControllerName},Action:{model.ActionName}.");
            if (model.Parameters.Count > 0)
            {
                StringBuilder paramBuilder = new StringBuilder();
                model.Parameters.ToList().ForEach(x => paramBuilder.Append($"{x.Key}:{x.Value},"));
                builder.Append($"Parameters=>{paramBuilder}");
                model.RequestParams = paramBuilder.ToString();
            }

            builder.Append($".DocId:{SessionHelper.CurrentDocId}");

            LogAll(model, builder.ToString());
        }

        private void LogAll(LogModel log, string message)
        {
            Log.AddInfo(message);
            LogHelper.DbLog(log);
        }

        private JsonResult AjaxResult(string message) => new JsonResult
        {
            JsonRequestBehavior = JsonRequestBehavior.AllowGet,
            Data = message
        };
    }
}