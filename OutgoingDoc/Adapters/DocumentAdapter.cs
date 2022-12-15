using BLL.Models.Direction.Common;
using BLL.Models.Document;
using LogHelpers;
using Newtonsoft.Json;
using OutgoingDoc.Enum;
using OutgoingDoc.Model.EntityModel;
using OutgoingDoc.Model.FormModel;
using OutgoingDoc.Model.ViewModel;
using Repository.Extensions;
using Repository.Infrastructure;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.Mvc;
using DocumentInfoViewModel = OutgoingDoc.Model.ViewModel.DocumentInfoViewModel;
using ElectronicDocumentViewModel = OutgoingDoc.Model.ViewModel.ElectronicDocumentViewModel;

namespace OutgoingDoc.Adapters
{
    public static class DocumentAdapter
    {
        public static GridViewModel<DocumentGridModel> GetDocumentGridModel(this IUnitOfWork unitOfWork, string docIds,int workPlaceId)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@docIds", docIds)
                    .Add("@workPlace", workPlaceId);

                var data = unitOfWork.ExecuteProcedure<DocumentGridModel>("[outgoingdoc].[GetDocs]", parameters).ToList();

                return new GridViewModel<DocumentGridModel>
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

        public static IEnumerable<DocResult> GetDocResultModel(this IUnitOfWork unitOfWork, int workPlaceId, int? periodId, int docType, int? pageIndex, int pageSize, List<SqlParameter> searchParams)
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

                return unitOfWork.ExecuteProcedure<DocResult>("[outgoingdoc].[GetFilteredDocs]", parameters).ToList();
            }
            catch (Exception e)
            {
                throw;
            }
        }

        public static IEnumerable<T> GetChooseModel<T>(this IUnitOfWork unitOfWork, int docType, int workPlaceId) where T : class
        {
            try
            {
                var parameters = Extension.Init()
                        .Add("@docType", docType)
                        .Add("@workPlaceId", workPlaceId);
                var data = unitOfWork.ExecuteProcedure<T>("[outgoingdoc].[spAddNewDocumentLoad]", parameters);
                return data;
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public static int SaveDocument(this IUnitOfWork unitOfWork, int workPlaceId, int docType, DocumentFormModel model, int? docId, out int result)
        {
            try
            {
                var parameters = Extension.Init()

                        .Add("@operationType", (int)DocSaveStatus.Save)
                        .Add("@workPlaceId", workPlaceId)
                        .Add("@docTypeId", docType)
                        .Add("@docDeleted", (int)DocSaveStatus.Save)
                        .Add("@documentStatusId", (int)DocumentStatus.Draft)
                        .Add("@typeOfDocumentId", model.TypeOfDocument.Id)
                        .Add("@signatoryPersonId", model.SignatoryPerson.Id)
                        .Add("@sendFormId", model.SendForm.Id)
                        .Add("@docEnterDate", model.DocumentModel.DocEnterDate)
                        .Add("@shortContent", model.DocumentModel.ShortContent)
                        .Add("@docId", docId)
                        .Add("@vizaDataJson", model.VizaDataJson)
                        .Add("@result", 0, direction: ParameterDirection.InputOutput);
                var dataWhomAddress = CustomHelpers.Extensions.ToDataTable(model.WhomAddressModels ?? new List<WhomAddressModel>());
                var dataRelated = CustomHelpers.Extensions.ToDataTable(model.RelatedDocModels ?? Enumerable.Empty<RelatedDocModel>());
                var dataAuthor = CustomHelpers.Extensions.ToDataTable(model.AuthorModels ?? new List<AuthorModel>());
                var dataAnswer = CustomHelpers.Extensions.ToDataTable(model.AnswerByOutDocModels ?? new List<AnswerByOutDocModel>());
                if (dataWhomAddress != null)
                    parameters.Add("@whomAddress", dataWhomAddress, "[serviceletters].[UdttWhomAddress]");
                if (dataRelated != null)
                    parameters.Add("@related", dataRelated, "[dbo].[UdttRelated]");
                if (dataAuthor != null)
                    parameters.Add("@author", dataAuthor, "[dbo].[UdttAuthor]");
                if (dataAnswer != null)
                    parameters.Add("@answer", dataAnswer, "[dbo].[UdttAnswer]");
                unitOfWork.ExecuteNonQueryProcedure("[outgoingdoc].[spDocsOperation]", parameters);

                return result = Convert.ToInt32(parameters.FirstOrDefault(p => p.ParameterName == "@result")?.Value);
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public static DocumentViewModel GetOutgoingDocViewModel(this IUnitOfWork unitOfWork, int docType, int workPlaceId)
        {
            var parameters = Extension.Init()
                      .Add("@docType", docType)
                      .Add("@workPlaceId", workPlaceId);
            

            var chooseList = unitOfWork.ExecuteProcedure<ChooseModel>("[outgoingdoc].[spAddNewDocumentLoad]", parameters);
            var model = new DocumentViewModel();
            model.ChiefModel = GetChiefModel(unitOfWork,workPlaceId);
            model.WhomAddresses = chooseList.Where(l => l.FormTypeId == (int)BasicInformation.WhomAddress);
            model.SendForms = chooseList.Where(l => l.FormTypeId == (int)BasicInformation.SendForm);
            model.TypeOfDocuments = chooseList.Where(l => l.FormTypeId == (int)BasicInformation.TypeOfDocument);
            model.ExecutionStatuses = chooseList.Where(l => l.FormTypeId == (int)BasicInformation.ExecutionStatus);
            model.SignatoryPersons = chooseList.Where(l => l.FormTypeId == (int)BasicInformation.SignatoryPerson);
            model.IntWhomAddresses = chooseList.Where(l => l.FormTypeId == (int)BasicInformation.IntWhomAddress);

            return model;
        }



        public static DocumentViewModel GetOutgoingDocViewModel(this IUnitOfWork unitOfWork, int docType, int workPlaceId, int docId)
        {
            var parameters = Extension.Init()
                      .Add("@docType", docType)
                      .Add("@workPlaceId", workPlaceId);

            var chooseList = unitOfWork.ExecuteProcedure<ChooseModel>("[outgoingdoc].[spAddNewDocumentLoad]", parameters);
            var model = new DocumentViewModel();

            model.WhomAddresses = chooseList.Where(l => l.FormTypeId == (int)BasicInformation.WhomAddress);
            model.IntWhomAddresses = chooseList.Where(l => l.FormTypeId == (int)BasicInformation.IntWhomAddress);
            model.SendForms = chooseList.Where(l => l.FormTypeId == (int)BasicInformation.SendForm);
            model.TypeOfDocuments = chooseList.Where(l => l.FormTypeId == (int)BasicInformation.TypeOfDocument);
            model.ExecutionStatuses = chooseList.Where(l => l.FormTypeId == (int)BasicInformation.ExecutionStatus);
            model.SignatoryPersons = chooseList.Where(l => l.FormTypeId == (int)BasicInformation.SignatoryPerson);
            model.ResultList = chooseList.Where(l => l.FormTypeId == (int)BasicInformation.Result);
            model.DocumentModel = GetDocumentModel(unitOfWork, docId);

            return model;
        }

        public static DocumentViewModel GetOutgoingDocViewModel(this IUnitOfWork unitOfWork, int docType, int workPlaceId, int docId, int actionId)
        {
            var parameters = Extension.Init()
                      .Add("@docType", docType)
                      .Add("@workPlaceId", workPlaceId);

            var chooseList = unitOfWork.ExecuteProcedure<ChooseModel>("[outgoingdoc].[spAddNewDocumentLoad]", parameters);
            var model = new DocumentViewModel();
            model.ChiefModel = GetChiefModel(unitOfWork, workPlaceId);
            model.WhomAddresses = chooseList.Where(l => l.FormTypeId == (int)BasicInformation.WhomAddress);
            model.SendForms = chooseList.Where(l => l.FormTypeId == (int)BasicInformation.SendForm);
            model.TypeOfDocuments = chooseList.Where(l => l.FormTypeId == (int)BasicInformation.TypeOfDocument);
            model.ExecutionStatuses = chooseList.Where(l => l.FormTypeId == (int)BasicInformation.ExecutionStatus);
            model.SignatoryPersons = chooseList.Where(l => l.FormTypeId == (int)BasicInformation.SignatoryPerson);
            model.ResultList = chooseList.Where(l => l.FormTypeId == (int)BasicInformation.Result);
            model.IntWhomAddresses = chooseList.Where(l => l.FormTypeId == (int)BasicInformation.IntWhomAddress);
            if (actionId == 13)
            {
                model.DocumentModel = GetAnswerByOutDocModel(unitOfWork, docId);
            }
            else if (actionId == 14)
            {
                model.DocumentModel = GetRelatedDocOutgoingDocModel(unitOfWork, docId);
            }

            return model;
        }

        public static DocumentModel GetRelatedDocOutgoingDocModel(this IUnitOfWork unitOfWork, int docId)
        {
            var parameters = Extension.Init()
                .Add("@docId", docId)
                .Add("@formTypeId", (int)Enum.Document.RelateDocumentByOutDoc);
            string jsonData = unitOfWork.ExecuteProcedure<string>("[outgoingdoc].[spAddNewDocumentLoad]", parameters).Aggregate((i, j) => i + j);
            return JsonConvert.DeserializeObject<IEnumerable<DocumentModel>>(jsonData).First();
        }

        public static DocumentModel GetAnswerByOutDocModel(this IUnitOfWork unitOfWork, int docId)
        {
            var parameters = Extension.Init()
                .Add("@docId", docId)
                .Add("@formTypeId", (int)Enum.Document.AnswerByOutDoc);
            string jsonData = unitOfWork.ExecuteProcedure<string>("[outgoingdoc].[spAddNewDocumentLoad]", parameters).Aggregate((i, j) => i + j);
            return JsonConvert.DeserializeObject<IEnumerable<DocumentModel>>(jsonData).First();
        }

        public static DocumentModel GetDocumentModel(this IUnitOfWork unitOfWork, int docId)
        {
            var parameters = Extension.Init()
                .Add("@docId", docId)
                .Add("@formTypeId", (int)Enum.Document.BasicInformation);
            string jsonData = unitOfWork.ExecuteProcedure<string>("[outgoingdoc].[spAddNewDocumentLoad]", parameters).Aggregate((i, j) => i + j);
            return JsonConvert.DeserializeObject<IEnumerable<DocumentModel>>(jsonData).First();
        }
        public static ChiefModel GetChiefModel(this IUnitOfWork unitOfWork,int workplaceid)
        {
            var parameters = Extension.Init()
                .Add("@workplaceid", workplaceid);
            string jsonData = unitOfWork.ExecuteProcedure<string>("[dbo].[spAddExecutorChiefsLast]", parameters).Aggregate((i, j) => i + j);
            return JsonConvert.DeserializeObject<IEnumerable<ChiefModel>>(jsonData).First();
        }

        public static DocumentInfoViewModel DocInfo(this IUnitOfWork unitOfWork, int docId, int docType, int workPlaceId)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@docId", docId)
                    .Add("@docType", docType)
                    .Add("@workPlaceId", workPlaceId);
                string jsonData = unitOfWork.ExecuteProcedure<string>("[outgoingdoc].[spGetDocView]", parameters).Aggregate((i, j) => i + j);
                return JsonConvert.DeserializeObject<IEnumerable<DocumentInfoViewModel>>(jsonData).First();
            }
            catch (Exception exception)
            {
                throw new Exception(exception.InnerException?.ToString());
            }
        }

        public static ElectronicDocumentViewModel ElectronicDocument(this IUnitOfWork unitOfWork, int docId, int docType, int workPlaceId, int executorId)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@docId", docId)
                    .Add("@docType", docType)
                    .Add("@workPlaceId", workPlaceId)
                    .Add("@executorId", executorId);

                string jsonData = unitOfWork.ExecuteProcedure<string>("[outgoingdoc].[spGetElectronicDocument]", parameters).Aggregate((i, j) => i + j);
                return JsonConvert.DeserializeObject<IEnumerable<ElectronicDocumentViewModel>>(jsonData).First();
            }
            catch (Exception exception)
            {
                throw;
            }
        }

        public static FileInfoModel ElectronicDocument(this IUnitOfWork unitOfWork, int docInfoId)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@docInfoId", docInfoId);

                string jsonData = unitOfWork.ExecuteProcedure<string>("[outgoingdoc].[spGetElectronicDocument]", parameters).Aggregate((i, j) => i + j);
                return JsonConvert.DeserializeObject<IEnumerable<FileInfoModel>>(jsonData).First();
            }
            catch (Exception exception)
            {
                throw;
            }
        }

        public static List<ChooseModel> GetActionNameModel(this IUnitOfWork unitOfWork, /*int docType,*/ int docId, int workPlaceId, int menuTypeId)
        {
            var parameters = Extension.Init()
                //.Add("@docTypeId", docType)
                .Add("@docId", docId)
                .Add("@workPlaceId", workPlaceId)
                .Add("@menuTypeId", menuTypeId);

            return unitOfWork.ExecuteProcedure<ChooseModel>("[dbo].[GetDocumentActions]", parameters).ToList();
        }

        public static bool DeleteAnswerDoc(this IUnitOfWork unitOfWork, int answerDocId, int currentDocId)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@answerDocId", answerDocId)
                    .Add("@currentDocId", currentDocId)
                    .Add("@result", 0, direction: ParameterDirection.InputOutput);

                unitOfWork.ExecuteNonQueryProcedure("[dbo].[DeleteAnswerDoc]", parameters);

                return Convert.ToInt32(parameters.FirstOrDefault(p => p.ParameterName == "@result")?.Value) == 1;
            }
            catch (Exception ex)
            {
                throw;
            }

            return false;
        }

        public static int EditDocument(this IUnitOfWork unitOfWork, int workPlaceId, int docType, int docId, DocumentFormModel model, out int result)
        {
            try
            {
                var parameters = Extension.Init()

                        .Add("@operationType", (int)OperationType.Update)
                        .Add("@workPlaceId", workPlaceId)
                        .Add("@docTypeId", docType)
                        .Add("@docDeleted", (int)DocSaveStatus.Save)
                        .Add("@documentStatusId", (int)DocumentStatus.Registered)
                        .Add("@typeOfDocumentId", model.TypeOfDocument?.Id)
                        .Add("@signatoryPersonId", model.SignatoryPerson?.Id)
                         .Add("@sendFormId", model.SendForm?.Id)
                        .Add("@shortContent", model.DocumentModel?.ShortContent)
                        .Add("@docEnterDate", model.DocumentModel?.DocEnterDate)
                        .Add("@docId", docId)
                        .Add("@vizaDataJson", model.VizaDataJson)
                        .Add("@result", 0, direction: ParameterDirection.InputOutput);

                var dataWhomAddress = CustomHelpers.Extensions.ToDataTable(model.WhomAddressModels ?? new List<WhomAddressModel>());
                var dataRelated = CustomHelpers.Extensions.ToDataTable(model.RelatedDocModels ?? Enumerable.Empty<RelatedDocModel>());
                var dataAuthor = CustomHelpers.Extensions.ToDataTable(model.AuthorModels ?? new List<AuthorModel>());
                var dataAnswer = CustomHelpers.Extensions.ToDataTable(model.AnswerByOutDocModels ?? new List<AnswerByOutDocModel>());

                if (dataWhomAddress != null)
                    parameters.Add("@whomAddress", dataWhomAddress, "[serviceletters].[UdttWhomAddress]");

                if (dataRelated != null)
                    parameters.Add("@related", dataRelated, "[dbo].[UdttRelated]");

                if (dataAuthor != null)
                    parameters.Add("@author", dataAuthor, "[dbo].[UdttAuthor]");

                if (dataAnswer != null)
                    parameters.Add("@answer", dataAnswer, "[dbo].[UdttAnswer]");

                unitOfWork.ExecuteNonQueryProcedure("[outgoingdoc].[spDocsOperation]", parameters);

                return result = Convert.ToInt32(parameters.FirstOrDefault(p => p.ParameterName == "@result")?.Value);
            }
            catch (Exception exception)
            {
                throw;
            }
        }

        public static int PostActionOperation(this IUnitOfWork unitOfWork, int actionId, int docId, int docTypeId, int workPlaceId, string description, out int result)
        {
            try
            {
                var parameters = Extension.Init()
                       .Add("@actionId", actionId)
                       .Add("@docId", docId)
                       .Add("@docTypeId", docTypeId)
                       .Add("@workPlaceId", workPlaceId)
                       .Add("@note", description)
                       .Add("@result", 0, direction: ParameterDirection.InputOutput);

                unitOfWork.ExecuteNonQueryProcedure("[outgoingdoc].[spPostActionOperation]", parameters);
                return result = Convert.ToInt32(parameters.FirstOrDefault(p => p.ParameterName == "@result")?.Value);
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public static int DeleteDocument(this IUnitOfWork unitOfWork, int relatedId, int formTypeId, out int result)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@operationType", (int)OperationType.Delete)
                    .Add("@rowId", relatedId)
                    .Add("@formTypeId", formTypeId)
                    .Add("@result", 0, direction: ParameterDirection.InputOutput);

                unitOfWork.ExecuteNonQueryProcedure("[outgoingdoc].[spDocsOperation]", parameters);

                return result = Convert.ToInt32(parameters.FirstOrDefault(p => p.ParameterName == "@result")?.Value);
            }
            catch (Exception exception)
            {
                throw;
            }
        }

        public static List<ResultModel> GetResultModel(this IUnitOfWork unitOfWork)
        {
            var parameters = Extension.Init()
                .Add("@formTypeId", (int)BasicInformation.Result);
            return unitOfWork.ExecuteProcedure<ResultModel>("[outgoingdoc].[spAddNewDocumentLoad]", parameters).ToList();
        }

        public static DocumentViewModel GetOutgoingReserveDocViewModel(this IUnitOfWork unitOfWork, int docType, int workPlaceId)
        {
            var parameters = Extension.Init()
                      .Add("@docType", docType)
                      .Add("@workPlaceId", workPlaceId);

            var chooseList = unitOfWork.ExecuteProcedure<ChooseModel>("[outgoingdoc].[AddDocumentReserve]", parameters);
            var model = new DocumentViewModel();
            model.SignatoryPersons = chooseList.Where(l => l.FormTypeId == (int)BasicInformation.SignatoryPerson);
            model.Departments = chooseList.Where(l => l.FormTypeId == (int)BasicInformation.Department);

            return model;
        }

        public static int SaveReserveDocument(this IUnitOfWork unitOfWork, int workPlaceId, int docType, DocumentFormModel model, int? docId, out int result)
        {
            try
            {
                var parameters = Extension.Init()

                        .Add("@operationType", (int)DocSaveStatus.Save)
                        .Add("@workPlaceId", workPlaceId)
                        .Add("@departmentId", model.Department.Id)
                        .Add("@docTypeId", docType)
                        .Add("@docDeleted", (int)DocSaveStatus.Save)
                        .Add("@documentStatusId", (int)DocumentStatus.Draft)
                        .Add("@signatoryPersonId", model.SignatoryPerson.Id)
                        .Add("@docEnterDate", model.DocumentModel.DocEnterDate)
                        .Add("@shortContent", model.DocumentModel.ShortContent)
                        .Add("@docId", docId)
                        .Add("@result", 0, direction: ParameterDirection.InputOutput);
                unitOfWork.ExecuteNonQueryProcedure("[outgoingdoc].[spCreateReserveDocument]", parameters);

                return result = Convert.ToInt32(parameters.FirstOrDefault(p => p.ParameterName == "@result")?.Value);
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public static int AddAnswerDocExecutors(this IUnitOfWork unitOfWork, int answerDocId, int currentDocId, int? signerWorkPlaceId, int workPlaceId)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@answerDocId", answerDocId)
                    .Add("@currentDocId", currentDocId)
                    .Add("@signerWorkPlaceId", signerWorkPlaceId)
                    .Add("@workPlaceId", workPlaceId)
                    .Add("@result", 0, direction: ParameterDirection.InputOutput);

                unitOfWork.ExecuteNonQueryProcedure("[dbo].[AddAnswerDocExecutors]", parameters);

                return Convert.ToInt32(parameters.FirstOrDefault(p => p.ParameterName == "@result")?.Value);
            }
            catch (Exception ex)
            {
                throw;
            }

            return 0;
        }

        public static List<int> AddNewAuthor(this IUnitOfWork unitOfWork, FormCollection form)
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

                unitOfWork.ExecuteNonQueryProcedure("[dbo].[AddNewAuthor]", parameters);

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
        public static List<AuthorModel> GetAuthorInfo(this IUnitOfWork unitOfWork, string data, int next, int workPlaceId, int docTypeId)
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

                model = unitOfWork.ExecuteProcedure<AuthorModel>("[dbo].[GetAuthorInfo]", parameters).ToList();
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

    }
}