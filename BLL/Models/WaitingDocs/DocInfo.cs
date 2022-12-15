using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BLL.Models.WaitingDocs
{
    public class DocInfo
    {
        public int DocId { get; set; }
        [StringLength(50)]
        public string DocEnterno { get; set; }
        [Column(TypeName = "date")]
        [DisplayFormat(DataFormatString = "d")]
        public DateTime? DocEnterdate { get; set; }
        [StringLength(50)]
        public string DocDocno { get; set; }
        [Column(TypeName = "date")]
        [DisplayFormat(DataFormatString = "d")]

        public DateTime? DocDocdate { get; set; }
        public DateTime? DocPlannedDate { get; set; }
        public string DocType { get; set; }

    }
}
