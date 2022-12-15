using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BLL.Models.Direction.Direction
{
    public class DcWorkplace
    {
      
        public int WorkplaceDepartmentPositionId { get; set; }
        public int DepartmentId { get; set; }
        public int PositionGroupId { get; set; }
        public int WorkplaceOrganizationId { get; set; }
        public int? DepartmentTopDepartmentId { get; set; }
        public int? DepartmentDepartmentId { get; set; }
        public int? DepartmentSectionId { get; set; }
        public int? DepartmentSubSectionId { get; set; }
        public int PositionGroupLevel { get; set; }
        public int WorkplaceDepartmentId { get; set; }
        public int? ChiefWorkplaceId { get; set; }
    }
}
