namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public partial class AC_CELL : BaseEntity
    {
        public AC_CELL()
        {
            AC_DOC_TYPE_CELL = new HashSet<AC_DOC_TYPE_CELL>();
        }

        [Key]
        public int CellId { get; set; }

        [Required]
        [StringLength(200)]
        public string CellDisplayName { get; set; }

        public int TableId { get; set; }

        public int ControlId { get; set; }

        [Required]
        [StringLength(50)]
        public string CellFieldName { get; set; }

        [StringLength(100)]
        public string CellMask { get; set; }

        public bool CellStatus { get; set; }

        public int? CellSelectionMode { get; set; }
        public virtual AC_CONTROL AC_CONTROL { get; set; }

        public virtual AC_TABLE AC_TABLE { get; set; }

        public virtual ICollection<AC_DOC_TYPE_CELL> AC_DOC_TYPE_CELL { get; set; }
    }
}