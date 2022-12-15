using System;
using System.Security.Cryptography;
using System.Text;

namespace CustomHelpers.Classes
{
    public static class CryptoHelper
    {
        public static string Encrypt(string input)
        {
            string key = "4C87C59C0514CCF5BF8AC17518F7DD18648ECADB";
            try
            {
                var symmetricAlgorithm = new DESCryptoServiceProvider();

                byte[] numArray1 = new byte[symmetricAlgorithm.Key.Length];
                byte[] bytes = Encoding.UTF8.GetBytes(key);
                Array.Copy((Array)bytes, 0, (Array)numArray1, 0, bytes.Length > numArray1.Length ? numArray1.Length : bytes.Length);
                symmetricAlgorithm.Key = numArray1;
                symmetricAlgorithm.Padding = PaddingMode.PKCS7;
                symmetricAlgorithm.Mode = CipherMode.ECB;
                var cryptoTransform = symmetricAlgorithm.CreateEncryptor();

                byte[] inputBuffer = Encoding.UTF8.GetBytes(input);
                byte[] numArray2 = cryptoTransform.TransformFinalBlock(inputBuffer, 0, inputBuffer.Length);
                symmetricAlgorithm.Clear();
                return Convert.ToBase64String(numArray2);
            }
            catch
            {
                throw;
            }
        }

        public static string Decrypt(string input)
        {
            if (string.IsNullOrWhiteSpace(input))
                return null;
            string key = "4C87C59C0514CCF5BF8AC17518F7DD18648ECADB";
            try
            {
                var symmetricAlgorithm = new DESCryptoServiceProvider();
                byte[] numArray1 = new byte[symmetricAlgorithm.Key.Length];
                byte[] bytes = Encoding.UTF8.GetBytes(key);
                Array.Copy((Array)bytes, 0, (Array)numArray1, 0, bytes.Length > numArray1.Length ? numArray1.Length : bytes.Length);
                symmetricAlgorithm.Key = numArray1;
                symmetricAlgorithm.Padding = PaddingMode.PKCS7;
                symmetricAlgorithm.Mode = CipherMode.ECB;

                var cryptoTransform = symmetricAlgorithm.CreateDecryptor();

                byte[] inputBuffer = Convert.FromBase64String(input);
                byte[] numArray2 = cryptoTransform.TransformFinalBlock(inputBuffer, 0, inputBuffer.Length);
                symmetricAlgorithm.Clear();
                return Encoding.UTF8.GetString(numArray2);
            }
            catch
            {
                throw;
            }
        }
    }
}