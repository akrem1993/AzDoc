using Model.DB_Tables;

namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public partial class DC_WORKPLACE : BaseEntity
    {
        public DC_WORKPLACE()
        {
            DM_STEP_USER = new HashSet<DM_STEP_USER>();
            DC_WORKPLACE_ROLE = new HashSet<DC_WORKPLACE_ROLE>();
            //DOC_DIRECTION_TEMPLATE = new HashSet<DOC_DIRECTION_TEMPLATE>();
            DOCS_DIRECTIONS_SEND = new HashSet<DOCS_DIRECTIONS>();
            DOCS_DIRECTIONS_CREATOR = new HashSet<DOCS_DIRECTIONS>();
            AC_SEARCH_COLUMNS = new HashSet<AC_SEARCH_COLUMNS>();
            DC_REQUEST = new HashSet<DC_REQUEST>();
            DC_REQUESTANSWER = new HashSet<DC_REQUESTANSWER>();
            DOCS_EXECUTOR = new HashSet<DOCS_EXECUTOR>();
            DOCS_ADDRESSINFO = new HashSet<DOCS_ADDRESSINFO>();
            DOC_STEP = new HashSet<DOC_STEP>();
        }

        [Key]
        public int WorkplaceId { get; set; }

        public int? WorkplaceUserId { get; set; }

        public int WorkplaceOrganizationId { get; set; }

        public int WorkplaceDepartmentId { get; set; }

        public int WorkplaceDepartmentPositionId { get; set; }

        public virtual string WorkplaceName
        {
            get
            {
                string result = string.Format("{0} {1} {2}",
                                            DC_ORGANIZATION.OrganizationName,
                                            DC_DEPARTMENT.DepartmentName,
                                            DC_DEPARTMENT_POSITION.DepartmentPositionName);
                return result;
            }
        }

        public virtual DC_USER DC_USER { get; set; }

        public virtual DC_DEPARTMENT DC_DEPARTMENT { get; set; }

        public virtual DC_ORGANIZATION DC_ORGANIZATION { get; set; }

        public virtual DC_DEPARTMENT_POSITION DC_DEPARTMENT_POSITION { get; set; }

        public virtual ICollection<DM_STEP_USER> DM_STEP_USER { get; set; }

        public virtual ICollection<DC_WORKPLACE_ROLE> DC_WORKPLACE_ROLE { get; set; }

        //public virtual ICollection<DOC_DIRECTION_TEMPLATE> DOC_DIRECTION_TEMPLATE { get; set; }

        public virtual ICollection<DOCS_DIRECTIONS> DOCS_DIRECTIONS_SEND { get; set; }

        public virtual ICollection<DOCS_DIRECTIONS> DOCS_DIRECTIONS_CREATOR { get; set; }

        public virtual ICollection<DOCS_ADDRESSINFO> DOCS_ADDRESSINFO { get; set; }

        public virtual ICollection<AC_SEARCH_COLUMNS> AC_SEARCH_COLUMNS { get; set; }

        public virtual ICollection<DC_REQUEST> DC_REQUEST { get; set; }

        public virtual ICollection<DC_REQUESTANSWER> DC_REQUESTANSWER { get; set; }

        public virtual ICollection<DOCS_EXECUTOR> DOCS_EXECUTOR { get; set; }
        public virtual ICollection<DOC_STEP> DOC_STEP { get; set; }
    }
}