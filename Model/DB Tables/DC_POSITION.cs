namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public partial class DC_POSITION : BaseEntity
    {
        public DC_POSITION()
        {
            DOC_AUTHOR = new HashSet<DOC_AUTHOR>();
            DOCS_ADDRESSINFO = new HashSet<DOCS_ADDRESSINFO>();
        }

        [Key]
        public int PositionId { get; set; }

        [StringLength(250)]
        public string PositionName { get; set; }

        public bool PositionStatus { get; set; }

        public virtual ICollection<DOC_AUTHOR> DOC_AUTHOR { get; set; }

        public virtual ICollection<DOCS_ADDRESSINFO> DOCS_ADDRESSINFO { get; set; }
    }
}