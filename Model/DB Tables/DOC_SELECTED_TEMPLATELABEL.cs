namespace DMSModel
{
    using Model.Entity;
    using System.ComponentModel.DataAnnotations;

    public partial class DOC_SELECTED_TEMPLATELABEL : BaseEntity
    {
        public int Id { get; set; }

        [Required]
        [StringLength(50)]
        public string LabelId { get; set; }

        public int TemplateId { get; set; }

        public byte Active { get; set; }

        public virtual DOC_TEMPLATE DOC_TEMPLATE { get; set; }

        public virtual DOC_TEMPLATELABEL DOC_TEMPLATELABEL { get; set; }
    }
}