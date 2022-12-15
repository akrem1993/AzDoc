using DMSModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Model.DB_Tables;

namespace Admin.Model.ViewModel
{
    public class PassDepartmentViewModel
    {
        public DC_DEPARTMENT Department { get; set; }
        public List<DC_DEPARTMENT> Departments { get; set; }
        public List<DC_ORGANIZATION> Organisations { get; set; }
        public List<DC_DEPARTMENTTYPE> DeptTypes { get; set; }
        
    }

}
