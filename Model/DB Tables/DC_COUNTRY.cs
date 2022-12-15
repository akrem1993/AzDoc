namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public partial class DC_COUNTRY : BaseEntity
    {
        public DC_COUNTRY()
        {
            DC_REGION = new HashSet<DC_REGION>();
            DOCS_APPLICATION = new HashSet<DOCS_APPLICATION>();
        }

        [Key]
        public int CountryId { get; set; }

        [Required]
        [StringLength(250)]
        public string CountryName { get; set; }

        [Required]
        [StringLength(250)]
        public string CountryName2 { get; set; }

        public byte CountryStatus { get; set; }

        public int? Code { get; set; }

        public virtual ICollection<DC_REGION> DC_REGION { get; set; }

        public virtual ICollection<DOCS_APPLICATION> DOCS_APPLICATION { get; set; }
    }
}