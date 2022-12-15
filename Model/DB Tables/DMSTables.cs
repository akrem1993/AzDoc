namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public partial class DMSTables : BaseEntity
    {
        public DMSTables()
        {
            DMSColumns = new HashSet<DMSColumns>();
            DMSColumns1 = new HashSet<DMSColumns>();
            DMSTableRelations = new HashSet<DMSTableRelation>();
            DMSTableRelations1 = new HashSet<DMSTableRelation>();
        }

        [Key]
        public int Id { get; set; }

        [Required]
        [StringLength(100)]
        public string Name { get; set; }

        [Required]
        [StringLength(100)]
        public string DisplayName { get; set; }

        [StringLength(500)]
        public string Description { get; set; }

        public int? TopId { get; set; }

        public int OrderNo { get; set; }

        [StringLength(500)]
        public string PageUrl { get; set; }

        public int? GridWidth { get; set; }

        public bool Status { get; set; }

        public virtual ICollection<DMSColumns> DMSColumns { get; set; }

        public virtual ICollection<DMSColumns> DMSColumns1 { get; set; }

        public virtual ICollection<DMSTableRelation> DMSTableRelations { get; set; }

        public virtual ICollection<DMSTableRelation> DMSTableRelations1 { get; set; }
    }
}