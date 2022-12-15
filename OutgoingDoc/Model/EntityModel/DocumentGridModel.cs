using BLL.Models.DocGrid;
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace OutgoingDoc.Model.EntityModel
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

        public string DocumentstatusName { get; set; }
        public int? FormId { get; set; }  
        public string WhomAdressed { get; set; }
        public string WhomAdressedCompany { get; set; }

        public DateTime? DocDate { get; set; }
        public int? DocFormId { get; set; }
        public string CreaterPersonnelName { get; set; }

        public bool? ExecutorControlStatus { get; set; }

        public int ExecutorId { get; set; }
    }
}
