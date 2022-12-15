using BLL.BaseAdapter;
using Model.DB_Views;
using Model.ModelInterfaces;
using Model.Models.GridVIewModel;
using Repository.Infrastructure;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BLL.Adapters
{
    public class GridViewAdapter : AdapterBase
    {
        public GridViewAdapter(IUnitOfWork unitOfWork):base(unitOfWork) {}

        public GridModel<T> GetDocs<T>(FilterModel<T> filter) where T : class, IRoleFilter
        {
            var repos = UnitOfWork.GetRepository<T>();

            var queryAllDocs = repos.GetAll(filter.FilterPredicate)
                .Where(x => x.DocPeriodId == filter.PeriodId)
                .GroupBy(x => x.DocId)
                .Select(x => x.FirstOrDefault());

            var docQuery = queryAllDocs
                .OrderByDescending(x => x.DirectionInsertedDate)
                .ThenBy(x => x.ExecutorReadStatus)
                .Skip(filter.Skip)
                .Take(filter.Take);

            var docs = docQuery.ToList();
            int docCount = docs.Count();// queryAllDocs.Count();

            docs.ForEach(x =>
            {
                if (x.ExecutorWorkplaceId != filter.WorkPlaceId)
                {
                    x.ExecutorControlStatus = true;
                    x.ExecutorReadStatus = true;
                }
            });

            return new GridModel<T> { Items = docs, TotalCount = docCount };
        }
    }
}
