using System.Web.Mvc;

namespace AzDoc.Areas.CitizenRequests
{
    public class CitizenRequestsAreaRegistration : AreaRegistration 
    {
        public override string AreaName => "CitizenRequests";

        public override void RegisterArea(AreaRegistrationContext context) 
        {
           
            context.MapRoute(
                "CitizenRequests",
                "{lang}/CitizenRequests",
                new { lang="az",controller = "Document", action = "Index" },
                constraints: new { lang = @"az|en|ru" },
                namespaces: new[] { "AzDoc.Areas.CitizenRequests.Controllers" }
            );

            context.MapRoute(
                "CitizenRequestsDefault",
                "{lang}/CitizenRequests/{controller}/{action}",
                new { lang = "az", controller = "Document", action = "Index" },
                constraints: new { lang = @"az|en|ru" },
                namespaces: new[] { "AzDoc.Areas.CitizenRequests.Controllers" }
            );

            context.MapRoute(
                "CitizenRequestsDefaultToken",
                "{lang}/CitizenRequests/{controller}/{action}/token",
                new { lang = "az", controller = "Document", action = "Index" },
                constraints: new { lang = @"az|en|ru" },
                namespaces: new[] { "AzDoc.Areas.CitizenRequests.Controllers" }
            );
        }
    }
}