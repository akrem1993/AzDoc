using Admin.Model.ViewModel.RoleRelatedModels;
using DMSModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Admin.Model.ViewModel
{
    public class RoleDetailsViewModel
    {
        public RoleDetailsViewModel()
        {
            RoleOperations = new List<RoleOperationCustomModel>();
            AllOperations = new List<OperationCustomModel>();
            AllRights = new List<RightCustomModel>();
            AllRightTypes = new List<RightTypesCustom>();
        }

        public bool IsEdit { get; set; }
        public int RoleId { get; set; }
        public string RoleName { get; set; }
        public List<RoleOperationCustomModel> RoleOperations { get; set; }
        public List<OperationCustomModel> AllOperations { get; set; }
        public List<RightCustomModel> AllRights { get; set; }
        public List<RightTypesCustom> AllRightTypes { get; set; }

    }
}
