using System.Web.Mvc;

namespace AzDoc.Areas.ReserveDocs
{
    public class ReserveDocsAreaRegistration : AreaRegistration 
    {
        public override string AreaName 
        {
            get 
            {
                return "ReserveDocs";
            }
        }

        public override void RegisterArea(AreaRegistrationContext context) 
        {
            context.MapRoute(
              "ReserveDocs",
              "{lang}/ReserveDocs",
              new { lang = "az", controller = "Document", action = "Index"},
              constraints: new { lang = @"az|en|ru" },
              namespaces: new[] { "AzDoc.Areas.ReserveDocs.Controllers" }
          );

            context.MapRoute(
                "ReserveDocsDefault",
                "{lang}/ReserveDocs/{controller}/{action}",
                new { lang = "az", controller = "Document", action = "Index" },
                constraints: new { lang = @"az|en|ru" },
                namespaces: new[] { "AzDoc.Areas.ReserveDocs.Controllers" }
            );
            context.MapRoute(
               "ReserveDocsDefaultToken",
               "{lang}/ReserveDocs/{controller}/{action}/token",
               new { lang = "az", controller = "Document", action = "Index" },
               constraints: new { lang = @"az|en|ru" },
               namespaces: new[] { "AzDoc.Areas.ReserveDocs.Controllers" }
           );

        }
    }
}