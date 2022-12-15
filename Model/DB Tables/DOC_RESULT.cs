using Model.DB_Tables;

namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public partial class DOC_RESULT : AuditableEntity<int>
    {
        public DOC_RESULT()
        {
            DOCS = new HashSet<DOC>();
        }

        [StringLength(2000)]
        public string ResultName { get; set; }

        public bool ResultStatus { get; set; }

        public virtual ICollection<DOC> DOCS { get; set; }
    }
}