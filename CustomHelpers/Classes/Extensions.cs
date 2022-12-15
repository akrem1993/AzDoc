using CustomHelpers.Attributes;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;

namespace CustomHelpers
{
    public static partial class Extensions
    {
        /// <summary>
        /// Obyekti int'e cevirmek ucun metod
        /// </summary>
        /// <param name="value">Parse olunasi Obyekt</param>
        /// <returns></returns>
        public static int ToInt(this object value)
        {
            int res = 0;
            string _value = value.ToString().Trim();

            if (!string.IsNullOrEmpty(_value))
            {
                try
                {
                    res = int.Parse(_value);
                }
                catch
                {
                    res = Convert.ToInt32(_value);
                }
            }
            return res;
        }

        /// <summary>
        /// Obyekti duoble'ye cevirmek ucun metod
        /// </summary>
        /// <param name="value">Parse olunasi Obyect</param>
        /// <returns></returns>
        public static double ToDouble(this object value)
        {
            double RES = 0;
            string _value = value.ToString().Trim();
            if (!string.IsNullOrEmpty(_value))
            {
                try
                {
                    _value = _value.Replace(',', '.');
                    RES = double.Parse(_value, CultureInfo.InvariantCulture);
                }
                catch
                {
                    try
                    {
                        _value = _value.Replace('.', ',');
                        RES = double.Parse(_value, CultureInfo.InvariantCulture);
                    }
                    catch
                    {
                        throw;
                    }
                }
            }
            return RES;
        }

        /// <summary>
        /// Obyekti Date'ye cevirmek ucun metod
        /// </summary>
        /// <param name="value">Parse olunasi Obyect</param>
        /// <returns></returns>
        public static DateTime ToDate(this object value)
        {
            DateTime RES = DateTime.Now;

            string _value = value.ToString().Trim();

            try
            {
                RES = DateTime.Parse(_value);
            }
            catch
            {
                throw;
            }

            return RES;
        }


        public static DataTable ToDataTable<T>(this IEnumerable<T> data)
        {
            if (data is null) data = Enumerable.Empty<T>();

            PropertyDescriptorCollection properties = TypeDescriptor.GetProperties(typeof(T));

            DataTable table = new DataTable();
            foreach (PropertyDescriptor prop in properties)
            {
                if (prop.Attributes.OfType<NoUddtColumnAttribute>().Any()) continue;

                if (prop.Name == "Token") continue;

                table.Columns.Add(prop.Name, Nullable.GetUnderlyingType(prop.PropertyType) ?? prop.PropertyType);
            }
            foreach (T item in data)
            {
                DataRow row = table.NewRow();
                foreach (PropertyDescriptor prop in properties)
                {
                    if (prop.Attributes.OfType<NoUddtColumnAttribute>().Any()) continue;

                    if (prop.Name == "Token") continue;

                    row[prop.Name] = prop.GetValue(item) ?? DBNull.Value;
                }
                table.Rows.Add(row);
            }
            return table;
        }
        public static DateTime AddTime(this DateTime dateTime)
        {
            DateTime curretDateTime = DateTime.Now;
            return dateTime.AddHours(curretDateTime.Hour).AddMinutes(curretDateTime.Minute).AddSeconds(curretDateTime.Second);
        }

        /// <summary>
        /// Kamran -- SQl Injectionlarin teyin edilmesi
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static bool IsVulnerable(this string value)
        {
            value = value.ClearWithRegex(@"(--.*)", "/*$1*/").ClearWithRegex(@"(\r\n|\r|\n)", " ");

            if (Regex.IsMatch(value, @"((ALTER|CREATE|UNIQUE|DROP|TRUNCATE|ADD|delete|from|\sto\s|\sor\s|\sand\s|backup|RECOVERY|replace|VIEW|EXEC|sp_sqlexec|sp_executesql)*((TABLE|VIEW|PROCEDURE|PROC|FUNCTION|DATABASE|INDEX|COLUMN|DIFFERENTIAL|RECOVERY|EXISTS|CONSTRAINT|delete|\sto\s|backup|default)*.[^;]*(go|\)|;)*))"))
                return true;

            return false;
        }

        static string ClearWithRegex(this string value, string pattern, string replacement)
        {
            return Regex.Replace(value, pattern, replacement, RegexOptions.IgnoreCase);
        }

        public static IEnumerable<TSource> DistinctBy<TSource, TKey>
    (this IEnumerable<TSource> source, Func<TSource, TKey> keySelector)
        {
            HashSet<TKey> seenKeys = new HashSet<TKey>();
            foreach(TSource element in source)
            {
                if(seenKeys.Add(keySelector(element)))
                {
                    yield return element;
                }
            }
        }
    }
}