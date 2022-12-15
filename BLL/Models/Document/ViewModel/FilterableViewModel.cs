using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using BLL.Models.Document.EntityModel;

namespace BLL.Models.Document.ViewModel
{
    public class FilterableViewModel
    {
        public IEnumerable<FilterableModel> FilterableModels { get; set; }
    }
}
