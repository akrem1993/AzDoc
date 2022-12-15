namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public partial class DC_OPERATION : BaseEntity
    {
        public DC_OPERATION()
        {
            DC_ROLE_OPERATION = new HashSet<DC_ROLE_OPERATION>();
        }

        [Key]
        public int OperationId { get; set; }

        [Required]
        [StringLength(250)]
        public string OperationName { get; set; }

        [Required]
        public int OperationTypeId { get; set; }

        public int OperationApplicationId { get; set; }

        [StringLength(200)]
        public string OperationParameter { get; set; }

        public int? OperationSchemaId { get; set; }

        public bool OperationStatus { get; set; }

        public virtual DC_APPLICATION DC_APPLICATION { get; set; }

        public virtual DC_OPERATIONTYPE DC_OPERATIONTYPE { get; set; }

        public virtual DM_SCHEMA DM_SCHEMA { get; set; }

        public virtual ICollection<DC_ROLE_OPERATION> DC_ROLE_OPERATION { get; set; }
    }
}