using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BLL.Models.DocGrid
{
    public class BaseGridModel
    {
        public string DocConfirmer { get; set; }

        public string DocLastOperationStatus { get; set; }

        public string DocLastOperationPerson { get; set; }

        public string FileText { get; set; }
    }
}
