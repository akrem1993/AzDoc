using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BLL.Models.Direction.Common
{
    public class GridViewModel<T>
        where T : class
    {
        public int TotalCount { get; set; }
        public IEnumerable<T> Items { get; set; }
        public dynamic MyProperty { get; set; }
    }
}
