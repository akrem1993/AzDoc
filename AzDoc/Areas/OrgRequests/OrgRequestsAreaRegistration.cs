using System.Web.Mvc;

namespace AzDoc.Areas.OrgRequests
{
    public class OrgRequestsAreaRegistration : AreaRegistration
    {
        public override string AreaName=> "OrgRequests";

        public override void RegisterArea(AreaRegistrationContext context)
        {
            context.MapRoute(
                "OrgRequests",
                "{lang}/OrgRequests",
                new { lang = "az", controller = "Document", action = "Index" },
                constraints: new { lang = @"az|en|ru" },
                namespaces: new[] { "AzDoc.Areas.OrgRequests.Controllers" }
            );

            context.MapRoute(
                "OrgRequestsDefault",
                "{lang}/OrgRequests/{controller}/{action}",
                new { lang = "az", controller = "Document", action = "Index" },
                constraints: new { lang = @"az|en|ru" },
                namespaces: new[] { "AzDoc.Areas.OrgRequests.Controllers" }
            );

            context.MapRoute(
                "OrgRequestsDefaultToken",
                "{lang}/OrgRequests/{controller}/{action}/token",
                new { lang = "az", controller = "Document", action = "Index" },
                constraints: new { lang = @"az|en|ru" },
                namespaces: new[] { "AzDoc.Areas.OrgRequests.Controllers" }
            );
        }
    }
}