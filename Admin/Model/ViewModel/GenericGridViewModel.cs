using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Admin.Model.EntityModel;

namespace Admin.Model.ViewModel
{
    public class GenericGridViewModel<T>
    {
        public int TotalCount { get; set; }
        public IEnumerable<T> Items { get; set; }
        public string JsonItems { get; set; }
    }
}
