namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public partial class DC_APPLICATION : BaseEntity
    {
        public DC_APPLICATION()
        {
            DC_OPERATION = new HashSet<DC_OPERATION>();
            DC_ROLE = new HashSet<DC_ROLE>();
        }

        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int ApplicationId { get; set; }

        [Required]
        [StringLength(50)]
        public string ApplicationName { get; set; }

        public virtual ICollection<DC_OPERATION> DC_OPERATION { get; set; }

        public virtual ICollection<DC_ROLE> DC_ROLE { get; set; }
    }
}