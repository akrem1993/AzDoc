using System.Web.Mvc;

namespace AzDoc.Areas.InsDoc
{
    public class InsDocAreaRegistration : AreaRegistration
    {
        public override string AreaName => "InsDoc";

        public override void RegisterArea(AreaRegistrationContext context)
        {
            context.MapRoute(
                "InsDoc",
                "{lang}/InsDoc",
                new { lang="az", controller = "Document", action = "Index" },
                constraints: new { lang = @"az|en|ru" },
                namespaces: new[] { "AzDoc.Areas.InsDoc.Controllers" }
            );

            context.MapRoute(
                "InsDocDefault",
                "{lang}/InsDoc/{controller}/{action}",
                new { lang = "az", controller = "Document", action = "Index" },
                constraints: new { lang = @"az|en|ru" },
                namespaces: new[] { "AzDoc.Areas.InsDoc.Controllers" }
            );
        }
    }
}