namespace DMSModel
{
    using Model.Entity;
    using System.ComponentModel.DataAnnotations;

    public partial class DOC_DESCRIPTION : BaseEntity
    {
        [Key]
        public int DescriptionId { get; set; }

        public int? DescriptionDoctypeId { get; set; }

        public int DescriptionTypeId { get; set; }

        public byte? DescriptionControlStatus { get; set; }

        public int? DescriptionExecutionStatusId { get; set; }

        [Required]
        public string DescriptionContent { get; set; }

        public bool DescriptionStatus { get; set; }
    }
}