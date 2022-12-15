namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public partial class AC_DOC_TYPE_CELL : BaseEntity
    {
        public AC_DOC_TYPE_CELL()
        {
            AC_DOC_TYPE_CELLS = new HashSet<AC_DOC_TYPE_CELL>();
            AC_DOC_TYPE_CELLS_INSIDE = new HashSet<AC_DOC_TYPE_CELL>();
        }

        [Key]
        public int DocTypeCellId { get; set; }

        public int SchemaId { get; set; }

        public int? DocTypeId { get; set; }

        public int CellId { get; set; }

        public int ViewId { get; set; }

        [StringLength(200)]
        [Required]
        public string DocTypeCellICaption { get; set; }

        public int? RelatedDocTypeCellId { get; set; }

        public int? InsideDocTypeCellId { get; set; }

        [StringLength(50)]
        public string DocTypeCelDefaultValue { get; set; }

        [StringLength(200)]
        public string Parameter { get; set; }

        public bool DocTypeCelRequried { get; set; }

        public int? SqlQueryId { get; set; }

        public bool ReadOnlyOnInsert { get; set; }

        public bool ReadOnlyOnUpdate { get; set; }

        public bool UseInSearch { get; set; }

        public bool UseInResult { get; set; }

        public bool VisibleOnInsert { get; set; }

        public bool VisibleOnUpdate { get; set; }

        public bool NewLine { get; set; }

        public byte ColumnLength { get; set; }

        public int CaptionWidth { get; set; }

        public int ControlWidth { get; set; }

        public int ControlHeight { get; set; }

        public byte DocTypeCellOrderIndex { get; set; }

        public bool DocTypeCelStatus { get; set; }

        public int? CellSelectionCount { get; set; }

        public virtual AC_CELL AC_CELL { get; set; }

        public virtual ICollection<AC_DOC_TYPE_CELL> AC_DOC_TYPE_CELLS { get; set; }

        public virtual ICollection<AC_DOC_TYPE_CELL> AC_DOC_TYPE_CELLS_INSIDE { get; set; }

        public virtual AC_DOC_TYPE_CELL AC_DOC_TYPE_CELL_RELATED { get; set; }

        public virtual AC_DOC_TYPE_CELL AC_DOC_TYPE_CELL_INSIDE { get; set; }

        public virtual AC_SQL_QUERY AC_SQL_QUERY { get; set; }

        public virtual DM_SCHEMA DM_SCHEMA { get; set; }

        public virtual DOC_TYPE DOC_TYPE { get; set; }

        public virtual AC_VIEW AC_VIEW { get; set; }
    }
}