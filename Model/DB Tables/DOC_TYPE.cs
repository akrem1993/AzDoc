using Model.DB_Tables;

namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public partial class DOC_TYPE : BaseEntity
    {
        public DOC_TYPE()
        {
            AC_DOC_TYPE_CELL = new HashSet<AC_DOC_TYPE_CELL>();
            DOC_TYPE_EXCHANGE = new HashSet<DOC_TYPE_EXCHANGE>();
            DOC_TYPE_EXCHANGE1 = new HashSet<DOC_TYPE_EXCHANGE>();
            DOC_TYPE_EXCHANGE2 = new HashSet<DOC_TYPE_EXCHANGE>();
            DOCS = new HashSet<DOC>();
            DC_TREE = new HashSet<DC_TREE>();
            AC_SEARCH_COLUMNS = new HashSet<AC_SEARCH_COLUMNS>();
            AC_FILTER = new HashSet<AC_FILTER>();
            DM_STEP = new HashSet<DM_STEP>();
            DC_NUMBERING = new HashSet<DC_NUMBERING>();
            DOC_FORM_DOCTYPE = new HashSet<DOC_FORM_DOCTYPE>();
        }

        [Key]
        public int DocTypeId { get; set; }

        [Required]
        [StringLength(250)]
        public string DocTypeName { get; set; }

        public int? DocPeriodId { get; set; }

        public byte? DocTypeOrderIndex { get; set; }

        public bool DocPeriodStatus { get; set; }

        public virtual ICollection<AC_DOC_TYPE_CELL> AC_DOC_TYPE_CELL { get; set; }

        public virtual ICollection<DOC_TYPE_EXCHANGE> DOC_TYPE_EXCHANGE { get; set; }

        public virtual ICollection<DOC_TYPE_EXCHANGE> DOC_TYPE_EXCHANGE1 { get; set; }

        public virtual ICollection<DM_STEP> DM_STEP { get; set; }

        public virtual ICollection<DOC_TYPE_EXCHANGE> DOC_TYPE_EXCHANGE2 { get; set; }

        public virtual ICollection<DC_TREE> DC_TREE { get; set; }

        public virtual ICollection<DOC> DOCS { get; set; }

        public virtual ICollection<AC_SEARCH_COLUMNS> AC_SEARCH_COLUMNS { get; set; }

        public virtual ICollection<AC_FILTER> AC_FILTER { get; set; }

        public virtual ICollection<DC_NUMBERING> DC_NUMBERING { get; set; }

        public virtual ICollection<DOC_FORM_DOCTYPE> DOC_FORM_DOCTYPE { get; set; }

        //public virtual DOC_DOCUMENTSTATUS_DOCTYPE DOC_DOCUMENTSTATUS_DOCTYPE { get; set; }

        
    }
}