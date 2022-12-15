using BLL.BaseAdapter;
using BLL.Models.Document;
using BLL.Models.Document.EntityModel;
using CustomHelpers;
using LogHelpers;
using Newtonsoft.Json;
using OrgRequests.Common.Enums;
using OrgRequests.Model.EntityModel;
using OrgRequests.Model.FormModel;
using Repository.Extensions;
using Repository.Infrastructure;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.Mvc;
using DocumentGridModel = OrgRequests.Model.EntityModel.DocumentGridModel;
using DocumentGridViewModel = OrgRequests.Model.ViewModel.DocumentGridViewModel;
using DocumentInfoViewModel = OrgRequests.Model.ViewModel.DocumentInfoViewModel;
using ElectronicDocumentViewModel = OrgRequests.Model.ViewModel.ElectronicDocumentViewModel;
using FileInfoModel = OrgRequests.Model.EntityModel.FileInfoModel;

namespace OrgRequests.Adapters
{
    public class DocumentAdapter : AdapterBase
    {
        public DocumentAdapter(IUnitOfWork unitOfWork) : base(unitOfWork)
        {
        }

        public DocumentGridViewModel GetDocumentGridModel(string docIds, int workPlaceId)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@docIds", docIds)
                    .Add("@workPlace", workPlaceId);

                var data = UnitOfWork.ExecuteProcedure<DocumentGridModel>("[orgrequests].[GetDocs]", parameters).ToList();

                return new DocumentGridViewModel
                {
                    TotalCount = 0,
                    Items = data
                };
            }
            catch
            {
                throw;
            }
        }

        public IEnumerable<DocResult> GetDocResultModel(int workPlaceId, int? periodId, int docType, int? pageIndex, int pageSize, List<SqlParameter> searchParams)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@workPlaceId", workPlaceId)
                    .Add("@periodId", periodId)
                    .Add("@pageIndex", pageIndex)
                    .Add("@pageSize", pageSize)
                    .Add("@docTypeId", docType)
                    .Add("@totalCount", 0, ParameterDirection.InputOutput);

                parameters.AddRange(searchParams);

                return UnitOfWork.ExecuteProcedure<DocResult>("[orgrequests].[GetFilteredDocs]", parameters).ToList();
            }
            catch (Exception e)
            {
                throw;
            }
        }

        public List<ChooseModel> GetChooseModel(int docType, int workPlaceId)
        {
            var parameters = Extension.Init()
                        .Add("@docType", docType)
                        .Add("@workPlaceId", workPlaceId);
            return UnitOfWork.ExecuteProcedure<ChooseModel>("[orgrequests].[NewDocumentLoad]", parameters).ToList();
        }

        public List<RelatedDocModel> GetRelatedDocModel()
        {
            var parameters = Extension.Init()
                .Add("@formTypeId", (int)BasicInformation.RelatedDocument);
            return UnitOfWork.ExecuteProcedure<RelatedDocModel>("[orgrequests].[NewDocumentLoad]", parameters).ToList();
        }
        public DocumentModel GetDocumentModel(int docId)
        {
            var parameters = Extension.Init()
                .Add("@docId", docId)
                .Add("@formTypeId", (int)Document.BasicInformation);
            string jsonData = UnitOfWork.ExecuteProcedure<string>("[orgrequests].[NewDocumentLoad]", parameters).Aggregate((i, j) => i + j);
            return JsonConvert.DeserializeObject<IEnumerable<DocumentModel>>(jsonData).First();
        }
        public int SaveDocument(int workPlaceId, int docType, int? docId, DocumentFormModel model, out int result)
        {
            try
            {
                var dataRelated = model.RelatedDocModels.ToDataTable();
                var dataAuthor = model.AuthorModels.ToDataTable();

                var parameters = Extension.Init()
                        .Add("@operationType", (int)DocSaveStatus.Save)
                        .Add("@workPlaceId", workPlaceId)
                        .Add("@docTypeId", docType)
                        .Add("@docDeleted", (int)DocSaveStatus.Save)
                        .Add("@documentStatusId", (int)DocumentStatus.Registered)
                        .Add("@docEnterDate", model.DocumentModel.DocEnterDate)
                        .Add("@topicTypeId", model.TopicTypeName.Id)
                        .Add("@docNo", model.DocumentModel.DocNo)
                        .Add("@whomAddressId", model.WhomAddress.Id)
                        .Add("@receivedFormId", model.ReceivedForm.Id)
                        .Add("@docDate", model.DocumentModel.DocDate)
                        .Add("@typeOfDocumentId", model.TypeOfDocument.Id)
                        .Add("@executionStatusId", model.ExecutionStatus.Id)
                        .Add("@plannedDate", model.DocumentModel.PlannedDate)
                        .Add("@docIsAppealBoard", model.DocumentModel.DocIsAppealBoard)
                        .Add("@docDuplicateId", model.DocumentModel.DocDuplicateId)
                        .Add("@supervision", model.DocumentModel.Supervision)
                        .Add("@shortContent", model.DocumentModel.ShortContent)
                        .Add("@docId", docId)
                        .Add("@result", 0, ParameterDirection.InputOutput);

                parameters.Add("@related", dataRelated, "[dbo].[UdttRelated]");
                parameters.Add("@author", dataAuthor, "[orgrequests].[UdttAuthor]");

                if (model.TypeOfDocument.Id == 12)
                {
                    var dataTask = model.TaskFormModels.ToDataTable();

                    parameters.Add("@tasks", dataTask, "[orgrequests].[UdttTask]");
                }

                UnitOfWork.ExecuteNonQueryProcedure("[orgrequests].[spDocsOperation]", parameters);

                return result = Convert.ToInt32(parameters.FirstOrDefault(p => p.ParameterName == "@result")?.Value);
            }
            catch
            {
                throw;
            }
        }

        public int EditDocument(int workPlaceId, int docType, int docId, DocumentFormModel model, out int result)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@operationType", (int)OperationType.Update)
                    .Add("@workPlaceId", workPlaceId)
                    .Add("@docTypeId", docType)
                    .Add("@docDeleted", (int)DocSaveStatus.Save)
                    .Add("@documentStatusId", (int)DocumentStatus.Registered)
                    .Add("@docEnterDate", model.DocumentModel.DocEnterDate)
                    .Add("@topicTypeId", model.TopicTypeName.Id)
                    .Add("@docNo", model.DocumentModel.DocNo)
                    .Add("@whomAddressId", model.WhomAddress.Id)
                    .Add("@receivedFormId", model.ReceivedForm.Id)
                    .Add("@docDate", model.DocumentModel.DocDate)
                    .Add("@typeOfDocumentId", model.TypeOfDocument.Id)
                    .Add("@executionStatusId", model.ExecutionStatus.Id)
                    .Add("@plannedDate", model.DocumentModel.PlannedDate)
                    .Add("@docIsAppealBoard", model.DocumentModel.DocIsAppealBoard)
                    .Add("@docDuplicateId", model.DocumentModel.DocDuplicateId)
                    .Add("@supervision", model.DocumentModel.Supervision)
                    .Add("@shortContent", model.DocumentModel.ShortContent)
                    .Add("@docId", docId)
                    .Add("@result", 0, direction: ParameterDirection.InputOutput);

                var dataRelated = model.RelatedDocModels.ToDataTable();
                var dataAuthor = model.AuthorModels.ToDataTable();

                if (model.TypeOfDocument.Id == 12)
                {
                    var dataTask = model.TaskFormModels.ToDataTable();

                    parameters.Add("@tasks", dataTask, "[orgrequests].[UdttTask]");
                }

                parameters.Add("@related", dataRelated, "[dbo].[UdttRelated]");

                parameters.Add("@author", dataAuthor, "[orgrequests].[UdttAuthor]");

                UnitOfWork.ExecuteNonQueryProcedure("[orgrequests].[spDocsOperation]", parameters);

                return result = Convert.ToInt32(parameters.FirstOrDefault(p => p.ParameterName == "@result")?.Value);
            }
            catch
            {
                throw;
            }
        }

        public int DeleteDocument(int rowId, int formTypeId, out int result)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@operationType", (int)OperationType.Delete)
                    .Add("@rowId", rowId)
                    .Add("@formTypeId", formTypeId)
                    .Add("@result", 0, direction: ParameterDirection.InputOutput);

                UnitOfWork.ExecuteNonQueryProcedure("[orgrequests].[spDocsOperation]", parameters);

                return result = Convert.ToInt32(parameters.FirstOrDefault(p => p.ParameterName == "@result")?.Value);
            }
            catch (Exception)
            {
                throw;
            }
        }

        public DocumentInfoViewModel DocInfo(int docId, int workPlaceId)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@docId", docId)
                    .Add("@workPlaceId", workPlaceId);

                string jsonData = UnitOfWork.ExecuteProcedure<string>("[orgrequests].spGetDocView", parameters).Aggregate((i, j) => i + j);
                return JsonConvert.DeserializeObject<IEnumerable<DocumentInfoViewModel>>(jsonData).First();
            }
            catch (Exception exception)
            {
                throw;
            }
        }

        public ElectronicDocumentViewModel ElectronicDocument(int docId, int docType, int workPlaceId,int executorId)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@docId", docId)
                    .Add("@docType", docType)
                    .Add("@workPlaceId", workPlaceId)
                    .Add("@executorId", executorId);

                string jsonData = UnitOfWork.ExecuteProcedure<string>("[orgrequests].[spGetElectronicDocument]", parameters).Aggregate((i, j) => i + j);
                return JsonConvert.DeserializeObject<IEnumerable<ElectronicDocumentViewModel>>(jsonData).First();
            }
            catch (Exception exception)
            {
                throw;
            }
        }

        public List<TaskModel> GetTaskModel(int docId, int docType)
        {
            Log.AddInfo("GetTaskModel", $"docId:{docId},docType:{docType}", "InsDoc.Adapters.DocumentAdapter.GetTaskModel");
            try
            {
                var parameters = Extension.Init()
                .Add("@docId", docId)
                .Add("@docType", docType)
                .Add("@formTypeId", (int)Document.DocumentInformation);

                return UnitOfWork.ExecuteProcedure<TaskModel>("[orgrequests].[NewDocumentLoad]", parameters).ToList();
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "InsDoc.Adapters.DocumentAdapter.GetTaskModel");
                throw;
            }
        }

        public FileInfoModel ElectronicDocument(int docInfoId)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@docInfoId", docInfoId);

                string jsonData = UnitOfWork.ExecuteProcedure<string>("[orgrequests].[spGetElectronicDocument]", parameters).Aggregate((i, j) => i + j);
                return JsonConvert.DeserializeObject<IEnumerable<FileInfoModel>>(jsonData).First();
            }
            catch (Exception exception)
            {
                throw;
            }
        }

        public List<int> AddNewAuthor(FormCollection form)
        {
            try
            {
                var parameters = new List<SqlParameter>();
                foreach (var key in form.AllKeys)
                {
                    parameters.Add("@" + key, form["" + key + ""]);
                }

                parameters.Add("@authorId", 0, direction: ParameterDirection.InputOutput);
                parameters.Add("@authorOrganizationId", 0, direction: ParameterDirection.InputOutput);
                parameters.Add("@result", 0, direction: ParameterDirection.InputOutput);

                UnitOfWork.ExecuteNonQueryProcedure("[dbo].[AddNewAuthor]", parameters);

                var list = new List<int>
                {
                    Convert.ToInt32(parameters.First(p => p.ParameterName == "@authorId").Value==DBNull.Value?-1:parameters.First(p => p.ParameterName == "@authorId").Value),
                    Convert.ToInt32(parameters.First(p => p.ParameterName == "@authorOrganizationId").Value==DBNull.Value?-1:parameters.First(p => p.ParameterName == "@authorOrganizationId").Value)
                };

                return Convert.ToInt32(parameters.FirstOrDefault(p => p.ParameterName == "@result")?.Value) == 1
                    ? list
                    : null;
            }
            catch (Exception ex)
            {
                Log.AddError(
                    ex.Message,
                    "AddNewAuthor",
                    "/OrgRequest/Document/AddNewAuthor");
                throw;
            }
        }
    }
}