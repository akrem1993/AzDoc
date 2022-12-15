using BLL.Models.DocGrid;
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace InsDoc.Model.EntityModel
{
    public class DocumentGridModel : BaseGridModel
    {
        public int DocId { get; set; }

        [StringLength(50)]
        public string DocEnterno { get; set; }

        [Column(TypeName = "date")]
        [DisplayFormat(DataFormatString = "d")]
        public DateTime? DocEnterdate { get; set; }

        [StringLength(50)]
        public string DocDocno { get; set; }

        public string Signer { get; set; }
        public string SendTo { get; set; }

        [StringLength(2000)]
        public string DocDescription { get; set; }

        public int DocDocumentstatusId { get; set; }
        public int FormId { get; set; }
        public string CreaterPersonnelName { get; set; }
        public bool? ExecutorControlStatus { get; set; }

        public int ExecutorId { get; set; }
    }
}