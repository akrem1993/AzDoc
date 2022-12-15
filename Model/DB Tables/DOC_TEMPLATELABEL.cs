namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public partial class DOC_TEMPLATELABEL : BaseEntity
    {
        public DOC_TEMPLATELABEL()
        {
            DOC_SELECTED_TEMPLATELABEL = new HashSet<DOC_SELECTED_TEMPLATELABEL>();
        }

        [Key]
        public string LabelId { get; set; }

        [Required]
        [StringLength(200)]
        public string LabelName { get; set; }

        [StringLength(200)]
        public string LabelDescription { get; set; }

        public int? SQLId { get; set; }

        [StringLength(200)]
        public string LabelField { get; set; }

        public bool Status { get; set; }

        public virtual ICollection<DOC_SELECTED_TEMPLATELABEL> DOC_SELECTED_TEMPLATELABEL { get; set; }
    }
}