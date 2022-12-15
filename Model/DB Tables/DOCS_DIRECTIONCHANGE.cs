namespace DMSModel
{
    using Model.Entity;
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public partial class DOCS_DIRECTIONCHANGE : BaseEntity
    {
        [Key]
        public int DirectionChangeId { get; set; }

        public int DirectionId { get; set; }

        public int DocId { get; set; }

        public int? OldExecutorWorkplaceId { get; set; }

        public int? NewExecutorWorkplaceId { get; set; }

        [Column(TypeName = "date")]
        public DateTime? OldDirectionPlannedDate { get; set; }

        [Column(TypeName = "date")]
        public DateTime? NewDirectionPlannedDate { get; set; }

        public string DirectionChangeNote { get; set; }

        public DateTime? DirectionChangeInsertDate { get; set; }

        public bool? JointExecutor { get; set; }

        public int? DirectionChangeStatus { get; set; }

        public int ChangeType { get; set; }
        public string DirectionChangeConfirmNote { get; set; }
        public virtual DOCS_DIRECTIONS DOCS_DIRECTIONS { get; set; }
    }
}