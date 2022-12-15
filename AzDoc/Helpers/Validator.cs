using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Collections.Generic;

namespace AzDoc.Helpers
{
    public static class Validator
    {
        public static bool CheckString(this string val, string throwMsg)
        {
            val = val.Trim();

            if (string.IsNullOrEmpty(val) || string.IsNullOrWhiteSpace(val)) Thrower.Args(throwMsg);

            return true;
        }

        public static bool CheckBool(this bool val, string throwMsg)
        {
            if (val) Thrower.Args(throwMsg);

            return true;
        }
    }
}