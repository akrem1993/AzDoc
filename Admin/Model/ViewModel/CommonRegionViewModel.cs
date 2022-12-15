using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Mvc;

namespace Admin.Model.ViewModel
{
    public class CommonRegionViewModel
    {
        
        public GenericGridViewModel<CountryViewModel> Countries { get; set; }
        public IEnumerable<RegionViewModel> Regions { get; set; }
        public IEnumerable<VillageViewModel> Villages { get; set; }
    }
}
