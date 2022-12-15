using BLL.Models.DocGrid;
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace BLL.Models.Document.EntityModel
{
    public class DocumentGridModel : BaseGridModel
    {
        public int DocId { get; set; }

        public int DocDoctypeId { get; set; }
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
        public string Signer { get; set; }
        public string DocAuthorInfo { get; set; }
        public string WhomFromInfo { get; set; }
        public string SendTo { get; set; }
        public string EntryFromWhere { get; set; }
        public string ExecuteRule { get; set; }
        public string ReceivedFormName { get; set; }

        [StringLength(2000)]
        public string DocDescription { get; set; }

        public string DocumentstatusName { get; set; }
        public string CreaterPersonnelName { get; set; }
        public bool? ExecutorControlStatus { get; set; }
        public int ExecutorId { get; set; }

        public int? ExecutionTimeout { get; set; }
    }
}
