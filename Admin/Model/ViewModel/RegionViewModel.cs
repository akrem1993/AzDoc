using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Admin.Model.ViewModel
{
    public class RegionViewModel
    {
        public int? RegionId { get; set; }
        public string RegionName { get; set; }
        public int RegionCode { get; set; }
        public int RegionCountryCode { get; set; }
        public byte RegionStatus { get; set; }
    }
}
