namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public partial class DC_SOCIALSTATUS : BaseEntity
    {
        public DC_SOCIALSTATUS()
        {
            DOCS_APPLICATION = new HashSet<DOCS_APPLICATION>();
        }

        [Key]
        public int SocialId { get; set; }

        [StringLength(100)]
        public string SocialName { get; set; }

        public bool SocialStatus { get; set; }

        public virtual ICollection<DOCS_APPLICATION> DOCS_APPLICATION { get; set; }
    }
}