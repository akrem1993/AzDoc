using Admin.Model.ViewModel.PositionRelatedModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Admin.Model.EntityModel
{
    public class PositionInfo
    {

        public PositionInfo()
        {
            Departments = new List<DepartmentCustomModel>();
            PositionGroups = new List<PosGroupCustomModel>();
        }

        public int DepartmentPositionId { get; set; }
        public int? DepartmentId { get; set; }
        public int PositionGroupId { get; set; }
        public string DepartmentPositionName { get; set; }
        public string DepartmentPositionIndex { get; set; }
        public bool IsEdit { get; set; }


        public List<DepartmentCustomModel> Departments { get; set; }
        public List<PosGroupCustomModel> PositionGroups { get; set; }

    }
}
