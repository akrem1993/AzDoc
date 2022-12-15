namespace DMSModel
{
    using Model.Entity;
    using System.ComponentModel.DataAnnotations;

    public partial class DOC_VIEWSTATUS : BaseEntity
    {
        [Key]
        public int ViewStatusId { get; set; }

        [Required]
        public string ViewStatusName { get; set; }

        public bool ViewStatusStatus { get; set; }
    }
}