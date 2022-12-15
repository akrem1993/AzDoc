using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Admin.Model.EntityModel
{
    public class UserGridModel
    {
        public int UserId { get; set; }
        public string UserName { get; set; }
        public string PersonnelName { get; set; }
        public string PersonnelSurname { get; set; }
        public string PersonnelLastname { get; set; }
        public string UserStatus { get; set; }
        public string OrganizationShortname { get; set; }
        public string DepartmentName { get; set; }
        public string BranchName { get; set; }
        public string SectorName { get; set; }
        public string SubOrgName { get; set; }
        public string DepartmentPositionName { get; set; }

    }
}
