using Model.Entity;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DMSModel
{
    public partial class VW_DOCUMENTS : BaseEntity
    {
        public VW_DOCUMENTS()
        {
            DOCS_DIRECTIONS = new HashSet<DOCS_DIRECTIONS>();
            DOCS_ADDRESSINFO = new HashSet<DOCS_ADDRESSINFO>();
            DOCS_APPLICATION = new HashSet<DOCS_APPLICATION>();
            DOCS_READSTATUS = new HashSet<DOCS_READSTATUS>();
        }

        public int? ReadStatus { get; set; }

        public string Executor { get; set; }

        public string Signer { get; set; }

        public string SendTo { get; set; }

        public string OrganizationWithAuthor { get; set; }
        public string Organization { get; set; }
        public string Author { get; set; }

        public string ReceivedFormName { get; set; }

        public string TopicTypeName { get; set; }

        public string TopicName { get; set; }

        public string DocFormName { get; set; }

        public string DocumentstatusName { get; set; }
        public string ExecutionstatusName { get; set; }

        [Key]
        [Column(Order = 0)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int DocId { get; set; }

        public int? DocPeriodId { get; set; }

        [Column(Order = 1)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int DocDoctypeId { get; set; }

        [Column(TypeName = "date")]
        [DisplayFormat(DataFormatString = "d")]
        public DateTime? DocEnterdate { get; set; }

        [StringLength(50)]
        public string DocEnterno { get; set; }

        [StringLength(50)]
        public string DocEnternop1 { get; set; }

        public int? DocEnternop2 { get; set; }

        public int DocOrganizationId { get; set; }

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

        public int? DocPageCount { get; set; }

        public int? DocCopiesCount { get; set; }

        public int? DocAttachmentCount { get; set; }

        public int? DocAppliertypeId { get; set; }

        [Column(Order = 2)]
        public byte DocUndercontrolStatusId { get; set; }

        public int? DocUndercontrolDayCount { get; set; }

        [Column(Order = 3)]
        public byte DocControlStatusId { get; set; }

        public int DocDocumentstatusId { get; set; }

        [StringLength(2000)]
        public string DocDescription { get; set; }

        public int? DocTopDepartmentId { get; set; }

        [Column(TypeName = "date")]
        public DateTime? DocPlannedDate { get; set; }

        [Column(TypeName = "date")]
        public DateTime? DocReportedDate { get; set; }

        [Column(TypeName = "date")]
        public DateTime? DocExecutedDate { get; set; }

        [Column(TypeName = "date")]
        public DateTime? DocProlongDate { get; set; }

        [Column(TypeName = "date")]
        public DateTime? DocSendDate { get; set; }

        [StringLength(2000)]
        public string DocControlNotes { get; set; }

        public string DocumentInfo { get; set; }

        public string ApplicantName { get; set; }

        public string OperatorName { get; set; }

        public string SendType { get; set; }

        public string SendTypePerson { get; set; }

        public long? DirectionUnixTime { get; set; }

        public int? DocApplytypeId { get; set; }

        public string ApplytypeName { get; set; }

        public int? DocTopicId { get; set; }

        public int? DocExecutionStatusId { get; set; }

        public int? DocSendedDocumentId { get; set; }

        public int? DocSendTypeId { get; set; }

        public byte? DocClosed { get; set; }

        public byte? DocDeleted { get; set; }

        public int? DocInsertedById { get; set; }

        public DateTime? DocInsertedByDate { get; set; }

        public string ApplicantAddress { get; set; }

        public string SendStatus { get; set; }

        public double? Field1 { get; set; }

        public double? Field2 { get; set; }

        public double? Field3 { get; set; }

        public double? Field4 { get; set; }

        public double? Field5 { get; set; }

        public string Field6 { get; set; }

        public string Field7 { get; set; }

        public string Field8 { get; set; }

        public string Field9 { get; set; }

        public string Field10 { get; set; }

        public DateTime? Field11 { get; set; }

        public DateTime? Field12 { get; set; }

        public DateTime? Field13 { get; set; }

        public DateTime? Field14 { get; set; }

        public DateTime? Field15 { get; set; }

        public bool? Field16 { get; set; }

        public bool? Field17 { get; set; }

        public virtual ICollection<DOCS_DIRECTIONS> DOCS_DIRECTIONS { get; set; }

        public virtual ICollection<DOCS_ADDRESSINFO> DOCS_ADDRESSINFO { get; set; }

        public virtual ICollection<DOCS_READSTATUS> DOCS_READSTATUS { get; set; }

        public virtual ICollection<DOCS_APPLICATION> DOCS_APPLICATION { get; set; }
    }
}