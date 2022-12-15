using System.Web.Mvc;

namespace AzDoc.Areas.ServiceLetters
{
    public class ServiceLettersAreaRegistration : AreaRegistration
    {
        public override string AreaName => "ServiceLetters";

        public override void RegisterArea(AreaRegistrationContext context)
        {
            context.MapRoute(
                "ServiceLetters",
                "{lang}/ServiceLetters",
                new { lang = "az", controller = "Document", action = "Index" },
                constraints: new { lang = @"az|en|ru" },
                namespaces: new[] { "AzDoc.Areas.ServiceLetters.Controllers" }
            );

            context.MapRoute(
                "ServiceLettersDefault",
                "{lang}/ServiceLetters/{controller}/{action}",
                new { lang = "az", controller = "Document", action = "Index" },
                constraints: new { lang = @"az|en|ru" },
                namespaces: new[] { "AzDoc.Areas.ServiceLetters.Controllers" }
            );

            context.MapRoute(
                "ServiceLettersDefaultToken",
                "{lang}/ServiceLetters/{controller}/{action}/token",
                new { lang = "az", controller = "Document", action = "Index" },
                constraints: new { lang = @"az|en|ru" },
                namespaces: new[] { "AzDoc.Areas.ServiceLetters.Controllers" }
            );
        }
    }
}