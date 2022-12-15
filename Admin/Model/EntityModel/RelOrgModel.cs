using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Admin.Model.EntityModel
{
    public class RelOrgModel
    {
        public int Id { get; set; }
        public int IndividualCode { get; set; }
        public string NameRelOrg { get; set; }
        public bool Status { get; set; }
        public bool IsEdit { get; set; }
    }
}
