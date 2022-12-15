using Admin.Model.ViewModel;
using Admin.Model.ViewModel.RoleRelatedModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Admin.Model.FormModel
{
    public class CreateRoleModel
    {
        public int RoleId { get; set; }
        public string RoleName { get; set; }
        public List<RoleOperationCustomModel> RoleOperations { get; set; }
     
    }
}
