using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Admin.Model.EntityModel
{
    public class UserWorkPlaceModel
    {
        public string OrganizationShortname { get; set; }
        public string SubOrgName { get; set; }
        public string BranchName { get; set; }
        public string SectorName { get; set; }
        public string DepartmentName { get; set; }
        public string DepartmentPositionName { get; set; }
        public string RoleComment { get; set; }
    }
}
