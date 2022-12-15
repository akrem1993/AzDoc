using BLL.Models.DocGrid;
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace OrgRequests.Model.EntityModel
{
    public class DocumentGridModel : BaseGridModel
    {
        public int DocId { get; set; }

        [StringLength(50)]
        public string DocEnterno { get; set; }

        public DateTime? DocLastExecutionDate { get; set; }

        public int DocDocumentstatusId { get; set; }

        [Column(TypeName = "date")]
        [DisplayFormat(DataFormatString = "d")]
        public DateTime? DocEnterdate { get; set; }

        [StringLength(50)]
        public string DocDocno { get; set; }

        public string Signer { get; set; }

        public string TaskTo { get; set; }

        public string DocAuthorInfo { get; set; }

        public string WhomAdressed { get; set; }

        public int FormId { get; set; }

        public string DocTopicType { get; set; }

        public int DocTopicTypeId { get; set; }

        public int DocFormId { get; set; }

        public DateTime? DocDate { get; set; }

        [StringLength(2000)]
        public string DocDescription { get; set; }

        public string AuthorPrevOrganization { get; set; }
        public string CreaterPersonnelName { get; set; }

        public bool ExecutorControlStatus { get; set; }

        public int ExecutorId { get; set; }

        public int? ExecutionTimeout { get; set; }

    }
}