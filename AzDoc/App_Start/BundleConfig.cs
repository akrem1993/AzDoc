using System.Web.Optimization;

namespace AzDoc
{
    public class BundleConfig
    {
        // For more information on bundling, visit https://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.Add(new StyleBundle("~/bundles/css/bootstrap").Include(
               "~/Content/bootstrap/bootstrap.min.css"));

            bundles.Add(new StyleBundle("~/Content/fontawesome").Include(
                "~/Content/fontawesome/css/all.min.css").Include(
                "~/Content/fontawesome/css/v4-shims.min.css"));

            bundles.Add(new StyleBundle("~/bundles/css/toastr").Include(
                "~/Content/toastr/toastr.min.css"));

            bundles.Add(new StyleBundle("~/bundles/css/jquery-ui").Include(
                "~/Content/jquery-ui/jquery-ui.min.css"));

            bundles.Add(new StyleBundle("~/bundles/css/bootstrap-select").Include(
                "~/Content/bootstrap-select/bootstrap-select.min.css"));

            bundles.Add(new StyleBundle("~/bundles/css/grid").Include(
                "~/Content/widgets/jqx.dms.css"));

            bundles.Add(new StyleBundle("~/bundles/css/jquery-selectize").Include(
                "~/Content/jquery-ui/jquery-selectize.css"));

            bundles.Add(new ScriptBundle("~/bundles/js/jquery").Include(
                        "~/Scripts/jquery/jquery-{version}.js").Include(
                "~/Scripts/jquery/jquery-blockUI.js"));

            bundles.Add(new ScriptBundle("~/bundles/js/jquery-ui").Include(
                "~/Scripts/jquery-ui/jquery-ui.min.js"));

            bundles.Add(new ScriptBundle("~/bundles/js/jqueryval").Include(
                        "~/Scripts/jquery-validate/jquery.validate.min.js"));

            // Use the development version of Modernizr to develop with and learn from. Then, when you're
            // ready for production, use the build tool at https://modernizr.com to pick only the tests you need.
            bundles.Add(new ScriptBundle("~/bundles/js/modernizr").Include(
                        "~/Scripts/modernizr/modernizr-{version}.min.js"));

            bundles.Add(new ScriptBundle("~/bundles/js/bootstrap").Include(
                      "~/Scripts/bootstrap/bootstrap.min.js"));

            bundles.Add(new ScriptBundle("~/bundles/js/popper").Include(
                "~/Scripts/popper/popper.min.js"));

            bundles.Add(new ScriptBundle("~/bundles/js/toastr").Include(
                "~/Scripts/toastr/toastr.min.js"));

            bundles.Add(new ScriptBundle("~/bundles/js/bootstrap-select").Include(
                "~/Scripts/bootstrap-select/bootstrap-select.min.js"));

            bundles.Add(new ScriptBundle("~/bundles/js/grid").Include(
                "~/Scripts/widgets/jqxmin.min.js"));

            bundles.Add(new ScriptBundle("~/bundles/js/jquery-selectize").Include(
                "~/Scripts/widgets/jquery-selectize.js"));
        }
    }
}