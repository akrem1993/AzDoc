using System.Web.Mvc;

namespace AzDoc.Areas.Journal
{
    public class JournalAreaRegistration : AreaRegistration
    {
        public override string AreaName => "Journal";
        public override void RegisterArea(AreaRegistrationContext context) 
        {
            context.MapRoute(
                "Journal_default",
                "{lang}/Journal/{controller}/{action}",
                new { controller = "Document", action = "Index", lang = "az", docType = UrlParameter.Optional },
                constraints: new { lang = @"az|en|ru" },
                namespaces: new[] { "AzDoc.Areas.Journal.Controllers" }
            );
        }
    }
}