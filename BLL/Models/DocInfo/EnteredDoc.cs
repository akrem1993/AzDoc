using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BLL.Models.DocInfo
{
    public class EnteredDoc
    {
        public int DocId { get; set; }
        public string DocNo { get; set; }
        public DateTime DocDate { get; set; }
        public string DocAddress { get; set; }
        public string DocDescription { get; set; }
        public string DocResult { get; set; }
        public string DocStatus { get; set; }
        public byte IsDeleted { get; set; }

    }
}
