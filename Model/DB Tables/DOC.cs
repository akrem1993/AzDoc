using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using DMSModel;
using Model.Entity;

namespace Model.DB_Tables
{
    [Table("DOCS")]
    public partial class DOC : BaseEntity
    {
        public DOC()
        {
            DOCS_ADDRESSINFO = new HashSet<DOCS_ADDRESSINFO>();
            DOCS_APPLICATION = new HashSet<DOCS_APPLICATION>();
            DOCS_RELATED = new HashSet<DOCS_RELATED>();
            DOCS_DIRECTIONS = new HashSet<DOCS_DIRECTIONS>();
            DOCS_ADDITION = new HashSet<DOCS_ADDITION>();
            DOC_DUPLICATEDOCS = new HashSet<DOC>();
            DOCS_ADDITIONDATA = new HashSet<DOCS_ADDITIONDATA>();
        }

        public int DocId { get; set; }

        //public int? DocPeriodId { get; set; }

        public int DocOrganizationId { get; set; }

        //public int DocDoctypeId { get; set; }

        [Column(TypeName = "date")]
        public DateTime? DocEnterdate { get; set; }

        [StringLength(50)]
        public string DocEnterno { get; set; }

        [StringLength(50)]
        public string DocEnternop1 { get; set; }

        public int? DocEnternop2 { get; set; }

        public int? DocEnternop3 { get; set; }

        public int? DocEnternop4 { get; set; }

        public int? DocRegisterId { get; set; }

        [StringLength(50)]
        public string DocEnternoControl { get; set; }

        [StringLength(50)]
        public string DocDocno { get; set; }

        [Column(TypeName = "date")]
        public DateTime? DocDocdate { get; set; }

        public int? DocDuplicateDocId { get; set; }

        public int? DocDuplicateId { get; set; }

        public int? DocFormId { get; set; }

        public int? DocReceivedFormId { get; set; }

        [StringLength(25)]
        public string DocBarcode { get; set; }

        public int? DocPageCount { get; set; }

        public int? DocCopiesCount { get; set; }

        public int? DocAttachmentCount { get; set; }

        public int? DocAppliertypeId { get; set; }

        public byte DocUndercontrolStatusId { get; set; }

        public int? DocUndercontrolDayCount { get; set; }

        public byte DocControlStatusId { get; set; }
        public int? DocControlDayCount { get; set; }

        public int? DocDocumentstatusId { get; set; }

        public int? DocDescriptionId { get; set; }

        public string DocDescription { get; set; }

        public string DocDescriptionR { get; set; }

        public int? DocMainExecutorId { get; set; }

        public int? DocTopDepartmentId { get; set; }

        [Column(TypeName = "date")]
        public DateTime? DocPlannedDate { get; set; }

        [Column(TypeName = "date")]
        public DateTime? DocPlannedDateI { get; set; }

        [Column(TypeName = "date")]
        public DateTime? DocPlannedDateD { get; set; }

        [Column(TypeName = "date")]
        public DateTime? DocReportedDate { get; set; }

        [StringLength(500)]
        public string DocReportNote { get; set; }

        public int? DocReportedWorkplaceId { get; set; }

        [Column(TypeName = "date")]
        public DateTime? DocExecutedDate { get; set; }

        [Column(TypeName = "date")]
        public DateTime? DocProlongDate { get; set; }

        [Column(TypeName = "date")]
        public DateTime? DocSendDate { get; set; }

        [StringLength(2000)]
        public string DocControlNotes { get; set; }

        public int? DocApplytypeId { get; set; }

        public int? DocTopicId { get; set; }

        public int? DocExecutionStatusId { get; set; }

        public int? DocSendedDocumentId { get; set; }

        public int? DocRelatedNIdn { get; set; }

        public int? DocRelatedtoSendedDocumentId { get; set; }

        public int? DocSendTypeId { get; set; }

        public int? DocTemplateId { get; set; }

        public byte? DocClosed { get; set; }

        public byte? DocDeleted { get; set; }

        public int? DocDeletedById { get; set; }

        public DateTime? DocDeletedByDate { get; set; }

        public int? DocInsertedById { get; set; }

        public DateTime? DocInsertedByDate { get; set; }

        public int? DocUpdatedById { get; set; }

        public DateTime? DocUpdatedByDate { get; set; }

        public int? DocTopicType { get; set; }

        public bool DocIsAppealBoard { get; set; }

        public int? DocDocumentOldStatusId { get; set; }

        public int? DocResultId { get; set; }

        public virtual DC_ORGANIZATION DC_ORGANIZATION { get; set; }

        public virtual DOC_PERIOD DOC_PERIOD { get; set; }

        public virtual DOC_TYPE DOC_TYPE { get; set; }

        public virtual DOC_DUPLICATE DOC_DUPLICATE { get; set; }

        public virtual DOC_RESULT DOC_RESULT { get; set; }

        public virtual ICollection<DOCS_ADDRESSINFO> DOCS_ADDRESSINFO { get; set; }

        public virtual ICollection<DOCS_APPLICATION> DOCS_APPLICATION { get; set; }

        public virtual ICollection<DOCS_FILE> DOCS_FILE { get; set; }

        public virtual ICollection<DOCS_RELATED> DOCS_RELATED { get; set; }

        public virtual ICollection<DOCS_DIRECTIONS> DOCS_DIRECTIONS { get; set; }

        public virtual ICollection<DOCS_ADDITION> DOCS_ADDITION { get; set; }

        public virtual DOC DOC_DUPLICATEDOC { get; set; }

        public virtual ICollection<DOC> DOC_DUPLICATEDOCS { get; set; }

        public virtual ICollection<DOCS_ADDITIONDATA> DOCS_ADDITIONDATA { get; set; }
    }
}