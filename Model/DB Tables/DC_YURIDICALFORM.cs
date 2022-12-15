namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public partial class DC_YURIDICALFORM : BaseEntity
    {
        public DC_YURIDICALFORM()
        {
            DOCS_APPLICATION = new HashSet<DOCS_APPLICATION>();
        }

        [Key]
        public int FormId { get; set; }

        [StringLength(100)]
        public string FormName { get; set; }

        public bool FormStatus { get; set; }

        public virtual ICollection<DOCS_APPLICATION> DOCS_APPLICATION { get; set; }
    }
}