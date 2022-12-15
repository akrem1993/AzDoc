using AzDoc.Models.Binders;
using System;
using System.IO;
using System.Text.RegularExpressions;
using System.Web.Mvc;
using AzDoc.Helpers;

namespace AzDoc.App_Start
{
    public class ModelBinderConfig
    {
        internal static void Configure(System.Web.Mvc.ModelBinderDictionary binders)
        {
            binders.Add(typeof(bool), new BooleanBinder());
            binders.Add(typeof(bool?), new BooleanBinder());
            binders.Add(typeof(DateInterval), (IModelBinder)new DateIntervalBinder());
        }
    }

    public class DateIntervalBinder : IModelBinder
    {
        public object BindModel(ControllerContext controllerContext, ModelBindingContext bindingContext)
        {
            ValueProviderResult valueProviderResult = bindingContext.ValueProvider.GetValue(bindingContext.ModelName);
            if (valueProviderResult != null)
                return (object)new DateInterval(valueProviderResult.AttemptedValue);
            else
                return (object)new DateInterval(new StreamReader(controllerContext.HttpContext.Request.InputStream).ReadToEnd());
        }
    }

    public class DateInterval
    {
        private const string formatPattern = "(?<start>\\d{2}.\\d{2}.\\d{4})(\\s?-\\s?(?<end>\\d{2}.\\d{2}.\\d{4}))?";

        public DateTime? Start { get; set; }

        public DateTime? End { get; set; }

        public DateInterval()
        {
        }

        public DateInterval(string interval)
        {
            Match match = Regex.Match(interval, formatPattern);
            if (!match.Success)
                return;
            this.Start = Helper.ExactDateFromString(match.Groups["start"].Value);
            this.End = Helper.ExactDateFromString(match.Groups["end"].Value);
        }

        public override string ToString()
        {
            if (!this.Start.HasValue)
                return "";
            if (this.End.HasValue)
                return string.Format("{0:dd.MM.yyyy} - {1:dd.MM.yyyy}", (object)this.Start.Value, (object)this.End.Value);
            else
                return string.Format("{0:dd.MM.yyyy}", (object)this.Start.Value);
        }
    }
}