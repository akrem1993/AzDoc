using Model.Entity;
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Model.DB_Tables;

namespace DMSModel
{
    public class DC_VACATION : AuditableEntity<int>
    {
        [Required]
        public byte VacationTypeId { get; set; }

        [Required]
        [Column(Order = 1)]
        public int VacationWorkplaceId { get; set; }

        [Required]
        [Column(Order = 2)]
        public int VacationNewUserId { get; set; }

        [Required]
        public int VacationOldUserId { get; set; }

        [Column(TypeName = "date")]
        public DateTime VacationBeginDate { get; set; }

        [Column(TypeName = "date")]
        public DateTime VacationEndDate { get; set; }

        [ForeignKey("VacationTypeId")]
        public virtual DC_VACATION_TYPE DC_VACATION_TYPE { get; set; }

        [ForeignKey("VacationWorkplaceId")]
        public virtual DC_WORKPLACE DC_WORKPLACE { get; set; }

        [ForeignKey("VacationNewUserId")]
        public virtual DC_USER DC_NEW_USER { get; set; }

        [ForeignKey("VacationOldUserId")]
        public virtual DC_USER DC_OLD_USER { get; set; }
    }
}