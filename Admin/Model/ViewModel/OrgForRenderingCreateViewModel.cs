using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Admin.Model.ViewModel
{
   public class OrgForRenderingCreateViewModel
    {
        public int Id { get; set; }
        public string OrganisationShortname { get; set; }
        public string OrderIndex { get; set; }
        public bool Status { get; set; }
        public bool IsEdit { get; set; }
        public int? IsDeleted { get; set; }
    }
}
