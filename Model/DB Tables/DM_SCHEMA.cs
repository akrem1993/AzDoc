namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public partial class DM_SCHEMA : BaseEntity
    {
        public DM_SCHEMA()
        {
            AC_DOC_TYPE_CELL = new HashSet<AC_DOC_TYPE_CELL>();
            DC_OPERATION = new HashSet<DC_OPERATION>();
            DM_ORG_SCHEMA = new HashSet<DM_ORG_SCHEMA>();
            DOC_TYPE_EXCHANGE = new HashSet<DOC_TYPE_EXCHANGE>();
            DC_TREE = new HashSet<DC_TREE>();
            DOC_TYPE_GROUP = new HashSet<DOC_TYPE_GROUP>();
            AC_SEARCH_COLUMNS = new HashSet<AC_SEARCH_COLUMNS>();
            AC_FILTER = new HashSet<AC_FILTER>();
            DC_NUMBERING = new HashSet<DC_NUMBERING>();
            DOC_DOCUMENTSTATUS_DOCTYPE = new HashSet<DOC_DOCUMENTSTATUS_DOCTYPE>();
            DOC_FORM_DOCTYPE = new HashSet<DOC_FORM_DOCTYPE>();
            DOC_STEP = new HashSet<DOC_STEP>();
        }

        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int SchemaId { get; set; }

        [Required]
        [StringLength(250)]
        public string SchemaName { get; set; }

        [StringLength(250)]
        public string SchemaDescription { get; set; }

        public virtual ICollection<AC_DOC_TYPE_CELL> AC_DOC_TYPE_CELL { get; set; }

        public virtual ICollection<DC_OPERATION> DC_OPERATION { get; set; }

        public virtual ICollection<DM_ORG_SCHEMA> DM_ORG_SCHEMA { get; set; }

        public virtual ICollection<DC_TREE> DC_TREE { get; set; }

        public virtual ICollection<DOC_TYPE_GROUP> DOC_TYPE_GROUP { get; set; }

        public virtual ICollection<DOC_TYPE_EXCHANGE> DOC_TYPE_EXCHANGE { get; set; }

        public virtual ICollection<AC_SEARCH_COLUMNS> AC_SEARCH_COLUMNS { get; set; }

        public virtual ICollection<DM_ORGGROUP_SCHEMA> DM_ORGGROUP_SCHEMA { get; set; }

        public virtual ICollection<AC_FILTER> AC_FILTER { get; set; }

        public virtual ICollection<DC_NUMBERING> DC_NUMBERING { get; set; }
        public virtual ICollection<DOC_DOCUMENTSTATUS_DOCTYPE> DOC_DOCUMENTSTATUS_DOCTYPE { get; set; }
        public virtual ICollection<DOC_FORM_DOCTYPE> DOC_FORM_DOCTYPE { get; set; }
        public virtual ICollection<DOC_STEP> DOC_STEP { get; set; }
    }
}