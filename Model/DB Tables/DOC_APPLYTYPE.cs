namespace DMSModel
{
    using Model.Entity;
    using System.ComponentModel.DataAnnotations;

    public partial class DOC_APPLYTYPE : BaseEntity
    {
        [Key]
        public int ApplytypeId { get; set; }

        [Required]
        [StringLength(200)]
        public string ApplytypeName { get; set; }

        public bool ApplytypeStatus { get; set; }
    }
}