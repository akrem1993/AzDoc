using Model.Entity;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace DMSModel
{
    public partial class DOC_SENDSTATUS : BaseEntity
    {
        public DOC_SENDSTATUS()
        {
            DOCS_EXECUTOR = new HashSet<DOCS_EXECUTOR>();
            DOCS_ADDRESSINFO = new HashSet<DOCS_ADDRESSINFO>();
        }

        [Key]
        public int SendStatusId { get; set; }

        [Required]
        [StringLength(200)]
        public string SendStatusName { get; set; }

        public bool SendStatusStatus { get; set; }
        public virtual ICollection<DOCS_EXECUTOR> DOCS_EXECUTOR { get; set; }
        public virtual ICollection<DOCS_ADDRESSINFO> DOCS_ADDRESSINFO { get; set; }
    }
}