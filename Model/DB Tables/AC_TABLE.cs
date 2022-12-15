namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public partial class AC_TABLE : BaseEntity
    {
        public AC_TABLE()
        {
            AC_CELL = new HashSet<AC_CELL>();
        }

        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int TableId { get; set; }

        [Required]
        [StringLength(75)]
        public string TableName { get; set; }

        [Required]
        [StringLength(100)]
        public string TableDisplayName { get; set; }

        public byte OrderIndex { get; set; }

        public bool Status { get; set; }

        public virtual ICollection<AC_CELL> AC_CELL { get; set; }
    }
}