using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using System.Web.Mvc;
using BLL.BaseAdapter;
using BLL.Models.Document;
using BLL.Models.Document.EntityModel;
using BLL.Models.Document.ViewModel;
using DMSModel;
using LogHelpers;
using Model.DB_Tables;
using Newtonsoft.Json;
using Repository.Extensions;
using Repository.Infrastructure;

namespace BLL.Adapters
{
    public class DocumentAdapter : AdapterBase
    {
        private bool disposed;

        public DocumentAdapter(IUnitOfWork unitOfWork) : base(unitOfWork)
        {
            Log.AddInfo("Init DocumentAdapter", "BLL.Adapters.DocumentAdapter");
        }

        public DocumentGroupModel GetDocumentGroupModel(int docTypeId)
        {
            return DocumentGroupModels.FirstOrDefault(x => x.DocTypeId == docTypeId);
        }

        public IEnumerable<FilterableModel> GetFilterable() =>
            UnitOfWork.ExecuteProcedure<FilterableModel>("[dbo].[spGetFilterable]");

        public List<DocCountModel> GetDocCountModel(int? periodId, int workPlaceId)
        {
            Log.AddInfo("DocCountModel", $"workPlaceId:{workPlaceId}", "BLL.DocumentAdapter.GetDocCountModel");
            try
            {
                var parameters = Extension.Init()
                    .Add("@periodId", periodId)
                    .Add("@workPlaceId", workPlaceId);
                return UnitOfWork.ExecuteProcedure<DocCountModel>("[dbo].[spGetDocCount]", parameters)
                    .ToList();
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "BLL.DocumentAdapter.GetDocCountModel");
                throw;
            }
        }

        public async Task<DocumentGridViewModel> GetDocumentGridModelAsync(int workPlaceId, int? sendStatusId,
            int? periodId, int docType, int? pageIndex, int pageSize, List<SqlParameter> searchParams)
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
                    .Add("@totalCount", 0, ParameterDirection.InputOutput);
                parameters.AddRange(searchParams);
                var data = await UnitOfWork.GetDataFromSpAsync<DocumentGridModel>("[dbo].[spGetDocs]", parameters);

                return new DocumentGridViewModel
                {
                    TotalCount = Convert.ToInt32(parameters.First(p => p.ParameterName == "@totalCount").Value),
                    Items = data
                };
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                throw;
            }
        }

        //public GridViewModel<Models.Document.EntityModel.TaskModel> GetTaskGridModel(int docId, int? @workPlaceId, int? docType)
        //{
        //    try
        //    {
        //        var parameters = Extension.Init()
        //            .Add("@docId", docId)
        //            .Add("@workPlaceId", workPlaceId)
        //            .Add("@docTypeId", docType);

        //        var data = UnitOfWork.ExecuteProcedure<TaskModel>("[dms_insdoc].[spGetTask]", parameters).ToList();
        //        return new GridViewModel<Models.Document.EntityModel.TaskModel>
        //        {
        //            TotalCount = 0,
        //            Items = data
        //        };
        //    }
        //    catch (Exception e)
        //    {
        //        Console.WriteLine(e);
        //        throw;
        //    }
        //}

        public List<ChooseModel> GetDocumentActions(int docId, int workPlaceId, int menuTypeId, int executorId = 0)
        {
            var parameters = Extension.Init()
                .Add("@docId", docId)
                .Add("@executorId", executorId)
                .Add("@workPlaceId", workPlaceId)
                .Add("@menuTypeId", menuTypeId);

            return UnitOfWork.ExecuteProcedure<ChooseModel>("[dbo].[GetDocumentActionsNew]", parameters).ToList();
        }

        public int PostActionOperation(int actionId, int docId, int workPlaceId, string description, out int result,
            int executorId = 0)
        {
            Log.AddInfo("PostActionOperation", $"actionId:{actionId},docId:{docId},workPlaceId:{workPlaceId}",
                "BLL.Adapters.DocumentAdapter.PostActionOperation");
            try
            {
                var parameters = Extension.Init()
                    .Add("@actionId", actionId)
                    .Add("@docId", docId)
                    .Add("@workPlaceId", workPlaceId)
                    .Add("@note", description)
                    .Add("@executorId", executorId)
                    .Add("@result", 0, direction: ParameterDirection.InputOutput);
                UnitOfWork.ExecuteNonQueryProcedure("[dbo].spPostActionOperation", parameters);

                return result = Convert.ToInt32(parameters.FirstOrDefault(p => p.ParameterName == "@result")?.Value);
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "BLL.Adapters.DocumentAdapter.PostActionOperation");
                throw;
            }
        }

        public ElectronicDocumentViewModel ElectronicDocument(int docId, int workPlaceId)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@docId", docId)
                    .Add("@workPlaceId", workPlaceId)
                    .Add("@result", 0, direction: ParameterDirection.InputOutput);
                string jsonData = UnitOfWork.ExecuteProcedure<string>("[dbo].[spGetElectronicDocument]", parameters)
                    .Aggregate((i, j) => i + j);
                return JsonConvert.DeserializeObject<IEnumerable<ElectronicDocumentViewModel>>(jsonData).First();
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public FileInfoModel FileInfoDocument(int docId, int docInfoId)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@docId", docId)
                    .Add("@docInfoId", docInfoId)
                    .Add("@result", 0, direction: ParameterDirection.InputOutput);
                string jsonData = UnitOfWork.ExecuteProcedure<string>("[dbo].[spGetElectronicDocument]", parameters)
                    .Aggregate((i, j) => i + j);
                return JsonConvert.DeserializeObject<IEnumerable<FileInfoModel>>(jsonData).First();
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public IEnumerable<PeriodModel> GetPeriod()
        {
            Log.AddInfo("GetPeriod", "BLL.DocumentAdapter.GetPeriod");
            try
            {
                return UnitOfWork.ExecuteProcedure<PeriodModel>("dbo.spGetPeriod").ToList();
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, " ", "BLL.DocumentdAdapter.GetPeriod");
                throw;
            }
        }

        public IEnumerable<AC_MENU> GetMenu(int id, int kind)
        {
            Log.AddInfo("GetMenu", $"id:{id},kind:{kind}", "BLL.DocumentAdapter.GetMenu");
            try
            {
                var parameters = Extension.Init()
                    .Add("@userId", id)
                    .Add("@kind", kind);
                return UnitOfWork.ExecuteProcedure<AC_MENU>("spMenu", parameters); //?
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, " ", "BLL.DocumentAdapter.GetMenu");
                throw;
            }
        }

        public IEnumerable<SelectListItem> GetAcFilter(int docFilterDocTypeId, int schemaId)
        {
            Log.AddInfo("GetAcFilter", $"docFilterDocTypeId:{docFilterDocTypeId}", "BLL.DocumentAdapter.GetAcFilter");
            try
            {
                var parameters = Extension.Init()
                    .Add("@docFilterDocTypeId", docFilterDocTypeId)
                    .Add("@schemaId", schemaId);
                return UnitOfWork.ExecuteProcedure<AC_FILTER>("spGetACFilter", parameters).ToList()
                    .Select(c => new SelectListItem {Value = c.DocFilterId.ToString(), Text = c.DocFilterCaption});
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "", "BLL.DocumentAdapter.GetAcFilter");

                throw;
            }
        }

        public int CreateDocument(int workPlaceId, int docType)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@docTypeId", docType)
                    .Add("@docDeleted", 3) // docSaveStatus
                    .Add("@workPlaceId", workPlaceId)
                    .Add("@docId", 0, direction: ParameterDirection.InputOutput)
                    .Add("@result", 0, direction: ParameterDirection.InputOutput);
                UnitOfWork.ExecuteNonQueryProcedure("[dbo].[spCreateDocument]", parameters);

                return Convert.ToInt32(parameters.FirstOrDefault(x => x.ParameterName == "@docId")?.Value);
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        /// <summary>
        /// Tuple type istifade etdik cunki jsondan bashqa bize icra muddeti tarixcesi(tarix) lazim idi
        /// </summary>
        /// <param name="docId"></param>
        /// <param name="workPlaceId"></param>
        /// <param name="docTypeId"></param>
        /// <returns></returns>
        public Tuple<string, string> GetDocView(int docId, int workPlaceId, out int docTypeId)
        {
            try
            {
                docTypeId = -1;
                var parameters = Extension.Init()
                    .Add("@docId", docId)
                    .Add("@workPlaceId", workPlaceId)
                    .Add("@docTypeId", 0, direction: ParameterDirection.InputOutput)
                    .Add("@newPlanedHistory", ",", direction: ParameterDirection.Output);

                string jsonData = UnitOfWork.ExecuteProcedure<string>("[dbo].GetDocView", parameters)
                    .Aggregate((i, j) => i + j);
                docTypeId = Convert.ToInt32(parameters.First(x => x.ParameterName == "@docTypeId").Value);
                string newplanedDate = parameters.First(x => x.ParameterName == "@newPlanedHistory").Value.ToString();

                return new Tuple<string, string>(jsonData, newplanedDate);
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public List<AuthorModel> GetAuthorInfo(string data, int next, int workPlaceId, int docTypeId)
        {
            List<AuthorModel> model = null;
            try
            {
                if (next == 8)
                {
                    next = 4;
                }

                var parameters = Extension.Init()
                    .Add("@data", data)
                    .Add("@next", next)
                    .Add("@workPlaceId", workPlaceId)
                    .Add("@docTypeId", docTypeId);

                model = UnitOfWork.ExecuteProcedure<AuthorModel>("[dbo].[GetAuthorInfo]", parameters).ToList();
            }
            catch (Exception ex)
            {
                Log.AddError(
                    ex.Message,
                    "GetJsonData",
                    "/OrgRequest/Document/GetAuthorInfo/data=" + data + "/" + next);
                throw;
            }

            return model;
        }

        public List<SendForInformationViewModel> GetSendForInformation(int senderWorkPlaceId, int docId)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@senderWorkPlaceId", senderWorkPlaceId)
                    .Add("@docId", docId);
                return UnitOfWork
                    .ExecuteProcedure<SendForInformationViewModel>("[dbo].[spSendForInformation]", parameters).ToList();
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                throw;
            }
        }

        public int PostSendForInformationModel(SendForInformationModel model, int senderWorkPlaceId, int docId,
            out int result)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@senderWorkPlaceId", senderWorkPlaceId)
                    .Add("@docId", docId)
                    .Add("@result", 0, direction: ParameterDirection.InputOutput);

                var dataPersons = CustomHelpers.Extensions.ToDataTable(model.Persons ?? new List<Person>());
                if (dataPersons != null)
                    parameters.Add("@persons", dataPersons, "[dbo].[UdttPersons]");
                UnitOfWork.ExecuteNonQueryProcedure("[dbo].[spPostSendForInformation]", parameters);
                return result = Convert.ToInt32(parameters.FirstOrDefault(p => p.ParameterName == "@result")?.Value);
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                throw;
            }
        }

        public int DeleteSendForInformation(int workPlaceId, int docId, out int result)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@workPlaceId", workPlaceId)
                    .Add("@docId", docId)
                    .Add("@result", 0, direction: ParameterDirection.InputOutput);

                UnitOfWork.ExecuteNonQueryProcedure("[dbo].[spSendForInformationDelete]", parameters);
                return result = Convert.ToInt32(parameters.FirstOrDefault(p => p.ParameterName == "@result")?.Value);
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                throw;
            }
        }

        public int GetDocumentType(int docId)
        {
            var parameters = Extension.Init().Add("@docId", docId);
            int data = UnitOfWork.ExecuteScalar<int>("select [dbo].[GetDocumentType] (@docId)", parameters);
            return data;
        }

        public void GetTaskPeriod()
        {
            try
            {
                UnitOfWork.ExecuteNonQueryProcedure("[dms_insdoc].[spPostTaskPeriod]");
            }
            catch
            {
                throw;
            }
        }

        [Conditional("RELEASE")]
        public void ValidateSign(int workPlaceId, int docId)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@workPlaceId", workPlaceId)
                    .Add("@docId", docId);

                UnitOfWork.ExecuteNonQueryProcedure("[dbo].[ValidateSign]", parameters);
            }
            catch (Exception)
            {
                throw;
            }
        }

        public override void Dispose()
        {
            Dispose(true);
            base.Dispose();
        }

        protected virtual void Dispose(bool disposing)
        {
            if (!this.disposed)
            {
                if (disposing)
                {
                    UnitOfWork.Dispose();
                }

                disposed = true;
            }
        }
    }
}