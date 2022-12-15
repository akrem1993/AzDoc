namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public partial class AC_SQL_QUERY : BaseEntity
    {
        public AC_SQL_QUERY()
        {
            AC_DOC_TYPE_CELL = new HashSet<AC_DOC_TYPE_CELL>();
            DOC_TEMPLATE = new HashSet<DOC_TEMPLATE>();
        }

        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int SqlQueryId { get; set; }

        [Required]
        [StringLength(200)]
        public string DisplayName { get; set; }

        [Required]
        public string Query { get; set; }

        public int? SqlQueryTypeId { get; set; }

        public bool Status { get; set; }

        public virtual ICollection<AC_DOC_TYPE_CELL> AC_DOC_TYPE_CELL { get; set; }

        public virtual AC_SQL_QUERYTYPE AC_SQL_QUERYTYPE { get; set; }

        public virtual ICollection<DOC_TEMPLATE> DOC_TEMPLATE { get; set; }
    }
}