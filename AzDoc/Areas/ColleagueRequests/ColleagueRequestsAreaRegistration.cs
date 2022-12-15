using System.Web.Mvc;

namespace AzDoc.Areas.ColleagueRequests
{
    public class ColleagueRequestsAreaRegistration : AreaRegistration 
    {
        public override string AreaName => "ColleagueRequests";

        public override void RegisterArea(AreaRegistrationContext context) 
        {
           
            context.MapRoute(
                "ColleagueRequests",
                "{lang}/ColleagueRequests",
                new { lang="az",controller = "Document", action = "Index" },
                constraints: new { lang = @"az|en|ru" },
                namespaces: new[] { "AzDoc.Areas.ColleagueRequests.Controllers" }
            );

            context.MapRoute(
                "ColleagueRequestsDefault",
                "{lang}/ColleagueRequests/{controller}/{action}",
                new { lang = "az", controller = "Document", action = "Index" },
                constraints: new { lang = @"az|en|ru" },
                namespaces: new[] { "AzDoc.Areas.ColleagueRequests.Controllers" }
            );

            context.MapRoute(
                "ColleagueRequestsDefaultToken",
                "{lang}/ColleagueRequests/{controller}/{action}/token",
                new { lang = "az", controller = "Document", action = "Index" },
                constraints: new { lang = @"az|en|ru" },
                namespaces: new[] { "AzDoc.Areas.ColleagueRequests.Controllers" }
            );
        }
    }
}