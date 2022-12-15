using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using AppCore.Interfaces;

namespace AzDoc.Models.Account
{
    public class UserToken : IUserToken
    {
        public string RequestToken { get; set; }
        public int WorkPlaceId { get; set; }
        public int DocId { get; set; }
    }
}