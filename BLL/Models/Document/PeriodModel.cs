using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace BLL.Models.Document
{
    public class PeriodModel
    {
        [Key]
        public int PeriodId { get; set; }

        [Column(TypeName = "date")]
        public DateTime PeriodDate1 { get; set; }

        [Column(TypeName = "date")]
        public DateTime PeriodDate2 { get; set; }

        [Required]
        [StringLength(200)]
        public string PeriodDescription { get; set; }

        public bool PeriodStatus { get; set; }
    }
}