using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Admin.Model.EntityModel
{
    public class StructTree
    {
        public List<Structure> Structures { get; set; }
        public string ParentId { get; set; }
    }
}
