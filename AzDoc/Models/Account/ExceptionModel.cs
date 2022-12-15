using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace AzDoc.Models.Account
{
    public class ExceptionModel
    {
        public string ExMessage { get; set; }
        public string TargetSite { get; set; }
        public UserToken RequestToken { get; set; }
        
    }
}