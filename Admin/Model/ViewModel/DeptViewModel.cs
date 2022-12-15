using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Admin.Model.ViewModel
{
    public class DeptViewModel
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string ParentName { get; set; }
        public string OrgName { get; set; }
        public string DeptIndex { get; set; }
    }
}
