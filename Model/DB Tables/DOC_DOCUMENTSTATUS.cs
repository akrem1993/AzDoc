namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public partial class DOC_DOCUMENTSTATUS : BaseEntity
    {
        public DOC_DOCUMENTSTATUS()
        {
            DOC_DOCUMENTSTATUS_DOCTYPE = new HashSet<DOC_DOCUMENTSTATUS_DOCTYPE>();
            DOC_STEP = new HashSet<DOC_STEP>();
        }

        [Key]
        public int DocumentstatusId { get; set; }

        [Required]
        [StringLength(200)]
        public string DocumentstatusName { get; set; }

        public bool DocumentstatusStatus { get; set; }
        public virtual ICollection<DOC_DOCUMENTSTATUS_DOCTYPE> DOC_DOCUMENTSTATUS_DOCTYPE { get; set; }
        public virtual ICollection<DOC_STEP> DOC_STEP { get; set; }
    }
}