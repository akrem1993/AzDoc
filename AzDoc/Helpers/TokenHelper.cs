using AzDoc.Models.Account;
using CustomHelpers;
using System;
using System.Web;

namespace AzDoc.Helpers
{
    public static class TokenHelper
    {
        public static UserToken GetToken(this HttpRequestBase request)
        {
            var tokenString = request.QueryString["token"];

            if(string.IsNullOrEmpty(tokenString))
                return new UserToken();

            var token = CustomHelper.Decrypt(HttpUtility.UrlDecode(tokenString));

            if(token == null)
                Thrower.Args("Token is null");

            var tokenData = token.Split('-');

            if(tokenData.Length < 3)
                Thrower.Args("Token is not correct");

            var splitWorkPlaceId = Convert.ToInt32(tokenData[0]);

            if(SessionHelper.WorkPlaceId != splitWorkPlaceId)
                Thrower.NotAccept("WorkPlace check error");

            var splitDocId = Convert.ToInt32(tokenData[2]);

            return new UserToken
            {
                WorkPlaceId = splitWorkPlaceId,
                DocId = splitDocId,
                RequestToken = tokenString
            };
        }


        public static string CreateToken(int? val)
        {
            var tokenData = $"{SessionHelper.WorkPlaceId}-{DateTime.Now:dd.MM.yyyyHH:mm:ss}-{val.Value}";

            var encryptedString = CustomHelper.Encrypt(tokenData);

            return HttpUtility.UrlEncode(encryptedString);
        }

        public static string CryptValue(string val)
        {
            var cryptedString = CustomHelper.Encrypt(val);

            return HttpUtility.UrlEncode(cryptedString);
        }

        public static string EncryptValue(string val)
        {
            var encryptedString = CustomHelper.Decrypt(HttpUtility.UrlDecode(val));

            return encryptedString;
        }
    }

}