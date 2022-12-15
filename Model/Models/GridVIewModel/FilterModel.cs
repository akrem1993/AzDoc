using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace Model.Models.GridVIewModel
{
    public class FilterModel<T> where T : class
    {
        public int Skip { get; set; }
        public int Take { get; set; }
        public int PeriodId { get; set; }
        public int WorkPlaceId { get; set; }

        public Expression<Func<T, bool>> FilterPredicate { get; set; } 
    }
}
