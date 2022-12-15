namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public partial class AC_SQL_QUERYTYPE : BaseEntity
    {
        public AC_SQL_QUERYTYPE()
        {
            AC_SQL_QUERY = new HashSet<AC_SQL_QUERY>();
        }

        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int SqlQueryTypeId { get; set; }

        [Required]
        [StringLength(100)]
        public string Name { get; set; }

        public virtual ICollection<AC_SQL_QUERY> AC_SQL_QUERY { get; set; }
    }
}