using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;

namespace DocFileHelper.Base64Service
{
    public static class Base64
    {
        public static string ToBase64(this Image img)
        {
            using (MemoryStream m = new MemoryStream())
            {
                img.Save(m, ImageFormat.Jpeg);
                byte[] imageBytes = m.ToArray();
                string base64String = Convert.ToBase64String(imageBytes);
                return base64String;
            }
        }
    }
}
