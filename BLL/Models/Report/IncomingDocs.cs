using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BLL.Models.Report
{
    public class IncomingDocs
    {
        public int IncomingDocid { get; set; }
        public string IncomingDocNumber { get; set; }
        public DateTime? IncomingDocDate { get; set; }
    }
}
