using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BLL.Models.DocInfo
{
    public class RelatedDoc
    {
        public int DocId { get; set; }
        public string DocNo { get; set; }
        public DateTime? Docdate { get; set; }
        public string DocAddress { get; set; }
        public string DocDescription { get; set; }
        public int DocDoctypeId { get; set; }
    }
}
