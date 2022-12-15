using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using BLL.BaseAdapter;
using BLL.Models.DocGrid;
using BLL.Models.Document;
using Newtonsoft.Json;
using Repository.Extensions;
using Repository.Infrastructure;

namespace BLL.CoreAdapters
{
    public class DocGridAdapter : AdapterBase
    {
        public DocGridAdapter(IUnitOfWork unitOfWork) : base(unitOfWork)
        {
        }

        public async Task<DocGridViewModel<T>> GetDocsAsync<T>(int workPlaceId,
            int? periodId,
            int docType,
            int pageIndex,
            int pageSize,
            List<SqlParameter> searchParams)
        {
            int skipped = pageSize * ((pageIndex == 0 ? 1 : pageIndex) - 1);


            var resultModel = await GetFilteredDocsAsync(workPlaceId,
                periodId,
                docType,
                pageIndex,
                pageSize,
                searchParams).ConfigureAwait(false);

            resultModel = resultModel
                .OrderByDescending(p => p.DocId)
                .ThenBy(p => p.ExecutorReadStatus)
                .GroupBy(x => x.DocId)
                .Select(x => x.FirstOrDefault());

            var totalCount = resultModel.Count();

            resultModel = resultModel.Skip(skipped).Take(pageSize);

            var gridModel = await GetDocumentGridModelAsync<T>(resultModel.Select(p => p.DocId), workPlaceId, docType);

            return new DocGridViewModel<T>
            {
                Items = gridModel,
                TotalCount = totalCount
            };
        }


        public async Task<DocGridViewModel<T>> GetDocsAsyncNew<T>(int workPlaceId,
            int? periodId,
            int docType,
            int pageIndex,
            int pageSize,
            List<SqlParameter> searchParams)
        {
            int skipped = pageSize * ((pageIndex == 0 ? 1 : pageIndex) - 1);

            var parameters = Extension.Init()
                .Add("@workPlace", workPlaceId)
                .Add("@periodId", periodId)
                .Add("@pageSize", pageSize)
                .Add("@skip", skipped)
                .Add("@totalCount", 0, ParameterDirection.InputOutput);

            parameters.AddRange(searchParams);

            var gridModel = await UnitOfWork.GetDataFromSpAsync<T>($"[{GetDocSchema(docType)}].[GetDocsNew]",
                parameters);

            return new DocGridViewModel<T>
            {
                Items = gridModel,
                TotalCount = (int)parameters.First(x => x.ParameterName=="@totalCount").Value
            };
        }


        public IEnumerable<DocResult> GetFilteredDocs(int workPlaceId, int? periodId, int docType, int? pageIndex,
            int pageSize, List<SqlParameter> searchParams)
        {
            var parameters = Extension.Init()
                .Add("@workPlaceId", workPlaceId)
                .Add("@periodId", periodId)
                .Add("@pageIndex", pageIndex)
                .Add("@pageSize", pageSize)
                .Add("@docTypeId", docType)
                .Add("@totalCount", 0, ParameterDirection.InputOutput);

            parameters.AddRange(searchParams);

            return UnitOfWork.GetDataFromSP<DocResult>($"[{GetDocSchema(docType)}].[GetFilteredDocs]", parameters)
                .ToList();
        }

        public async Task<IEnumerable<DocResult>> GetFilteredDocsAsync(int workPlaceId, int? periodId, int docType,
            int? pageIndex, int pageSize, List<SqlParameter> searchParams)
        {
            var parameters = Extension.Init()
                .Add("@workPlaceId", workPlaceId)
                .Add("@periodId", periodId)
                .Add("@pageIndex", pageIndex)
                .Add("@pageSize", pageSize)
                .Add("@docTypeId", docType)
                .Add("@totalCount", 0, ParameterDirection.InputOutput);

            parameters.AddRange(searchParams);

            return await UnitOfWork.GetDataFromSpAsync<DocResult>($"[{GetDocSchema(docType)}].[GetFilteredDocs]",
                parameters);
        }


        public IEnumerable<T> GetDocumentGridModel<T>(IEnumerable<int> docs, int workPlaceId, int docType)
        {
            var docIds = JsonConvert.SerializeObject(docs);

            var data = UnitOfWork
                .GetDataFromSP<T>($"[{GetDocSchema(docType)}].[GetDocs]", new {docIds, workPlace = workPlaceId})
                .ToList();

            return data;
        }

        public async Task<IEnumerable<T>> GetDocumentGridModelAsync<T>(IEnumerable<int> docs, int workPlaceId,
            int docType)
        {
            var docIds = JsonConvert.SerializeObject(docs);

            var data = await UnitOfWork.GetDataFromSpAsync<T>($"[{GetDocSchema(docType)}].[GetDocs]",
                new {docIds, workPlace = workPlaceId});

            return data;
        }
    }
}