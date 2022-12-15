namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public partial class DOC_TYPE_GROUP : BaseEntity
    {
        public DOC_TYPE_GROUP()
        {
            DC_TREE = new HashSet<DC_TREE>();
        }

        [Key]
        public int DocTypeGroupId { get; set; }

        public int SchemaId { get; set; }

        [Required]
        [StringLength(250)]
        public string DocTypeGroupName { get; set; }

        public byte? DocTypeGroupOrderIndex { get; set; }

        public bool DocTypeGroupStatus { get; set; }

        public virtual ICollection<DC_TREE> DC_TREE { get; set; }

        public virtual DM_SCHEMA DM_SCHEMA { get; set; }
    }
}