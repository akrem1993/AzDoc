using AppCore.Interfaces;
using System.Configuration;
using System.Web;

namespace AzDoc.Models.Application
{
    public class ServerPathHandler : IServerPath
    {
        public ServerPathHandler()
        {
            AppData = HttpContext.Current.Server.MapPath("//App_Data//");
            UploadTemp = HttpContext.Current.Server.MapPath("//App_Data//UploadTemp//");
            QrImages = HttpContext.Current.Server.MapPath("//App_Data//DocQrImages//");
            ServerPath = HttpContext.Current.Server.MapPath("//");
            QrService = ConfigurationManager.AppSettings.Get("QrService");
        }

        public string AppData { get; set; }// => HttpContext.Current.Server.MapPath("//App_Data//");
        public string UploadTemp { get; set; }//=> HttpContext.Current.Server.MapPath("//App_Data//UploadTemp//");
        public string QrImages { get; set; }//=> HttpContext.Current.Server.MapPath("//App_Data//DocQrImages//");
        public string ServerPath { get; set; }//=> HttpContext.Current.Server.MapPath("//");
        public string QrService { get; set; }//=> ConfigurationManager.AppSettings.Get("QrService");
    }
}