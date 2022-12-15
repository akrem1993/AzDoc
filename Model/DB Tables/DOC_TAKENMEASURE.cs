using Model.Entity;
using System.ComponentModel.DataAnnotations;

namespace DMSModel
{
    public partial class DOC_TAKENMEASURE : BaseEntity
    {
        [Key]
        public int TakenMeasureId { get; set; }

        [Required]
        public string TakenMeasureName { get; set; }

        public bool TakenMeasureStatus { get; set; }
    }
}