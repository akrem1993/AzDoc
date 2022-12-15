using System.Web.Mvc;

namespace AzDoc.Areas.AdminPanel
{
    public class AdminPanelAreaRegistration : AreaRegistration 
    {
        public override string AreaName 
        {
            get 
            {
                return "AdminPanel";
            }
        }

        public override void RegisterArea(AreaRegistrationContext context) 
        {
          
            context.MapRoute(
                "AdminPanel",
                "{lang}/AdminPanel",
                new { lang = "az", controller = "Admin", action = "Index" },
                constraints: new { lang = @"az|en|ru" },
                namespaces: new[] { "AzDoc.Areas.AdminPanel.Controllers" }
            );

            context.MapRoute(
                "AdminPanel_default",
                "{lang}/AdminPanel/{controller}/{action}",
                new { lang = "az", controller = "Admin", action = "Index" },
                constraints: new { lang = @"az|en|ru" },
                namespaces: new[] { "AzDoc.Areas.AdminPanel.Controllers" }
            );


            context.MapRoute(
                "OrganizationStructure",
                "{lang}/OrganizationStructure/{controller}/{action}",
                new { lang = "az", controller = "OrganizationStructure", action = "Index" },
                constraints: new { lang = @"az|en|ru" },
                namespaces: new[] { "AzDoc.Areas.AdminPanel.Controllers" }
            );
        }
    }
}