using AzDoc.Helpers;
using AzDoc.Models.Account;
using LogHelpers;
using Model.Models.Log;
using System;
using System.Net;
using System.Web.Mvc;

namespace AzDoc.Attributes
{
    [AttributeUsage(AttributeTargets.Class)]
    public class ExceptionFilterAttribute : HandleErrorAttribute
    {
        public override void OnException(ExceptionContext filterContext)
        {
            var exception = filterContext.Exception;

            if (filterContext.HttpContext.Request.IsAjaxRequest() && exception != null)
            {
                filterContext.HttpContext.Response.StatusCode = (int)GetExceptionCode(exception);

                filterContext.Result = AjaxResult(exception.InnerException?.Message ?? exception.Message);
                filterContext.ExceptionHandled = true;
                filterContext.HttpContext.Response.TrySkipIisCustomErrors = true;
            }
            else base.OnException(filterContext);

            var exModel = GetExceptionModel(filterContext);

            Log.AddError(exModel.ExMessage, exModel.TargetSite);

            LogHelper.DbLog(new LogModel
            {
                ActionName = exception?.StackTrace,
                ControllerName = exModel.TargetSite,
                DocId = exModel.RequestToken.DocId.ToString(),
                Url = Log.GetUrl(),
                Message = exModel.ExMessage,
                LogType = "ERROR",
                UserIp = Log.GetIP(),
                UserName = SessionHelper.UserName,
                WorkPlace = exModel.RequestToken.WorkPlaceId.ToString()
            });
        }

        private ExceptionModel GetExceptionModel(ExceptionContext context)
        {
            var token = context.RequestContext.HttpContext.Request.GetToken();
            var exception = context.Exception;

            return new ExceptionModel
            {
                ExMessage = exception?.InnerException?.Message + "====>" + exception?.StackTrace,
                TargetSite = exception?.TargetSite.ToString(),
                RequestToken=token
            };
        }

        private HttpStatusCode GetExceptionCode(Exception ex)
        {
            HttpStatusCode statusCode = HttpStatusCode.InternalServerError;

            switch (ex)
            {
                case UnauthorizedAccessException _:
                    statusCode = HttpStatusCode.NotAcceptable;
                    break;

                case ArgumentException _:
                    statusCode = HttpStatusCode.BadRequest;
                    break;
            }

            return statusCode;
        }

        private JsonResult AjaxResult(string message) => new JsonResult
        {
            JsonRequestBehavior = JsonRequestBehavior.AllowGet,
            Data = message
        };
    }

}