namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public partial class DOC_ADRTYPE : BaseEntity
    {
        public DOC_ADRTYPE()
        {
            DOCS_ADDRESSINFO = new HashSet<DOCS_ADDRESSINFO>();
        }

        [Key]
        public int AdrTypeId { get; set; }

        [StringLength(250)]
        public string AdrTypeName { get; set; }

        public virtual ICollection<DOCS_ADDRESSINFO> DOCS_ADDRESSINFO { get; set; }
    }
}