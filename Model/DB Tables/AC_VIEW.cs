namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public partial class AC_VIEW : BaseEntity
    {
        public AC_VIEW()
        {
            AC_DOC_TYPE_CELL = new HashSet<AC_DOC_TYPE_CELL>();
        }

        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int ViewId { get; set; }

        [StringLength(100)]
        public string ViewName { get; set; }

        public virtual ICollection<AC_DOC_TYPE_CELL> AC_DOC_TYPE_CELL { get; set; }
    }
}