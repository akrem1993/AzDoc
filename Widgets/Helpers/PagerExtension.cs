using System.Collections.Generic;
using System.Linq;

namespace Widgets.Helpers
{
    static public partial class Helper
    {
        static public IQueryable<T> Page<T>(this IQueryable<T> query, int? pageIndex, int pageSize = 20)
            where T : class
        {
            return query.Skip((pageIndex.HasValue ? (pageIndex.Value < 1 ? 1 : pageIndex.Value) - 1 : 0) * pageSize)
                .Take(pageSize);
        }

        static public IEnumerable<T> Page<T>(this IEnumerable<T> collection, int? pageIndex, int pageSize = 20)
            where T : class
        {
            return collection.Skip((pageIndex.HasValue ? (pageIndex.Value < 1 ? 1 : pageIndex.Value) - 1 : 0) * pageSize)
                .Take(pageSize);
        }
    }
}