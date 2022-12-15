namespace DMSModel
{
    using Model.Entity;
    using System.ComponentModel.DataAnnotations;

    public partial class DOC_RECEIVED_FORM : BaseEntity
    {
        [Key]
        public int ReceivedFormId { get; set; }

        [Required]
        [StringLength(50)]
        public string ReceivedFormName { get; set; }

        public bool ReceivedFormStatus { get; set; }
    }
}