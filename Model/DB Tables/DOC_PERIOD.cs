using Model.DB_Tables;

namespace DMSModel
{
    using Model.Entity;
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public partial class DOC_PERIOD : BaseEntity
    {
        public DOC_PERIOD()
        {
            DOCS = new HashSet<DOC>();
            DOC_NUMBERS = new HashSet<DOC_NUMBERS>();
        }

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

        public virtual ICollection<DOC> DOCS { get; set; }
        public virtual ICollection<DOC_NUMBERS> DOC_NUMBERS { get; set; }
    }
}