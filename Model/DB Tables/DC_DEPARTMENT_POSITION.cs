namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public partial class DC_DEPARTMENT_POSITION : BaseEntity
    {
        //public DC_DEPARTMENT_POSITION()
        //{
        //    DC_WORKPLACE = new HashSet<DC_WORKPLACE>();
        //}

        [Key]
        public int DepartmentPositionId { get; set; }

        public int? DepartmentId { get; set; }

        public int PositionGroupId { get; set; }

        [StringLength(500)]
        public string DepartmentPositionName { get; set; }

        [StringLength(25)]
        public string DepartmentPositionIndex { get; set; }

        public bool? DepartmentPositionStatus { get; set; }

        //public virtual DC_POSITION_GROUP DC_POSITION_GROUP { get; set; }

        //public virtual ICollection<DC_WORKPLACE> DC_WORKPLACE { get; set; }

        //public virtual DC_DEPARTMENT DC_DEPARTMENT { get; set; }
    }
}