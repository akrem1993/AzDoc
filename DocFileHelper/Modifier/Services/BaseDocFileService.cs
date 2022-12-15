using AppCore.Interfaces;
using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;

namespace DocFileHelper.Modifier.Services
{
    public class BaseDocFileService
    {
        protected readonly IServerPath ServerPath;
        protected string ImageLocation;
        protected readonly string FileLocation;
        protected const string QrImagesPath = "DocQrImages";
        protected const string ImageExt = ".jpg";

        protected BaseDocFileService(IServerPath serverPath, string filePath)
        {
            ServerPath = serverPath;
            FileLocation = filePath;
        }

        protected string SaveImage(Image img)
        {
            ImageLocation = $@"{ServerPath.QrImages}\{Guid.NewGuid()}{ImageExt}";

            Directory.CreateDirectory(ServerPath.QrImages);

            var encoder = ImageCodecInfo.GetImageEncoders().First(c => c.FormatID == ImageFormat.Jpeg.Guid);

            var encParams = new EncoderParameters(1)
            {
                Param = { [0] = new EncoderParameter(Encoder.Quality, 50L) }
            };

            img.Save(ImageLocation, encoder, encParams);

            return ImageLocation;
        }

    }
}
