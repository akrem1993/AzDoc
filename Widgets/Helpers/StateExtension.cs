using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace Widgets.Helpers
{
    static public partial class Helper
    {
        static public T GetValue<T>(this HttpSessionStateBase state, string key)
        {
            return (T)state[key];
        }

        static public object GetValue(this HttpSessionStateBase state, string key)
        {
            return state[key];
        }

        static public void SetValue<T>(this HttpSessionStateBase state, string key, T value)
        {
            state[key] = value;
        }

        static public T GetValue<T>(this TempDataDictionary tempData, string key)
        {
            return (T)tempData[key];
        }

        static public object GetValue(this TempDataDictionary tempData, string key)
        {
            return tempData[key];
        }

        static public void SetValue<T>(this TempDataDictionary tempData, string key, T value)
        {
            tempData[key] = value;
        }

        static public bool ExistCookie(this HttpRequestBase request, string key)
        {
            return request.Cookies.AllKeys.Any(c => c.Equals(key));
        }

        static public T GetValue<T>(this HttpRequestBase request, string key)
            where T : class
        {
            try
            {
                if (request.Cookies.AllKeys.Any(c => c.Equals(key)))
                    return JsonConvert.DeserializeObject<T>(request.RequestContext.HttpContext.Server.UrlDecode(request.Cookies.Get(key).Value), DefaultJsonSerializer);
            }
            catch (Exception) { }//cookiedeki deyer conert olunmur
            return null;
        }

        static public string GetValue(this HttpRequestBase request, string key)
        {
            if (request.Cookies.AllKeys.Any(c => c.Equals(key)))
                return request.RequestContext.HttpContext.Server.UrlDecode(request.Cookies[key].Value);
            return null;
        }

        static public void SetValue<T>(this RequestContext context, string key, T value, uint expires = 7)
        {
            var response = context.HttpContext.Response;

            if (response.Cookies.AllKeys.Any(c => c.Equals(key)))
                response.Cookies.Remove(key);

            var cookie = new HttpCookie(key, context.HttpContext.Server.UrlEncode(JsonConvert.SerializeObject(value, DefaultJsonSerializer)));
            cookie.Expires = DateTime.UtcNow.AddHours(4).AddDays(expires);
            response.Cookies.Add(cookie);
        }

        static public dynamic Result(this ModelStateDictionary state)
        {
            return new
            {
                Error = true,
                Data = state.Where(m => m.Value.Errors.Count > 0).Select(m => new { m.Key, Message = m.Value.Errors.First().ErrorMessage })
                                 .ToList()
            };
        }

        public static Dictionary<string, object> ToFields(this HttpRequestBase request)
        {
            var store = new Dictionary<string, object>();

            string value, field;

            for (int i = 0; i < Convert.ToInt32(request.QueryString["fc"]); i++)
            {
                //colunName
                field = request.QueryString[$"p{i}"];

                if (string.IsNullOrWhiteSpace(field))
                    continue;

                value = request.QueryString[$"pvf{i}"];

                store.Add(field, value);
            }

            return store;
        }

        static public List<SqlParameter> ToSqlParams(this HttpRequestBase request)
        {
            var collection = new List<SqlParameter>();
            string valueTo, valueFrom, field, type, condition;

            for (int i = 0; i < Convert.ToInt32(request.QueryString["fc"]); i++)
            {
                valueTo = valueFrom = field = type = "";
                //colunName
                field = request.QueryString[$"p{i}"].ToLowerInvariant();
                condition = request.QueryString[$"pcf{i}"].ToLowerInvariant();
                type = request.QueryString[$"pt{i}"].ToLower().Replace("filter", "");

                if (string.IsNullOrWhiteSpace(field))
                    continue;

                //range end
                valueTo = request.QueryString[$"pvt{i}"];
                if (!string.IsNullOrWhiteSpace(valueTo))
                    switch (condition)
                    {
                        case "NOT_EQUAL":
                        case "NOT_NULL":
                        case "NOT_EMPTY":
                            collection.Add(CreateParameter($"@{field}To", "0", type));
                            break;
                        default:
                            collection.Add(CreateParameter($"@{field}To", valueTo, type));
                            break;
                    }
                //range start
                if (type.EndsWith("[]"))
                    valueFrom = request.QueryString[$"pvf{i}[]"];
                else
                    valueFrom = request.QueryString[$"pvf{i}"];
                if (!string.IsNullOrWhiteSpace(valueFrom))
                    switch (condition.ToUpper())
                    {
                        case "NOT_EQUAL":
                        case "NOT_NULL":
                        case "NOT_EMPTY":
                            collection.Add(CreateParameter($"@{field}{(string.IsNullOrWhiteSpace(valueTo) ? "" : "From")}", "0", type));
                            break;
                        default:
                            collection.Add(CreateParameter($"@{field}{(string.IsNullOrWhiteSpace(valueTo) ? "" : "From")}", valueFrom, type));
                            break;
                    }


            }

            return collection;
        }

        static SqlParameter CreateParameter(string name, string value, string type)
        {
            var parameter = new SqlParameter { ParameterName = name, Value = value };

            switch (type.Replace("[]", ""))
            {
                case "date":
                    parameter.SqlDbType = SqlDbType.DateTime;
                    if (DateTime.TryParseExact(value, new[] { "MM/dd/yyyy", "dd.MM.yyyy" }, CultureInfo.InvariantCulture, DateTimeStyles.None, out DateTime dt))
                        parameter.Value = dt;
                    break;
                default:
                    break;
            }
            return parameter;
        }

        static public Dictionary<string, string> ToDictionary(this HttpRequestBase request)
        {
            var collection = new Dictionary<string, string>();
            string valueTo, valueFrom, field;

            for (int i = 0; i < Convert.ToInt32(request.QueryString["fc"]); i++)
            {
                valueTo = valueFrom = field = "";
                //colunName
                field = request.QueryString[$"p{i}"];
                if (string.IsNullOrWhiteSpace(field))
                    continue;

                //range end
                valueTo = request.QueryString[$"pvt{i}"];
                if (!string.IsNullOrWhiteSpace(valueTo))
                    collection.Add($"{field}To", valueTo);

                //range start
                valueFrom = request.QueryString[$"pvf{i}"];
                if (!string.IsNullOrWhiteSpace(valueFrom))
                    collection.Add($"{field}{(string.IsNullOrWhiteSpace(valueTo) ? "" : "From")}", valueFrom);
            }

            return collection;
        }

        static public T GetValue<T>(this Dictionary<string, T> collection, string key)
        {
            if (collection.ContainsKey(key))
                return collection[key];

            return default(T);
        }
    }
}