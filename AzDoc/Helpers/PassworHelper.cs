using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;

namespace AzDoc.Helpers
{
    public static class PassworHelper
    {
        public static bool CheckPasswordSecure(string password)
        {
            var regex = new Regex(@"^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[^a-zA-Z0-9])(?!.*\s).{8,15}$");
            var a = regex.Match(password).Success;
            return regex.Match(password).Success;
        }
    }
}