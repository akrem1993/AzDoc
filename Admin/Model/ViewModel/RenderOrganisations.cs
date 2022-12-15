using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Admin.Model.ViewModel
{
    public class RenderOrganisations
    {
        public int Id { get; set; }
        public string OrganisationShortname { get; set; }
        public string OrderIndex { get; set; }
        public string Status { get; set; }
        public byte IsEdit { get; set; }
        public int? IsDeleted { get; set; }
    }
}
