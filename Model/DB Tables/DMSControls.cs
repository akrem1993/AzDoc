namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public partial class DMSControls : BaseEntity
    {
        public DMSControls()
        {
            DMSColumns = new HashSet<DMSColumns>();
        }

        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int Code { get; set; }

        [Required]
        [StringLength(100)]
        public string Name { get; set; }

        public bool Status { get; set; }

        public virtual ICollection<DMSColumns> DMSColumns { get; set; }
    }
}