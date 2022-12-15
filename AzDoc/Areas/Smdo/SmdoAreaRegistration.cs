using System.Web.Mvc;

namespace AzDoc.Areas.Smdo
{
    public class SmdoAreaRegistration : AreaRegistration
    {
        public override string AreaName => "Smdo";

        public override void RegisterArea(AreaRegistrationContext context)
        {
            context.MapRoute(
                "Smdo",
                "{lang}/Smdo/{controller}/{action}",
                new { lang = "az", controller = "Document", action = "IndexSended" }
            );
        }
    }
}