namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public partial class DC_OPERATIONTYPE : BaseEntity
    {
        public DC_OPERATIONTYPE()
        {
            DC_OPERATION = new HashSet<DC_OPERATION>();
        }

        [Key]
        public int OperationtypeId { get; set; }

        [Required]
        [StringLength(50)]
        public string OperationtypeName { get; set; }

        public bool OperationtypeStatus { get; set; }

        public virtual ICollection<DC_OPERATION> DC_OPERATION { get; set; }
    }
}