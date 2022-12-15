using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ServiceLetters.Model.EntityModel
{
    public class DocumentGridModel
    {
        public int DocId { get; set; }

        [StringLength(50)]
        public string DocEnterno { get; set; }

        [Column(TypeName = "date")]
        [DisplayFormat(DataFormatString = "d")]
        public DateTime? DocEnterdate { get; set; }

        public DateTime? DocPlannedDate { get; set; }
        public string Signer { get; set; }
        public string SendTo { get; set; }

        [StringLength(2000)]
        public string DocDescription { get; set; }

        public int DocDocumentstatusId { get; set; }
        public bool ExecutorControlStatus { get; set; }

    }
}