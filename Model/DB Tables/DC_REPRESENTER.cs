namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public partial class DC_REPRESENTER : BaseEntity
    {
        public DC_REPRESENTER()
        {
            DOCS_APPLICATION = new HashSet<DOCS_APPLICATION>();
        }

        [Key]
        public int RepresenterId { get; set; }

        [StringLength(100)]
        public string RepresenterName { get; set; }

        public bool RepresenterStatus { get; set; }

        public virtual ICollection<DOCS_APPLICATION> DOCS_APPLICATION { get; set; }
    }
}