using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Model.Models.GridVIewModel
{
    public class GridModel<T> where T:class 
    {
        public int TotalCount { get; set; }
        public IEnumerable<T> Items { get; set; }
    }
}
