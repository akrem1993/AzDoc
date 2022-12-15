namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public partial class DOC_FORM : BaseEntity
    {
        public DOC_FORM()
        {
            DOC_FORM_DOCTYPE = new HashSet<DOC_FORM_DOCTYPE>();
        }

        [Key]
        public int FormId { get; set; }

        [Required]
        [StringLength(50)]
        public string FormName { get; set; }

        public bool FormStatus { get; set; }
        public virtual ICollection<DOC_FORM_DOCTYPE> DOC_FORM_DOCTYPE { get; set; }
    }
}