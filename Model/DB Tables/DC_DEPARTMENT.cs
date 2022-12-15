namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public partial class DC_DEPARTMENT : BaseEntity
    {
        //public DC_DEPARTMENT()
        //{
        //    DC_WORKPLACE = new HashSet<DC_WORKPLACE>();
        //    DC_DEPARTMENT_POSITION = new HashSet<DC_DEPARTMENT_POSITION>();
        //}

        [Key]
        public int DepartmentId { get; set; }

        [StringLength(250)]
        public string DepartmentName { get; set; }

        public int? DepartmentOrganization { get; set; }

        public int? DepartmentTopId { get; set; }

        public int? DepartmentTypeId { get; set; }

        public int? DepartmentVirtual { get; set; }

        public int? DepartmentOrderindex { get; set; }

        [StringLength(10)]
        public string DepartmentIndex { get; set; }

        public int? DepartmentCode { get; set; }

        public int? DepartmentTopDepartmentId { get; set; }

        public int? DepartmentDepartmentId { get; set; }

        public int? DepartmentSectionId { get; set; }

        public int? DepartmentSubSectionId { get; set; }

        public bool? DepartmentStatus { get; set; }

        //public virtual DC_DEPARTMENTTYPE DC_DEPARTMENTTYPE { get; set; }

        //public virtual DC_ORGANIZATION DC_ORGANIZATION { get; set; }

        //public virtual ICollection<DC_DEPARTMENT_POSITION> DC_DEPARTMENT_POSITION { get; set; }

        //public virtual ICollection<DC_WORKPLACE> DC_WORKPLACE { get; set; }


    }
}