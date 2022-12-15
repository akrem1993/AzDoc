using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

namespace Widgets.Helpers
{
    static public partial class Helper
    {
        static public JsonSerializerSettings DefaultJsonSerializer
        {
            get
            {
                var serializer = new JsonSerializerSettings
                {
                    DateFormatHandling = DateFormatHandling.MicrosoftDateFormat,
                    DateTimeZoneHandling = DateTimeZoneHandling.Utc,
                    NullValueHandling = NullValueHandling.Ignore,
                    Formatting = Formatting.Indented,
                    ContractResolver = new CamelCasePropertyNamesContractResolver(),
                    Culture = new CultureInfo("en")
                };

                return serializer;
            }
        }

        public static IDictionary<string, string> ReadAttributes(this object htmlAttributes)
        {
            if (htmlAttributes == null)
                return default(IDictionary<string, string>);

            return htmlAttributes.GetType().GetProperties()
                .Select(item => new { Key = item.Name.Replace("_", "-"), Value = item.GetValue(htmlAttributes).ToString() })
                .ToList().ToDictionary(item => item.Key, item => item.Value);
        }

        public static IDictionary<string, object> ReadAttributeObjects(this object htmlAttributes)
        {
            if (htmlAttributes == null)
                return default(IDictionary<string, object>);

            return htmlAttributes.GetType().GetProperties()
                .Select(item => new { Key = item.Name.Replace("_", "-"), Value = item.GetValue(htmlAttributes) })
                .ToList().ToDictionary(item => item.Key, item => item.Value);
        }
    }
}