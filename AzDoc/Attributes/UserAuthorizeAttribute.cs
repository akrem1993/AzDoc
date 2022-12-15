using System.Web;
using System.Web.Mvc;
using AzDoc.Helpers;

namespace AzDoc.Attributes
{
    public class UserAuthorizeAttribute : AuthorizeAttribute
    {
        protected override bool AuthorizeCore(HttpContextBase httpContext)
        {
            if (SessionHelper.UserId != -1)
                return true;

            httpContext.Response.Redirect("~/LogOut");
            return false;
        }
    }
}