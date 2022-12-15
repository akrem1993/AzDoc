namespace DMSModel
{
    using Model.Entity;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public partial class DOC_TEMPLATETYPE : BaseEntity
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int TemplateTypeId { get; set; }

        [Required]
        [StringLength(200)]
        public string TemplateTypeName { get; set; }
    }
}