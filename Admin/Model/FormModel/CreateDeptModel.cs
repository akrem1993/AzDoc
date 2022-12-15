using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Admin.Model.FormModel
{
    public class CreateDeptModel
    {
        public int DeptId { get; set; }
        public string DeptName { get; set; }
        public int DeptTypeId { get; set; }
        public int? TopDeptId { get; set; }
        public int? TopOrgId { get; set; }
        public string DeptIndex { get; set; }       

    }
}
