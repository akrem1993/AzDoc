using BLL.BaseAdapter;
using BLL.Models.Document.EntityModel;
using BLL.Models.Document.ViewModel;
using BLL.Models.WaitingDocs;
using Newtonsoft.Json;
using Repository.Extensions;
using Repository.Infrastructure;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BLL.CoreAdapters
{
    public static  class WaitingDocsAdapter
    {
        //public WaitingDocsAdapter(IUnitOfWork unitOfWork) : base(unitOfWork)
        //{
        //    //  Log.AddInfo("Init DocumentAdapter", "BLL.Adapters.DocumentAdapter");
        //}
        //public DocumentGroupModel GetDocumentGroupModel(int docTypeId)
        //{
        //    Log.AddInfo("DocumentGroupModel", $"docTypeId:{docTypeId}", "BLL.DocumentAdapter.GetDocumentGroupModel");
        //    try
        //    {
        //        var parameters = Extension.Init()
        //       .Add("@docTypeId", docTypeId);
        //        return UnitOfWork.ExecuteProcedure<DocumentGroupModel>("[dbo].[spGetDocGroupTreeName]", parameters)
        //            .FirstOrDefault();
        //    }
        //    catch (Exception ex)
        //    {
        //        Log.AddError(ex.Message, "BLL.DocumentAdapter.GetDocumentGroupModel");
        //        throw;
        //    }

        //}
        public static DocumentGridViewModel GetDocumentGridModel(this IUnitOfWork unitOfWork,  int workPlaceId, int? sendStatusId, int? periodId, int docType, int? pageIndex, int pageSize, List<SqlParameter> searchParams)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@workPlaceId", workPlaceId)
                    .Add("@periodId", periodId)
                    .Add("@sendStatusId", sendStatusId)
                    .Add("@pageIndex", pageIndex)
                    .Add("@pageSize", pageSize)
                   .Add("@docTypeId", docType)
                    .Add("@totalCount", 0, ParameterDirection.Output);
                parameters.AddRange(searchParams);
                var data =unitOfWork.ExecuteProcedure<DocumentGridModel>("[WaitingDocs].[GetDocs]", parameters).ToList();
                return new DocumentGridViewModel
                {
                    TotalCount = 2,
                    Items = data
                };
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                throw;
            }
        }
        public static string GetDocView(this IUnitOfWork unitOfWork, int docId, int workPlaceId, out int docTypeId)
        {
            try
            {
                docTypeId = -1;
                var parameters = Extension.Init()
                    .Add("@docId", docId)
                    .Add("@workPlaceId", workPlaceId)
                    .Add("@docTypeId", 0, direction: ParameterDirection.InputOutput);

                string jsonData = unitOfWork.ExecuteProcedure<string>("[dbo].GetDocView", parameters).Aggregate((i, j) => i + j);
                docTypeId = Convert.ToInt32(parameters.First(x => x.ParameterName == "@docTypeId").Value);
                return jsonData;
            }
            catch (Exception ex)
            {
                throw;
            }
        }
        public static DocInfo GetInfo(this IUnitOfWork unitOfWork, string docNo)
        {
            try
            {

                var parameters = Extension.Init()
                    .Add("@docNo", docNo);

                var data = unitOfWork.ExecuteProcedure<DocInfo>("[WaitingDocs].[GetInfo]", parameters).FirstOrDefault();               
                return data;
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public static int GetDocumentType(this IUnitOfWork unitOfWork, int docId)
        {
            var parameters = Extension.Init().Add("@docId", docId);          
            int data = unitOfWork.ExecuteScalar<int>("select [dbo].[GetDocumentType] (@docId)", parameters);
            return data;
        }
        public static ElectronicDocumentViewModel WaitingDocsElectronicDocument(this IUnitOfWork unitOfWork, int docId, /*int docType, */int workPlaceId)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@docId", docId)
                   // .Add("@docType", docType)
                    .Add("@workPlaceId", workPlaceId);

                string jsonData = unitOfWork.ExecuteProcedure<string>("[WaitingDocs].[spGetElectronicDocument]", parameters).Aggregate((i, j) => i + j);
                return JsonConvert.DeserializeObject<IEnumerable<ElectronicDocumentViewModel>>(jsonData).First();
            }
            catch (Exception exception)
            {
                throw;
            }
        }

        
    }
}
