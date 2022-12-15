using System.Web.Mvc;

namespace AzDoc.Areas.OutgoingDoc
{
    public class OutgoingDocAreaRegistration : AreaRegistration
    {
        public override string AreaName => "OutgoingDoc";

        public override void RegisterArea(AreaRegistrationContext context)
        {

            context.MapRoute(
                "OutgoingDoc_WithAction",
                "{lang}/outgoing/{controller}/{action}/{doctype}",
                new { controller = "Document", action = "Index", lang = "az", docType = UrlParameter.Optional },
                constraints: new { lang = @"az|en|ru" },
                namespaces: new[] { "AzDoc.Areas.OutgoingDoc.Controllers" }
            );
            context.MapRoute(
                "OutgoingDoc_default",
                "{lang}/outgoing/{controller}/{doctype}",
                new { controller = "Document", action = "Index", lang = "az", docType = UrlParameter.Optional },
                constraints: new { lang = @"az|en|ru" },
                namespaces: new[] { "AzDoc.Areas.OutgoingDoc.Controllers" }
            );
            context.MapRoute(
               "OutgoingDoc_WithoutDocType",
               "{lang}/outgoing/{controller}/{action}",
               new { controller = "Document", action = "Index", lang = "az", docType = UrlParameter.Optional },
               constraints: new { lang = @"az|en|ru" },
               namespaces: new[] { "AzDoc.Areas.OutgoingDoc.Controllers" }
           );

            context.MapRoute(
                "OutgoingDocToken",
                "{lang}/outgoing/{controller}/{action}",
                new { controller = "Document", action = "Index", lang = "az", docType = UrlParameter.Optional },
                constraints: new { lang = @"az|en|ru" },
                namespaces: new[] { "AzDoc.Areas.OutgoingDoc.Controllers" }
            );
        }
    }
}