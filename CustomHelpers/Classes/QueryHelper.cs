using System.Collections.Generic;
using System.Linq;
using System.Linq.Dynamic;

namespace CustomHelpers.Classes
{
    public static class QueryHelper
    {
        public static IQueryable<Tmodel> PropToExpression<Tmodel>(this IQueryable<Tmodel> query, Dictionary<string, object> searchParams) where Tmodel : class
        {
            List<string> properties = GetClassProperties<Tmodel>();

            if (searchParams.Count == 0)
                return query;

            Dictionary<string, string> keyValues = new Dictionary<string, string>();

            foreach (var property in properties)
            {
                if (searchParams.TryGetValue(property, out var outResult))
                {
                    keyValues.Add($"{property}.Contains(@0)", outResult.ToString());
                }
            }

            foreach (var item in keyValues)
            {
                query.Where(item.Key, item.Value);
            }

            return query;
        }

        public static List<string> GetClassProperties<T>() where T : class
        {
            List<string> propList = new List<string>();

            foreach (var prop in typeof(T).GetProperties())
                propList.Add(prop.Name);

            return propList;
        }
    }
}