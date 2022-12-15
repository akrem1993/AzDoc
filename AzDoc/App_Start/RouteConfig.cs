using System.Web.Mvc;
using System.Web.Routing;

namespace AzDoc
{
    public class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");
            routes.IgnoreRoute("{resource}.ashx/{*pathInfo}");

            routes.MapRoute(
                name: "Login",
                url: "Login",
                defaults: new { controller = "Account", action = "Login" },
                namespaces: new[] { "AzDoc.Controllers" }
            );

            routes.MapRoute(
               name: "UnreadDocuments",
               url: "{lang}/UnreadDocuments",
               defaults: new { lang = "az", controller = "Document", action = "Index" },
               namespaces: new[] { "AzDoc.Controllers" },
               constraints: new { lang = @"az|en|ru" }
               );

            routes.MapRoute(
                 name: "LangSchema",
                 url: "{lang}/Position",
                 defaults: new { lang = "az", controller = "Account", action = "Schema" },
                 namespaces: new[] { "AzDoc.Controllers" },
                 constraints: new { lang = @"az|en|ru" }
                );

            routes.MapRoute(
                 name: "Schema",
                 url: "Position",
                 defaults: new { controller = "Account", action = "Schema" },
                 namespaces: new[] { "AzDoc.Controllers" }
                );

            routes.MapRoute(
                name: "LangLogin",
                url: "{lang}/Login",
                defaults: new { lang = "az", controller = "Account", action = "Login" },
                namespaces: new[] { "AzDoc.Controllers" },
                constraints: new { lang = @"az|en|ru" }
                );

            routes.MapRoute(
                name: "Logout",
                url: "Logout",
                defaults: new { controller = "Account", action = "LogOut" },
                namespaces: new[] { "AzDoc.Controllers" }
                );

            routes.MapRoute(
                name: "Defaults",
                url: "{lang}/{controller}/{action}",
                defaults: new { lang = "az", controller = "Account", action = "Login" },
                namespaces: new[] { "AzDoc.Controllers" },
                constraints: new { lang = @"az|en|ru" }
                );
        }
    }
}