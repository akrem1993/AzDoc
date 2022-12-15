using System.ComponentModel.DataAnnotations;
using DMSModel;
using Model.Entity;

namespace Model.DB_Tables
{
    public partial class DOCS_RELATED : BaseEntity
    {
        [Key]
        public int RelatedId { get; set; }

        public int RelatedDocId { get; set; }

        public int RelatedDocumentId { get; set; }

        public int RelatedTypeId { get; set; }

        public virtual DOC DOC { get; set; }

        public virtual DOCS_RELATEDTYPE DOCS_RELATEDTYPE { get; set; }
    }
}