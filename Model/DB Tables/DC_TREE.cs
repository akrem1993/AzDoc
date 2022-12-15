namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public partial class DC_TREE : BaseEntity
    {
        public DC_TREE()
        {
            DOC_DIRECTION_TEMPLATE = new HashSet<DOC_DIRECTION_TEMPLATE>();
            //DOC_TYPE_GROUP = new DOC_TYPE_GROUP();
        }

        [Key]
        public int TreeId { get; set; }

        public int TreeSchemaId { get; set; }

        public int TreeDocTypeId { get; set; }

        public int TreeDocTypeGroupId { get; set; }

        [Required]
        [StringLength(100)]
        public string TreeTreeName { get; set; }

        public int? TreeOrderIndex { get; set; }

        public virtual DM_SCHEMA DM_SCHEMA { get; set; }

        public virtual DOC_TYPE DOC_TYPE { get; set; }

        public DOC_TYPE_GROUP DOC_TYPE_GROUP { get; set; }

        public virtual ICollection<DOC_DIRECTION_TEMPLATE> DOC_DIRECTION_TEMPLATE { get; set; }
    }
}