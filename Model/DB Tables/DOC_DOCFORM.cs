namespace DMSModel
{
    using Model.Entity;
    using System.ComponentModel.DataAnnotations;

    public partial class DOC_DOCFORM : BaseEntity
    {
        [Key]
        public int DocformId { get; set; }

        [Required]
        [StringLength(50)]
        public string DocformName { get; set; }

        public bool DocformStatus { get; set; }
    }
}