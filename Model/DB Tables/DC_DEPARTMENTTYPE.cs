namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public partial class DC_DEPARTMENTTYPE : BaseEntity
    {
        //public DC_DEPARTMENTTYPE()
        //{
        //    DC_DEPARTMENT = new HashSet<DC_DEPARTMENT>();
        //}

        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int TypeId { get; set; }

        [Required]
        [StringLength(250)]
        public string TypeName { get; set; }

        public bool TypeStatus { get; set; }

        //public virtual ICollection<DC_DEPARTMENT> DC_DEPARTMENT { get; set; }
    }
}