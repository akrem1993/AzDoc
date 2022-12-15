using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Admin.Model.ViewModel
{
    public class VillageViewModel
    {
        public int? VillageId { get; set; }
        public string VillageName { get; set; }
        public int VillageCode { get; set; }
        public int RegionCode { get; set; }
        public string RegionName { get; set; }
        public bool VillageStatus { get; set; }
        public int CountryCode { get; set; }
    }
}
