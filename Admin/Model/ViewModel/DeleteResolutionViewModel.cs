using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Admin.Model.ViewModel
{
    public class DeleteResolutionViewModel
    {
        
        public int TotalCount { get; set; }
        public IEnumerable<Admin.Model.ViewModel.DeleteResolutionModel> Items { get; set; }

    }
}
