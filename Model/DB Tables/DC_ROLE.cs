namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public partial class DC_ROLE : BaseEntity
    {
        //public DC_ROLE()
        //{
        //    DC_ROLE_OPERATION = new HashSet<DC_ROLE_OPERATION>();
        //    DC_WORKPLACE_ROLE = new HashSet<DC_WORKPLACE_ROLE>();
        //}

        [Key]
        public int RoleId { get; set; }

        [Required]
        [StringLength(50)]
        public string RoleName { get; set; }

        [StringLength(100)]
        public string RoleComment { get; set; }

        public int? RoleApplicationId { get; set; }

        public bool? RoleStatus { get; set; }

        //public virtual DC_APPLICATION DC_APPLICATION { get; set; }

        //public virtual ICollection<DC_ROLE_OPERATION> DC_ROLE_OPERATION { get; set; }

        //public virtual ICollection<DC_WORKPLACE_ROLE> DC_WORKPLACE_ROLE { get; set; }
    }
}