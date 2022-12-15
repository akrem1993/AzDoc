using AzDoc.Attributes;
using System.Web.Mvc;
using System.Web.SessionState;

namespace AzDoc
{
    public class FilterConfig
    {
        public static void RegisterGlobalFilters(GlobalFilterCollection filters)
        {
//#if !DEBUG
//            filters.Add(new RequireHttpsAttribute());
//#endif
            filters.Add(new SessionExpireFilterAttribute(),int.MinValue);
            filters.Add(new LocalizationAttribute("az"));
            filters.Add(new ExceptionFilterAttribute());
            filters.Add(new LogActionAttribute());
        }
    }
} 