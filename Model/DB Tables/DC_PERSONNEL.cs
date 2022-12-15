using Model.DB_Tables;

namespace DMSModel
{
    using Model.Entity;
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public partial class DC_PERSONNEL
    {
        public DC_PERSONNEL()
        {
            DC_USER = new HashSet<DC_USER>();
        }

        [Key]
        public int PersonnelId { get; set; }

        [Required]
        [StringLength(50)]
        public string PersonnelName { get; set; }

        [Required]
        [StringLength(50)]
        public string PersonnelSurname { get; set; }

        [StringLength(50)]
        public string PersonnelLastname { get; set; }

        public virtual string PersonnelFullname
        {
            get
            {
                string result = string.Format("{0} {1} {2}",
                                            PersonnelName,
                                            PersonnelSurname,
                                            PersonnelLastname);
                return result;
            }
        }

        [Column(TypeName = "date")]
        public DateTime? PersonnelBirthdate { get; set; }

        public int PersonnelSexId { get; set; }

        [StringLength(10)]
        public string PersonnelFIN { get; set; }

        public int? PersonnelRankId { get; set; }

        public int? PersonnelRegionId { get; set; }

        [StringLength(200)]
        public string PersonnelAddress { get; set; }

        [StringLength(50)]
        public string PersonnelPhone { get; set; }

        [StringLength(250)]
        public string PersonnelEmail { get; set; }

        [StringLength(50)]
        public string PersonnelMobile { get; set; }

        [StringLength(50)]
        public string PersonnelTabelcode { get; set; }

        [StringLength(100)]
        public string PersonnelAsanPhoneId { get; set; }

        [StringLength(100)]
        public string PersonnelAsanUserId { get; set; }

        public bool? PersonnelStatus { get; set; }

        public virtual DC_RANK DC_RANK { get; set; }

        public virtual DC_REGION DC_REGION { get; set; }

        public virtual DC_SEX DC_SEX { get; set; }

        public virtual ICollection<DC_USER> DC_USER { get; set; }
    }
}