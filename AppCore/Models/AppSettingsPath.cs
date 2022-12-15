using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AppCore.Interfaces;

namespace AppCore.Models
{
    public class AppSettingsPath :IServerPath
    {
        public string AppData { get; set; }
        public string UploadTemp { get; set; }
        public string QrImages { get; set; }
        public string ServerPath { get; set; }
        public string QrService { get; set; }
    }
}
