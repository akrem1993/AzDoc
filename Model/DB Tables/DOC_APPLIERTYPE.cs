namespace DMSModel
{
    using Model.Entity;
    using System.ComponentModel.DataAnnotations;

    public partial class DOC_APPLIERTYPE : BaseEntity
    {
        [Key]
        public int AppliertypeId { get; set; }

        [Required]
        [StringLength(50)]
        public string AppliertypeName { get; set; }
    }
}