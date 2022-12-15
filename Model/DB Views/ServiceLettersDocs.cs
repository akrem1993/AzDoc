namespace Model.DB_Views
{
    using Model.ModelInterfaces;
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    [Table("serviceletters.DOCS")]
    public class ServiceLettersDocs : IRoleFilter,IServiceLetter
    {
        [Key]
        [Column(Order = 0)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int DocId { get; set; }

        [StringLength(50)]
        public string DocEnterno { get; set; }

        [Key]
        [Column(Order = 1)]
        [StringLength(200)]
        public string DocumentstatusName { get; set; }

        [Column(TypeName = "date")]
        public DateTime? DocEnterdate { get; set; }

        [Column(TypeName = "date")]
        public DateTime? DocPlannedDate { get; set; }

        [StringLength(1000)]
        public string Signer { get; set; }

        [Key]
        [Column(Order = 2)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int DocOrganizationId { get; set; }

        public int? DocPeriodId { get; set; }

        public bool? ExecutorReadStatus { get; set; }

        public DateTime? DirectionInsertedDate { get; set; }

        public string SendTo { get; set; }

        public string DocDescription { get; set; }

        public bool? ExecutorControlStatus { get; set; }

        public int? DirectionCreatorWorkplaceId { get; set; }

        [Key]
        [Column(Order = 3)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int DirectionTypeId { get; set; }

        [Key]
        [Column(Order = 4)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int ExecutorWorkplaceId { get; set; }


        public int? ExecutorOrganizationId { get; set; }
        public int? ExecutorTopDepartment { get; set; }
        public int? ExecutorDepartment { get; set; }
        public int? ExecutorSection { get; set; }
        public int? ExecutorSubsection { get; set; }
        public int? DocInsertedById { get; set; }
    }

    public interface IServiceLetter
    {

    }    
}
