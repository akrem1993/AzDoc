using Admin.Model.ViewModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace Admin.Model.EntityModel
{
    public class UserWorkPlace : UserWorkplaceForUpdate
    {

        public UserWorkPlace()
        {
            Roles = new List<RoleViewModel>();
            AllRoles = new List<RoleViewModel>();
            Organisations = new List<OrgViewModel>();
            Departments = new List<DeptViewModel>();
            Sectors = new List<DeptViewModel>();
            DepartmentPositions = new List<DeptPositionViewModel>();

        }

        public List<RoleViewModel> Roles { get; set; }
        public List<RoleViewModel> AllRoles { get; set; }
        public List<int> RoleId { get; set; }
        public List<OrgViewModel> Organisations { get; set; }
        public List<DeptViewModel> Departments { get; set; }
        public List<DeptViewModel> Sectors { get; set; }
        public List<DeptPositionViewModel> DepartmentPositions { get; set; }
        public bool? WorkPlaceStatus { get; set; }

        public string DepartmentName { get; set; }




    }
}
