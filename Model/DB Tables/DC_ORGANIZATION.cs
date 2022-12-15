using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Model.Entity;

namespace Model.DB_Tables
{
    [Table("DC_ORGANIZATION")]
    public partial class DC_ORGANIZATION
    {
        //public DC_ORGANIZATION()
        //{
        //    DC_DEPARTMENT = new HashSet<DC_DEPARTMENT>();
        //    DC_WORKPLACE = new HashSet<DC_WORKPLACE>();
        //    DOCS = new HashSet<DOC>();
        //    DOC_AUTHOR = new HashSet<DOC_AUTHOR>();
        //    DOCS_ADDRESSINFO = new HashSet<DOCS_ADDRESSINFO>();
        //    DOC_NUMBERS = new HashSet<DOC_NUMBERS>();
        //}

        [Key]
        public int OrganizationId { get; set; }

        [Required]
        [StringLength(250)]
        public string OrganizationName { get; set; }

        [Required]
        [StringLength(250)]
        public string OrganizationShortname { get; set; }

        [StringLength(250)]
        public string OrganizationName2 { get; set; }

        [StringLength(250)]
        public string OrganizationName3 { get; set; }

        public int? OrganizationTopId { get; set; }

        public int? OrganizationTypeId { get; set; }

        //public int? OrganizationRegionId { get; set; }

        [StringLength(10)]
        public string OrganizationZip { get; set; }

        [StringLength(200)]
        public string UserLimitComment { get; set; }

        [StringLength(100)]
        public string OrganizationPhone { get; set; }

        [StringLength(100)]
        public string OrganizationFax { get; set; }

        [StringLength(100)]
        public string OrganizationChiefname { get; set; }

        [StringLength(100)]
        public string OrganizationWebsite { get; set; }

        [StringLength(100)]
        public string OrganizationEmail { get; set; }

        public int? MaxUserCount { get; set; }

        [StringLength(25)]
        public string OrganizationIndex { get; set; }

        public bool OrganizationStatus { get; set; }

        public int? IsDeleted { get; set; }
        public bool? IsAuthorOrganization { get; set; }

        //public virtual ICollection<DC_DEPARTMENT> DC_DEPARTMENT { get; set; }

        //public virtual DC_ORGANIZATIONTYPE DC_ORGANIZATIONTYPE { get; set; }

        //public virtual DC_REGION DC_REGION { get; set; }

        //public virtual ICollection<DC_WORKPLACE> DC_WORKPLACE { get; set; }

        //public virtual DM_ORG_SCHEMA DM_ORG_SCHEMA { get; set; }

        //public virtual ICollection<DOC> DOCS { get; set; }

        //public virtual ICollection<DM_ORGGROUP_SCHEMA> DM_ORGGROUP_SCHEMA { get; set; }

        //public virtual ICollection<DOC_AUTHOR> DOC_AUTHOR { get; set; }

        //public virtual ICollection<DOCS_ADDRESSINFO> DOCS_ADDRESSINFO { get; set; }

        //public virtual ICollection<DOC_NUMBERS> DOC_NUMBERS { get; set; }
    }
}