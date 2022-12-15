using System;
using System.ComponentModel;
using System.Linq;
using System.Net;
using System.Web.Mvc;
using AzDoc.Helpers;
using LogHelpers;
using BLL.Common.Enums;

namespace AzDoc.Attributes
{
    [AttributeUsage(AttributeTargets.Method)]
    public class PermissionAttribute : ActionFilterAttribute
    {
        private readonly RightType right;
        private readonly DocType docType;

        public PermissionAttribute(RightType right) => this.right = right;

        public PermissionAttribute(RightType right, DocType docType) : this(right) => this.docType = docType;

        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            if (Permissions.Get(right, GetDocType(filterContext)))
            {
                base.OnActionExecuting(filterContext);
                return;
            }

            filterContext.HttpContext.Response.StatusCode = (int)HttpStatusCode.NotAcceptable;

            string controller = filterContext.ActionDescriptor.ControllerDescriptor.ControllerName;
            string action = filterContext.ActionDescriptor.ActionName;

            if (filterContext.HttpContext.Request.IsAjaxRequest())
            {
                filterContext.Result = AjaxResult();
            }
            else
            {
                filterContext.Result = ScriptContentResult(controller, action);
            }

            Log.AddInfo($"ACCESS DENIED Controller:{controller},Action:{action}");
        }

        private DocType GetDocType(ActionExecutingContext filterContext)
        {
            if (docType != DocType.None && docType != 0) return docType;

            var controllerAttrbutes = filterContext.ActionDescriptor.ControllerDescriptor.GetCustomAttributes(typeof(DocTypeMarkAttribute),
                false);
            
            if (controllerAttrbutes.Any())
            {
                return ((DocTypeMarkAttribute)controllerAttrbutes.First()).DocType;
            }

#if DEBUG
            throw new ArgumentException("Controllerde DocTypeMarkAttribute elave olunmalidi");
#endif
            return DocType.None;
        }

        private JsonResult AjaxResult() => new JsonResult
        {
            JsonRequestBehavior = JsonRequestBehavior.AllowGet,
            Data = "Bu əməliyyata icazəniz yoxdur"//Dile gore deyiisilmelidi
        };

        private ContentResult ScriptContentResult(string controller, string action) => new ContentResult
        {
            Content = "<script>" +
                          $"console.log('ACCESS DENIED Controller:{controller},Action:{action}');" +
                          "var dialog = confirm('Bu əməliyyata icazəniz yoxdur');" +
                          "if(dialog)" +
                          "{" +
                            "window.history.go(-1);" +
                          "}" +
                      "</script>"
        };



    }
}