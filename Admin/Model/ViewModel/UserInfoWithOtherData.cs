using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Admin.Model.EntityModel;

namespace Admin.Model.ViewModel
{
    public class UserInfoWithOtherData
    {
        public UserDetailsWithWorkplaces UserDetailsWithWorkplaces { get; set; }
        public List<RoleViewModel> Roles { get; set; }
        public List<DeptViewModel> DeptViewModels { get; set; }
        public List<DeptPositionViewModel> DeptPositionViewModels { get; set; }
        public List<OrgViewModel> OrgViewModels { get; set; }
        public List<Structure> Structures { get; set; }
    }
}
