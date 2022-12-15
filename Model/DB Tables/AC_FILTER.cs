namespace DMSModel
{
    using Model.Entity;
    using System.ComponentModel.DataAnnotations;

    public partial class AC_FILTER : BaseEntity
    {
        [Key]
        public int DocFilterId { get; set; }

        public int DocFilterSchemaId { get; set; }

        public int DocFilterDocTypeId { get; set; }

        [Required]
        [StringLength(250)]
        public string DocFilterCaption { get; set; }

        [Required]
        [StringLength(300)]
        public string DocFilterLinq { get; set; }

        public byte DocFilterOrderIndex { get; set; }

        public byte DocFilterStatus { get; set; }

        public virtual DM_SCHEMA DM_SCHEMA { get; set; }

        public virtual DOC_TYPE DOC_TYPE { get; set; }
    }
}