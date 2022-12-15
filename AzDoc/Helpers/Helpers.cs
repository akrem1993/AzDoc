using System;
using System.Configuration;
using System.Globalization;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;
using System.Security.Cryptography;
using System.Text;
using System.Threading;
using System.Web.Configuration;
using System.Web.Mvc;

namespace AzDoc.Helpers
{
    public static class Helper
    {
        public static readonly string FileServerPath;
        public static readonly string EdocServerPath;


        static Helper()
        {
            Configuration rootWebConfig1 = WebConfigurationManager.OpenWebConfiguration("/");
            if (rootWebConfig1.AppSettings.Settings.Count > 0)
            {
                KeyValueConfigurationElement fileServerPath = rootWebConfig1.AppSettings.Settings["FileServerPath"];
                KeyValueConfigurationElement edocServerPath = rootWebConfig1.AppSettings.Settings["EdocServerPath"];

                if (fileServerPath != null)
                {
                    FileServerPath = fileServerPath.Value;
                }

                if (edocServerPath != null)
                {
                    EdocServerPath = edocServerPath.Value;
                }
            }

        }

        #region File

        public static string GetFilePath() => $"{DateTime.Now.Year}/{SessionHelper.OrganizationId}/{DateTime.Now.Month}/{DateTime.Now.Day}";
        //Directory.CreateDirectory(string.Concat(FileServerPath, path));

        #endregion File

        private static string[] formats=
        {
            "dd.MM.yyyy HH:mm:ss",
            "dd.MM.yyyy HH:mm",
            "dd.MM.yyyy",
            "yyyy.MM.dd"
        };

        public static DateTime? ExactDateFromString(this string expression)
        {
            DateTime result;
            if (DateTime.TryParseExact(expression, Helper.formats, (IFormatProvider)Thread.CurrentThread.CurrentCulture, DateTimeStyles.None, out result))
                return new DateTime?(result);
            else
                return new DateTime?();
        }


        public static string GetToken(this ControllerBase controller)
        {
            if (!string.IsNullOrWhiteSpace(controller?.ControllerContext?.HttpContext?.Request?.QueryString["token"]))
                return controller.ControllerContext.HttpContext.Request.QueryString["token"];

            if (!string.IsNullOrWhiteSpace(controller.TempData["token"]?.ToString()))
                return controller.TempData["token"].ToString();

            return null;
        }


    }
}