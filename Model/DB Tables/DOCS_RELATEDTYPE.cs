using Model.Entity;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Model.DB_Tables;

namespace DMSModel
{
    public partial class DOCS_RELATEDTYPE : BaseEntity
    {
        public DOCS_RELATEDTYPE()
        {
            DOCS_RELATED = new HashSet<DOCS_RELATED>();
        }

        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int RelatedTypeId { get; set; }

        [StringLength(50)]
        public string Name { get; set; }

        public virtual ICollection<DOCS_RELATED> DOCS_RELATED { get; set; }
    }
}