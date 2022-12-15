using System.Collections.Generic;
using System.Drawing;
using System.Text;

namespace DocFileHelper.QrCreator.Models
{
    public class QrData
    {
        public List<string> Input { get; set; }

        public string QrDocUrl {get; set; }

        public Bitmap ImageData { get; set; }

        public string ImageBase64 { get; set; }
    }
}
