using System.Configuration;
using System.Web.Hosting;
using System.Web.Http;
using System.Web.Mvc;
using AppCore.Models;

namespace DocHelperApi.Controllers
{
    public class BaseApiController : ApiController
    {
        protected readonly AppSettingsPath _appSettingPath;

        public BaseApiController()
        {
            _appSettingPath = new AppSettingsPath
            {
                AppData = HostingEnvironment.MapPath(@"~/App_Data"),
                UploadTemp = HostingEnvironment.MapPath(@"~/App_Data/UploadTemp"),
                ServerPath = HostingEnvironment.MapPath(@"~/"),
                QrService = ConfigurationManager.AppSettings["QrService"]
            };
        }
    }
}