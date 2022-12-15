namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public partial class DOC_DIRECTIONTYPE : BaseEntity
    {
        public DOC_DIRECTIONTYPE()
        {
            DOC_DIRECTION_TEMPLATE = new HashSet<DOC_DIRECTION_TEMPLATE>();
        }

        [Key]
        public int DirectionTypeId { get; set; }

        [Required]
        [StringLength(50)]
        public string DirectionTypeName { get; set; }

        public virtual ICollection<DOC_DIRECTION_TEMPLATE> DOC_DIRECTION_TEMPLATE { get; set; }
    }
}