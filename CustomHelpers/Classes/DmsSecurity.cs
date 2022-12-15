using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace CustomHelpers.Classes
{
    public static class DmsSecurity
    {

        public static bool IsVulnerable(this string value)
        {
            //value = value.ClearWithRegex(@"(--.*)", "/*$1*/").ClearWithRegex(@"(\r\n|\r|\n)", " ");

            if (Regex.IsMatch(value.ToLower(), @"((alter|create|UNIQUE|DROP|TRUNCATE|ADD|delete|backup|RECOVERY|replace|VIEW|EXEC|sp_sqlexec|sp_executesql)+(\s+)?((table|VIEW|PROCEDURE|PROC|FUNCTION|DATABASE|INDEX|COLUMN|DIFFERENTIAL|RECOVERY|EXISTS|CONSTRAINT|from|backup|default)+(\s+)?(go|\)|;)*))".ToLower()))
                return true;

            return false;
        }

        /// <summary>
        /// Sql Injection Temizleyici   / Kamran A-eff
        /// </summary>
        /// <param name="value">Vulnerable Text</param>
        /// <returns></returns>
        public static string ClearAsSafe(this string value)
        {
            value = value.ClearWithRegex(@"(--.*)", "/*$1*/ ").ClearWithRegex(@"(\r\n|\r|\n)", " ")
                .ClearWithRegex(
                    @"((ALTER|CREATE|UNIQUE|DROP|TRUNCATE|ADD|delete|from|\sto\s|\sor\s|\sand\s|backup|RECOVERY|replace|VIEW|EXEC|sp_sqlexec|sp_executesql)*((TABLE|VIEW|PROCEDURE|PROC|FUNCTION|DATABASE|INDEX|COLUMN|DIFFERENTIAL|RECOVERY|EXISTS|CONSTRAINT|delete|\sto\s|backup|default)*.[^;]*(go|\)|;)*))",
                    $@"/*$1*/{Environment.NewLine}")
                .ClearWithRegex(@"\/\*(\s?SELECT.*)\*\/", "$1");
            return value;
        }

        static string ClearWithRegex(this string value, string pattern, string replacement)
        {
            return Regex.Replace(value, pattern, replacement, RegexOptions.IgnoreCase);
        }
    }
}
