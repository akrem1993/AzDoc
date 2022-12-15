namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public partial class DC_NATION : BaseEntity
    {
        public DC_NATION()
        {
            DOCS_APPLICATION = new HashSet<DOCS_APPLICATION>();
        }

        [Key]
        public int NationId { get; set; }

        [StringLength(100)]
        public string NationName { get; set; }

        public bool NationStatus { get; set; }

        public virtual ICollection<DOCS_APPLICATION> DOCS_APPLICATION { get; set; }
    }
}