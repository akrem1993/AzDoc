namespace Model.DB_Views
{
    using Model.ModelInterfaces;
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    [Table("orgrequests.DOCS")]
    public partial class OrgRequestsDocs :IRoleFilter,IOrgRequests
    {
        [Key]
        [Column(Order = 0)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int DocId { get; set; }

        [StringLength(50)]
        public string DocEnterno { get; set; }

        [Column(TypeName = "date")]
        public DateTime? DocLastExecutionDate { get; set; }

        [Key]
        [Column(Order = 1)]
        [StringLength(200)]
        public string DocumentstatusName { get; set; }

        [Column(TypeName = "date")]
        public DateTime? DocEnterdate { get; set; }

        [StringLength(50)]
        public string DocDocno { get; set; }

        public string TaskTo { get; set; }

        public string DocAuthorInfo { get; set; }

        public string Signer { get; set; }

        [StringLength(1000)]
        public string WhomAdressed { get; set; }

        [Key]
        [Column(Order = 2)]
        [StringLength(50)]
        public string DocFormName { get; set; }

        [Key]
        [Column(Order = 3)]
        [StringLength(250)]
        public string DocTopicType { get; set; }

        [Key]
        [Column(Order = 4)]
        public string TypeOfDocumentName { get; set; }

        [Column(TypeName = "date")]
        public DateTime? DocDate { get; set; }

        public string DocDescription { get; set; }

        public bool? ExecutorControlStatus { get; set; }

        [Key]
        [Column(Order = 5)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int DocOrganizationId { get; set; }

        public int? DocPeriodId { get; set; }

        public bool? ExecutorReadStatus { get; set; }

        public DateTime? DirectionInsertedDate { get; set; }

        public int? DirectionCreatorWorkplaceId { get; set; }

        [Key]
        [Column(Order = 6)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int DirectionTypeId { get; set; }

        [Key]
        [Column(Order = 7)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int ExecutorWorkplaceId { get; set; }

        public int? ExecutorOrganizationId { get; set; }

        public int? ExecutorTopDepartment { get; set; }

        public int? ExecutorDepartment { get; set; }

        public int? ExecutorSection { get; set; }

        public int? ExecutorSubsection { get; set; }

        public int? DocInsertedById { get; set; }
    }

    public interface IOrgRequests
    {

    }
}
