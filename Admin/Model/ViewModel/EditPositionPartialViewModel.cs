using Admin.Model.EntityModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Admin.Model.ViewModel
{
    public class EditPositionPartialViewModel
    {
        public UserWorkPlace UserWorkPlace { get; set; }
        public List<RoleViewModel> Roles { get; set; }
        public List<DeptViewModel> DeptViewModels { get; set; }
        public List<DeptViewModel> SectosViewModels { get; set; }
        public List<DeptPositionViewModel> DeptPositionViewModels { get; set; }
        public List<OrgViewModel> OrgViewModels { get; set; }
        public int PositionIndex { get; set; }
        public bool IsInitial { get; set; }

        public List<Structure> Structures { get; set; }
    }
}
