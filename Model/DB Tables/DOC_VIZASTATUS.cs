using Model.DB_Views;
using Model.Entity;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using Model.DB_Tables;

namespace DMSModel
{
    public partial class DOC_VIZASTATUS : BaseEntity
    {
        public DOC_VIZASTATUS()
        {
            DOCS_FILE = new HashSet<DOCS_FILE>();
            VW_DOC_FILES = new HashSet<VW_DOC_FILES>();
        }

        [Key]
        public byte VizaStatusId { get; set; }

        [Required]
        [StringLength(200)]
        public string VizaStatusName { get; set; }

        public bool VizaStatusStatus { get; set; }

        public virtual ICollection<DOCS_FILE> DOCS_FILE { get; set; }
        public virtual ICollection<VW_DOC_FILES> VW_DOC_FILES { get; set; }
    }
}