using Model.Entity;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using Model.DB_Tables;

namespace DMSModel
{
    public partial class DOC_AUTHOR : BaseEntity
    {
        public DOC_AUTHOR()
        {
            DOCS_ADDRESSINFO = new HashSet<DOCS_ADDRESSINFO>();
        }

        [Key]
        public int AuthorId { get; set; }

        [StringLength(250)]
        public string AuthorName { get; set; }

        [StringLength(250)]
        public string AuthorSurname { get; set; }

        [StringLength(250)]
        public string AuthorLastname { get; set; }

        public int? AuthorOrganizationId { get; set; }

        [StringLength(200)]
        public string AuthorDepartmentname { get; set; }

        public int? AuthorSexId { get; set; }

        public int? AuthorPositionId { get; set; }

        [StringLength(200)]
        public string AuthorPhone { get; set; }

        [StringLength(200)]
        public string AuthorFax { get; set; }

        [StringLength(200)]
        public string AuthorEmail { get; set; }

        public bool? AuthorStatus { get; set; }

        public virtual DC_ORGANIZATION DC_ORGANIZATION { get; set; }

        public virtual DC_POSITION DC_POSITION { get; set; }

        public virtual DC_SEX DC_SEX { get; set; }

        public virtual ICollection<DOCS_ADDRESSINFO> DOCS_ADDRESSINFO { get; set; }
    }
}