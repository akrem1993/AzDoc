using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Admin.Model.FormModel
{
    public class CreateOrgModel
    {
        public int OrgId { get; set; }
        public string OrgName { get; set; }
        public int? TopOrgId { get; set; }
        public string OrgIndex { get; set; }
        public  int? MaxUserCount { get; set; }
        public int? IsDeleted { get; set; }
        public string UserLimitComment { get; set; }
       

    }
}
