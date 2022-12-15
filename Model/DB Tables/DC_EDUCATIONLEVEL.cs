namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public partial class DC_EDUCATIONLEVEL : BaseEntity
    {
        public DC_EDUCATIONLEVEL()
        {
            DOCS_APPLICATION = new HashSet<DOCS_APPLICATION>();
        }

        [Key]
        public int LevelId { get; set; }

        [StringLength(100)]
        public string LevelName { get; set; }

        public bool LevelStatus { get; set; }

        public virtual ICollection<DOCS_APPLICATION> DOCS_APPLICATION { get; set; }
    }
}