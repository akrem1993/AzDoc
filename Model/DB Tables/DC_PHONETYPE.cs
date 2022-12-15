namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public partial class DC_PHONETYPE : BaseEntity
    {
        public DC_PHONETYPE()
        {
            DOCS_APPLICATION = new HashSet<DOCS_APPLICATION>();
        }

        [Key]
        public int TypeId { get; set; }

        [StringLength(100)]
        public string TypeName { get; set; }

        public bool TypeStatus { get; set; }

        public virtual ICollection<DOCS_APPLICATION> DOCS_APPLICATION { get; set; }
    }
}