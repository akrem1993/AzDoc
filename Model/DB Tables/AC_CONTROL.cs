namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public partial class AC_CONTROL : BaseEntity
    {
        public AC_CONTROL()
        {
            AC_CELL = new HashSet<AC_CELL>();
        }

        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int ControlId { get; set; }

        [Required]
        [StringLength(100)]
        public string ControlName { get; set; }

        [StringLength(250)]
        public string ControlDescription { get; set; }

        [StringLength(250)]
        public string ControlController { get; set; }

        public bool ControlStatus { get; set; }

        public virtual ICollection<AC_CELL> AC_CELL { get; set; }
    }
}