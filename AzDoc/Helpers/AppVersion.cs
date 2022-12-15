using GleamTech.DocumentUltimate.AspNet.UI;
using ORM.Context;
using System;
using System.Configuration;
using System.Web;
using System.Web.Configuration;
using System.Web.Mvc;
 using GleamTech.AspNet.Mvc;

namespace AzDoc.Helpers
{
    public static class AppVersion
    {
        public static readonly string Version;
        public static readonly string AssemblyVersion;
        public static string DbSource;

        static AppVersion()
        {
            Configuration config = WebConfigurationManager.OpenWebConfiguration("/");

            var version = config.AppSettings.Settings["AppVersion"];

            AssemblyVersion = version.Value ?? "1";

            Version = Guid.NewGuid().ToString();

            DbSource = ContextProfiles.DbSource;
        }


    }


    public static class GleamTechHelper
    {
        public static IHtmlString Head;
        public static IHtmlString Js;

        static GleamTechHelper()
        {
            var viewer = new DocumentViewer();
            var webView = (WebViewPage) null;
            Head = webView.RenderHeadWithoutJs(viewer);
            Js = webView.RenderJs(viewer);
        }
    }
}