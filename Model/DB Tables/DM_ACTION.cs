namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public partial class DM_ACTION : BaseEntity
    {
        public DM_ACTION()
        {
            DM_STEP = new HashSet<DM_STEP>();
        }

        [Key]
        public int ActionId { get; set; }

        [Required]
        [StringLength(100)]
        public string ActionName { get; set; }

        public bool ActionStatus { get; set; }

        public virtual ICollection<DM_STEP> DM_STEP { get; set; }
    }
}