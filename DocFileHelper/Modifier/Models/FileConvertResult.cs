using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DocFileHelper.Modifier.Models
{
    public class FileConvertResult
    {
        public string TempPath { get; set; }

        public string FileExtension { get; set; }

        public bool IsConverted { get; set; }
    }
}
