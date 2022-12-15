using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Admin.Model.EntityModel
{
    public class UserWorkplaceForUpdate
    {
        public int WorkplaceId { get; set; }
        public int OrganizationId { get; set; }
        public int DepartmentId { get; set; }
        public int? SectorId { get; set; }
        public int DepartmentPositionId { get; set; }
        public string JsonRoleId { get; set; }
    }
}
