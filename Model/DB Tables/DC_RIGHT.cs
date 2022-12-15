namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public partial class DC_RIGHT : BaseEntity
    {
        public DC_RIGHT()
        {
            DC_ROLE_OPERATION = new HashSet<DC_ROLE_OPERATION>();
        }

        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int RightId { get; set; }

        [Required]
        [StringLength(200)]
        public string RightName { get; set; }

        [Required]
        public int OperationTypeId { get; set; }

        public bool RightStatus { get; set; }

        public virtual ICollection<DC_ROLE_OPERATION> DC_ROLE_OPERATION { get; set; }
    }
}