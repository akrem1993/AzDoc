using BLL.Common.Enums;
using BLL.Models.Document.EntityModel;
using Newtonsoft.Json;
using ORM.Context;
using Repository.UnitOfWork;
using System.Collections.Generic;
using System.Linq;

namespace AzDoc.Helpers
{
    public static class CacheHelper
    {
        private static readonly IEnumerable<FilterableModel> FilterModels;
        static CacheHelper()
        {
            var unitOfWork = new EFUnitOfWork<DMSContext>();

            using (BLL.Adapters.DocumentAdapter adapter = new BLL.Adapters.DocumentAdapter(unitOfWork))
            {
                FilterModels = adapter.GetFilterable();
            }
        }

        public static string GetFilter(DocFilter filter) => JsonConvert.SerializeObject(FilterModels.Where(f => f.FormTypeId == (int)filter).OrderBy(f => f.text));

        public static string GetUserStatuses()
        {
            return JsonConvert.SerializeObject(new List<dynamic>() { new { text = "Aktivdir", value = "1" }, new { text = "Aktiv deyil", value = "0" } });
        }

    }
}