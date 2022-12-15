namespace DMSModel
{
    using Model.Entity;
    using System.ComponentModel.DataAnnotations;

    public partial class DMSColumns : BaseEntity
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [StringLength(50)]
        public string Name { get; set; }

        [Required]
        [StringLength(100)]
        public string DisplayName { get; set; }

        public int IdControl { get; set; }

        public int IdTableTransaction { get; set; }

        public int IdTableGrid { get; set; }

        public int OrderNo { get; set; }

        [StringLength(100)]
        public string DefaultValue { get; set; }

        public int Width { get; set; }

        public bool IsPK { get; set; }

        public bool IsVirtual { get; set; }

        public bool AllowNulls { get; set; }

        [StringLength(200)]
        public string ErrorMessage { get; set; }

        public bool Visible { get; set; }

        public int RelatedIdControl { get; set; }

        [StringLength(1000)]
        public string SQLQuery { get; set; }

        public virtual DMSControls DMSControl { get; set; }

        public virtual DMSTables DMSTableTransaction { get; set; }

        public virtual DMSTables DMSTableGrid { get; set; }
    }
}