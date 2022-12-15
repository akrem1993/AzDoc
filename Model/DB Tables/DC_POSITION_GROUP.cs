namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public partial class DC_POSITION_GROUP : BaseEntity
    {
        //public DC_POSITION_GROUP()
        //{
        //    DC_DEPARTMENT_POSITION = new HashSet<DC_DEPARTMENT_POSITION>();
        //    DM_STEP = new HashSet<DM_STEP>();
        //    DM_NEXT_STEP = new HashSet<DM_STEP>();
        //    DOC_STEP = new HashSet<DOC_STEP>();
        //    DOC_STEP_NEXT = new HashSet<DOC_STEP>();
        //}

        [Key]
        public int PositionGroupId { get; set; }

        [StringLength(100)]
        public string PositionGroupName { get; set; }

        public string PositionGroupSql { get; set; }

        public int? PositionGroupLevel { get; set; }

        public bool? PositionGroupStatus { get; set; }

        // Rehber olub olmamasini yoxlamaq ucun
        public bool? PositionIsDirector { get; set; }

        //public virtual ICollection<DC_DEPARTMENT_POSITION> DC_DEPARTMENT_POSITION { get; set; }

        //public virtual ICollection<DM_STEP> DM_STEP { get; set; }

        //public virtual ICollection<DM_STEP> DM_NEXT_STEP { get; set; }

        //public virtual ICollection<DOC_STEP> DOC_STEP { get; set; }

        //public virtual ICollection<DOC_STEP> DOC_STEP_NEXT { get; set; }
    }
}