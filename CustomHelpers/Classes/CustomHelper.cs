using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Net.NetworkInformation;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;
using LogHelpers;

namespace CustomHelpers
{
    public static class CustomHelper
    {
        public static string Encrypt(string clearText)
        {
            string EncryptionKey = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            byte[] clearBytes = Encoding.Unicode.GetBytes(clearText);
            using (Aes encryptor = Aes.Create())
            {
                Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey, new byte[] { 0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76 });
                encryptor.Key = pdb.GetBytes(32);
                encryptor.IV = pdb.GetBytes(16);
                using (MemoryStream ms = new MemoryStream())
                {
                    using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateEncryptor(), CryptoStreamMode.Write))
                    {
                        cs.Write(clearBytes, 0, clearBytes.Length);
                        cs.Close();
                    }
                    clearText = Convert.ToBase64String(ms.ToArray());
                }
            }
            return clearText;
        }

        public static string Decrypt(string clearText)
        {
            string EncryptionKey = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            clearText = clearText.Replace(" ", "+");
            byte[] cipherBytes = Convert.FromBase64String(clearText);
            using (Aes encryptor = Aes.Create())
            {
                Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey, new byte[] {
                    0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76
                });
                encryptor.Key = pdb.GetBytes(32);
                encryptor.IV = pdb.GetBytes(16);
                using (MemoryStream ms = new MemoryStream())
                {
                    using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateDecryptor(), CryptoStreamMode.Write))
                    {
                        cs.Write(cipherBytes, 0, cipherBytes.Length);
                        cs.Close();
                    }
                    clearText = Encoding.Unicode.GetString(ms.ToArray());
                }
            }
            return clearText;
        }
        public static Type GetPropertyType<T>(string propName) where T : class
        {
            Type type = typeof(T);
            PropertyInfo pi = type.GetProperty(propName);
            return pi.PropertyType;
        }

        public static string GetDictionaryValue(object src, string key)
        {
            Dictionary<string, object> dictionary = (Dictionary<string, object>)src;
            if (dictionary.ContainsKey(key))
            {
                return dictionary[key] == null ? null : dictionary[key].ToString();
            }
            return null;
        }

        public static string GetPropValue(object src, string propName)
        {
            var prop = src.GetType().GetProperty(propName);
            if (prop != null)
            {
                var value = src.GetType().GetProperty(propName).GetValue(src, null);
                return value == null ? null : value.ToString();
            }
            return null;
        }

        public static void AddValue<T, K>(T t, K k)
        {
            foreach (var pt in t.GetType().GetProperties())
            {
                foreach (var pk in k.GetType().GetProperties())
                {
                    if (pt.Name == pk.Name)
                    {
                        pk.SetValue(k, pt.GetValue(t, null));
                    }
                }
            }
        }

        public static string RemoveHTMLTags(this string content)
        {
            var cleaned = string.Empty;
            try
            {
                StringBuilder textOnly = new StringBuilder();
                using (var reader = System.Xml.XmlReader.Create(new System.IO.StringReader("<xml>" + content + "</xml>")))
                {
                    while (reader.Read())
                    {
                        if (reader.NodeType == System.Xml.XmlNodeType.Text)
                            textOnly.Append(reader.ReadContentAsString());
                    }
                }
                cleaned = textOnly.ToString();
            }
            catch
            {
                //A tag is probably not closed. fallback to regex string clean.
                string textOnly = string.Empty;
                System.Text.RegularExpressions.Regex tagRemove = new System.Text.RegularExpressions.Regex(@"<[^>]*(>|$)");
                System.Text.RegularExpressions.Regex compressSpaces = new System.Text.RegularExpressions.Regex(@"[\s\r\n]+");
                textOnly = tagRemove.Replace(content, string.Empty);
                textOnly = compressSpaces.Replace(textOnly, " ");
                cleaned = textOnly;
            }
            cleaned = cleaned.Replace("&nbsp;", " ");
            return cleaned;
        }

        public static long GetUnixTimeSeconds(DateTime dateTime)
        {
            var dateTimeOffset = new DateTimeOffset(dateTime);
            return dateTimeOffset.ToUnixTimeSeconds();
        }

        /// <summary>
        /// SFTP serverin islek olub olmamasini yoxlamaq ucun istifade olunur
        /// </summary>
        /// <returns></returns>
        public static bool CheckSFTPServer()
        {
            try
            {
                PingReply reply = new Ping().Send(ConfigurationManager.AppSettings["SFTPHost"], 5000, new byte[32],
                    new PingOptions(64, true));

                if (reply?.Status == IPStatus.Success)
                {
                    Log.AddInfo(
                        $"Address: {reply.Address}; " +
                        $"RoundTrip time: {reply.RoundtripTime};" +
                        $"Time to live: {reply.Options.Ttl}; " +
                        $"Don't fragment: {reply.Options.DontFragment}; " +
                        $"Buffer size: {reply.Buffer.Length};",
                        "Ping Properties",
                        "CheckSFTPServer - success");

                    return true;
                }
            }
            catch (PingException ex)
            {
                Log.AddError(ex.Message, ex.Source, "CheckSFTPServer - error");
            }

            return false;
        }
    }
}