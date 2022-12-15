namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public partial class DC_RIGHT_TYPE : BaseEntity
    {
        public DC_RIGHT_TYPE()
        {
            DC_ROLE_OPERATION = new HashSet<DC_ROLE_OPERATION>();
        }

        [Key]
        public int RightTypeId { get; set; }

        [Required]
        [StringLength(500)]
        public string RightTypeName { get; set; }

        public bool RightTypeStatus { get; set; }

        public virtual ICollection<DC_ROLE_OPERATION> DC_ROLE_OPERATION { get; set; }
    }
}