using System;
using NLog;
using System.Web;

namespace LogHelpers
{
    public static class Log
    {
        private static Logger log = LogManager.GetLogger("FileLogger");
        public static void AddError(string message, string description, string target)
        {
            log.Error($"" +
                        $"Uri: {GetUrl()}; " +
                        $"Message:{message}; " +
                        $"Descr: {description}; " +
                        $"Target: {target}; " +
                        $"UserWorkPlace: {GetUserWorkPlace()}; " +
                        $"UserName:{GetUserName()}; " +
                        $"IP: {GetIP()}");
        }

        public static void AddError(string message, string target)
        {
            log.Error($"" +
                      $"Uri: {GetUrl()}; " +
                      $"Message:{message}; " +
                      $"Target: {target}; " +
                      $"UserWorkPlace: {GetUserWorkPlace()}; " +
                      $"UserName:{GetUserName()}; " +
                      $"IP:{GetIP()}");
        }

        public static void AddError(string message)
        {
            log.Error($"Uri: {GetUrl()}; " +
                      $"Message:{message}; " +
                      $"UserWorkPlace: {GetUserWorkPlace()}; " +
                      $"UserName:{GetUserName()}; " +
                      $"IP:{GetIP()}");
        }

        public static void LogException(this Exception ex)
        {
            log.Error($"Uri: {GetUrl()}; " +
                      $"Message:{ex.Message}; " +
                      $"UserWorkPlace: {GetUserWorkPlace()}; " +
                      $"UserName:{GetUserName()}; " +
                      $"IP:{GetIP()}");
        }

        public static void AddInfo(string message, string description, string target)
        {
            log.Info($"" +
                     $"Uri: {GetUrl()}; " +
                     $"Message:{message}; " +
                     $"Descr: {description}; " +
                     $"Target: {target}; " +
                     $"UserWorkPlace: {GetUserWorkPlace()}; " +
                     $"UserName:{GetUserName()}; " +
                     $"IP: {GetIP()}");
        }

        public static void AddInfo(string message, string target)
        {
            log.Info($"" +
                     $"Uri: {GetUrl()}; " +
                     $"Message:{message}; " +
                     $"Target: {target}; " +
                     $" UserWorkPlace: {GetUserWorkPlace()}; " +
                     $"UserName: {GetUserName()}; " +
                     $"IP: {GetIP()}");
        }

        public static void AddInfo(string message)
        {
            log.Info($"Uri: {GetUrl()}; " +
                     $" Message:{message}; " +
                     $"UserWorkPlace: {GetUserWorkPlace()}; " +
                     $"UserName: {GetUserName()}; " +
                     $"IP: {GetIP()}");
        }

        public static void LogApplicationStart()
        {
            log.Info(
                "Application start================================================================================================>");
        }

        public static void LogApplicationEnd()
        {
            log.Info(
                "<=================================================================================================Application end");
        }

        public static string GetIP()
        {
            //string ip = HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
            string ip = HttpContext.Current.Request.UserHostAddress;

            if (string.IsNullOrEmpty(ip))
                ip = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"];

            return ip;

        }
        public static string GetUrl()
        {
            if (HttpContext.Current != null)
            {
                return HttpContext.Current.Request.Url.AbsoluteUri;
            }

            return null;
        }

        private static string GetSessionByName(string name)
        {
            if (HttpContext.Current != null && HttpContext.Current.Session != null)
            {
                return HttpContext.Current.Session[name].ToString();
            }

            return null;
        }

        private static string GetUserWorkPlace()
        {
            if (HttpContext.Current != null && HttpContext.Current.Session != null)
            {
                return HttpContext.Current.Session["WorkPlaceId"]?.ToString();
            }

            return null;
        }

        private static string GetUserName()
        {
            if (HttpContext.Current != null && HttpContext.Current.Session != null)
            {
                return HttpContext.Current.Session["UserName"]?.ToString();
            }

            return null;
        }

    }

}

