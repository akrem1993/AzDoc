namespace DMSModel
{
    using Model.DB_Tables;
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public partial class DC_REGION : BaseEntity
    {
        public DC_REGION()
        {
            //DC_ORGANIZATION = new HashSet<DC_ORGANIZATION>();
            DC_PERSONNEL = new HashSet<DC_PERSONNEL>();
            DOCS_APPLICATION = new HashSet<DOCS_APPLICATION>();
            DOCS_APPLICATION1 = new HashSet<DOCS_APPLICATION>();
            DOCS_APPLICATION2 = new HashSet<DOCS_APPLICATION>();
        }

        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int RegionId { get; set; }

        [StringLength(250)]
        public string RegionName { get; set; }


        public int? RegionCountryId { get; set; }

        public int? RegionTopId { get; set; }

        public int? RegionTypeId { get; set; }

        public int? RegionZoneId { get; set; }

        public byte RegionStatus { get; set; }

        [StringLength(8)]
        public string RegionId2 { get; set; }

        [StringLength(8)]
        public string RegionTopId2 { get; set; }

        public int? RegionCode { get; set; }
        public int? RegionCountryCode { get; set; }

        [ForeignKey("RegionCountryId")]
        public virtual DC_COUNTRY DC_COUNTRY { get; set; }

        //public virtual ICollection<DC_ORGANIZATION> DC_ORGANIZATION { get; set; } 747

        public virtual ICollection<DC_PERSONNEL> DC_PERSONNEL { get; set; }

        public virtual ICollection<DOCS_APPLICATION> DOCS_APPLICATION { get; set; }

        public virtual ICollection<DOCS_APPLICATION> DOCS_APPLICATION1 { get; set; }

        public virtual ICollection<DOCS_APPLICATION> DOCS_APPLICATION2 { get; set; }
    }
}