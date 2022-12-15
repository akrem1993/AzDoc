using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Admin.Model.EntityModel
{
    public class Structure
    {
        public string Id { get; set; }
        public string ParentID { get; set; }
        public string Name { get; set; }
        public string DeptCount { get; set; }
        public int OrgId { get; set; }
        public int StructType { get; set; }
        public string StructId { get; set; }
       

    }
}
