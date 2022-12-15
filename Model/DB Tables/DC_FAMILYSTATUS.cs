namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public partial class DC_FAMILYSTATUS : BaseEntity
    {
        public DC_FAMILYSTATUS()
        {
            DOCS_APPLICATION = new HashSet<DOCS_APPLICATION>();
        }

        [Key]
        public int FamilyId { get; set; }

        [StringLength(100)]
        public string FamilyName { get; set; }

        public bool FamilyStatus { get; set; }

        public virtual ICollection<DOCS_APPLICATION> DOCS_APPLICATION { get; set; }
    }
}