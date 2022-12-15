using Newtonsoft.Json;
using Repository.Extensions;
using Repository.Infrastructure;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Runtime.Serialization;
using LogHelpers;
using System.Web.Mvc;
using ServiceLetters.Common.Enums;
using ServiceLetters.Model.EntityModel;
using ServiceLetters.Model.FormModel;
using ServiceLetters.Model.ViewModel;
using BLL.Models.Document;
using BLL.BaseAdapter;

namespace ServiceLetters.Adapters
{
    public class DocumentAdapter : AdapterBase
    {
        public DocumentAdapter(IUnitOfWork unitOfWork) : base(unitOfWork) { }

        public DocumentGridViewModel GetDocumentGridModel(string docIds)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@docIds", docIds);

                var data = UnitOfWork.ExecuteProcedure<DocumentGridModel>("[serviceletters].[GetDocs]", parameters).ToList();

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
            var parameters = Extension.Init()
                    .Add("@workPlaceId", workPlaceId)
                    .Add("@periodId", periodId)
                    .Add("@pageIndex", pageIndex)
                    .Add("@pageSize", pageSize)
                    .Add("@docTypeId", docType)
                    .Add("@totalCount", 0, ParameterDirection.Output);
            parameters.AddRange(searchParams);
            return UnitOfWork.ExecuteProcedure<DocResult>("[serviceletters].[spGetDocs1]", parameters).ToList();
        }


        public List<ChooseModel> GetChooseModel(int docType, int workPlaceId)
        {
            var parameters = Extension.Init()
                        .Add("@docType", docType)
                        .Add("@workPlaceId", workPlaceId);
            return UnitOfWork.ExecuteProcedure<ChooseModel>("[serviceletters].[spAddNewDocumentLoad]", parameters).ToList();
        }

        public List<RelatedDocModel> GetRelatedDocModel()
        {
            var parameters = Extension.Init()
                .Add("@formTypeId", (int)BasicInformation.RelatedDocument);
            return UnitOfWork.ExecuteProcedure<RelatedDocModel>("[serviceletters].[spAddNewDocumentLoad]", parameters).ToList();
        }

        public List<ResultModel> GetResultModel()
        {
            var parameters = Extension.Init()
                .Add("@formTypeId", (int)BasicInformation.Result);
            return UnitOfWork.ExecuteProcedure<ResultModel>("[serviceletters].[spAddNewDocumentLoad]", parameters).ToList();
        }


        public DocumentModel GetDocumentModel(int docId)
        {
            var parameters = Extension.Init()
                .Add("@docId", docId)
                .Add("@formTypeId", (int)Document.BasicInformation);
            string jsonData = UnitOfWork.ExecuteProcedure<string>("[serviceletters].[spAddNewDocumentLoad]", parameters).Aggregate((i, j) => i + j);
            return JsonConvert.DeserializeObject<IEnumerable<DocumentModel>>(jsonData).First();
        }

        public DocumentModel GetRelateDocumentByServiceLetterModel(int docId)
        {
            var parameters = Extension.Init()
                .Add("@docId", docId)
                .Add("@formTypeId", (int)Document.RelateDocumentByServiceLetter);
            string jsonData = UnitOfWork.ExecuteProcedure<string>("[serviceletters].[spAddNewDocumentLoad]", parameters).Aggregate((i, j) => i + j);
            return JsonConvert.DeserializeObject<IEnumerable<DocumentModel>>(jsonData).First();
        }

        public DocumentModel GetAnswerByLetterModel(int docId)
        {
            var parameters = Extension.Init()
                .Add("@docId", docId)
                .Add("@formTypeId", (int)Document.AnswerByLetter);
            string jsonData = UnitOfWork.ExecuteProcedure<string>("[serviceletters].[spAddNewDocumentLoad]", parameters).Aggregate((i, j) => i + j);
            return JsonConvert.DeserializeObject<IEnumerable<DocumentModel>>(jsonData).First();
        }

        public int SaveDocument(int workPlaceId, int docType, int? docId, DocumentFormModel model, out int result)
        {
            try
            {
                var parameters = Extension.Init()
                        .Add("@operationType", (int)DocSaveStatus.Save)
                        .Add("@workPlaceId", workPlaceId)
                        .Add("@docTypeId", docType)
                        .Add("@docDeleted", (int)DocSaveStatus.Save)
                        .Add("@documentStatusId", (int)DocumentStatus.Draft)
                        .Add("@docEnterDate", model.DocumentModel.DocEnterDate)
                        .Add("@signatoryPersonId", model.SignatoryPerson.Id)
                        .Add("@confirmingPersonId", model.ConfirmingPerson.Id)
                        .Add("@plannedDate", model.DocumentModel.PlannedDate)
                        .Add("@shortContent", model.DocumentModel.ShortContent)
                        .Add("@docId", docId)
                        .Add("@result", 0, direction: ParameterDirection.InputOutput);

                var dataWhomAddress = CustomHelpers.Extensions.ToDataTable(model.WhomAddressModels ?? new List<WhomAddressModel>());

                var dataRelated = CustomHelpers.Extensions.ToDataTable(model.RelatedDocModels ?? new List<RelatedDocModel>());
                var dataAnswer = CustomHelpers.Extensions.ToDataTable(model.AnswerByLetterModels ?? new List<AnswerByLetterModel>());


                if(dataWhomAddress != null)
                    parameters.Add("@whomAddress", dataWhomAddress, "[serviceletters].[UdttWhomAddress]");
                if(dataRelated != null)
                    parameters.Add("@related", dataRelated, "[dbo].[UdttRelated]");

                if(dataAnswer != null)
                    parameters.Add("@answer", dataAnswer, "[dbo].[UdttAnswer]");

                UnitOfWork.ExecuteNonQueryProcedure("[serviceletters].[spDocsOperation]", parameters);

                return result = Convert.ToInt32(parameters.FirstOrDefault(p => p.ParameterName == "@result")?.Value);
            }
            catch(Exception exception)
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
                    .Add("@signatoryPersonId", model.SignatoryPerson.Id)
                    .Add("@confirmingPersonId", model.ConfirmingPerson.Id)
                    .Add("@plannedDate", model.DocumentModel.PlannedDate)
                    .Add("@shortContent", model.DocumentModel.ShortContent)
                    .Add("@docId", docId)
                    .Add("@result", 0, direction: ParameterDirection.InputOutput);

                var dataWhomAddress = CustomHelpers.Extensions.ToDataTable(model.WhomAddressModels ?? new List<WhomAddressModel>());
                var dataRelated = CustomHelpers.Extensions.ToDataTable(model.RelatedDocModels ?? new List<RelatedDocModel>());
                var dataAnswer = CustomHelpers.Extensions.ToDataTable(model.AnswerByLetterModels ?? new List<AnswerByLetterModel>());

                if(dataWhomAddress != null)
                    parameters.Add("@whomAddress", dataWhomAddress, "[serviceletters].[UdttWhomAddress]");

                if(dataRelated != null)
                    parameters.Add("@related", dataRelated, "[dbo].[UdttRelated]");

                if(dataAnswer != null)
                    parameters.Add("@answer", dataAnswer, "[dbo].[UdttAnswer]");

                UnitOfWork.ExecuteNonQueryProcedure("[serviceletters].[spDocsOperation]", parameters);

                return result = Convert.ToInt32(parameters.FirstOrDefault(p => p.ParameterName == "@result")?.Value);
            }
            catch(Exception exception)
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

                UnitOfWork.ExecuteNonQueryProcedure("[serviceletters].[spDocsOperation]", parameters);

                return result = Convert.ToInt32(parameters.FirstOrDefault(p => p.ParameterName == "@result")?.Value);
            }
            catch(Exception exception)
            {
                throw;
            }
        }

        public DocumentInfoViewModel DocInfo(int docId, int workPlaceId, int docType)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@docId", docId)
                    .Add("@docType", docType)
                    .Add("@workPlaceId", workPlaceId);

                string jsonData = UnitOfWork.ExecuteProcedure<string>("[serviceletters].spGetDocView", parameters).Aggregate((i, j) => i + j);
                return JsonConvert.DeserializeObject<IEnumerable<DocumentInfoViewModel>>(jsonData).First();
            }
            catch(Exception exception)
            {
                throw;
            }
        }

        public ElectronicDocumentViewModel ElectronicDocument(int docId, int docType, int workPlaceId)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@docId", docId)
                    .Add("@docType", docType)
                    .Add("@workPlaceId", workPlaceId);

                string jsonData = UnitOfWork.ExecuteProcedure<string>("[serviceletters].[spGetElectronicDocument]", parameters).Aggregate((i, j) => i + j);
                return JsonConvert.DeserializeObject<IEnumerable<ElectronicDocumentViewModel>>(jsonData).First();
            }
            catch(Exception exception)
            {
                throw;
            }
        }

        public FileInfoModel ElectronicDocument(int docInfoId)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@docInfoId", docInfoId);

                string jsonData = UnitOfWork.ExecuteProcedure<string>("[serviceletters].[spGetElectronicDocument]", parameters).Aggregate((i, j) => i + j);
                return JsonConvert.DeserializeObject<IEnumerable<FileInfoModel>>(jsonData).First();
            }
            catch
            {
                throw;
            }
        }

        public bool AddNewAuthor(FormCollection form)
        {
            try
            {
                var parameters = new List<SqlParameter>();
                foreach(var key in form.AllKeys)
                {
                    parameters.Add("@" + key, form["" + key + ""]);
                }

                parameters.Add("@result", 0, direction: ParameterDirection.InputOutput);

                UnitOfWork.ExecuteNonQueryProcedure("[dbo].[AddNewAuthor]", parameters);
                return Convert.ToInt32(parameters.FirstOrDefault(p => p.ParameterName == "@result")?.Value) == 1;
            }
            catch(Exception ex)
            {
                Log.AddError(
                    ex.Message,
                    "AddNewAuthor",
                    "/ServiceLetters/Document/AddNewAuthor");
            }

            return default(bool);
        }

        public bool DeleteAnswerDoc(int answerDocId, int currentDocId)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@answerDocId", answerDocId)
                    .Add("@currentDocId", currentDocId)
                    .Add("@result", 0, direction: ParameterDirection.InputOutput);

                UnitOfWork.ExecuteNonQueryProcedure("[dbo].[DeleteAnswerDoc]", parameters);
                var ad = Convert.ToInt32(parameters.FirstOrDefault(p => p.ParameterName == "@result")?.Value) == 1;
                return Convert.ToInt32(parameters.FirstOrDefault(p => p.ParameterName == "@result")?.Value) == 1;
            }
            catch(Exception ex)
            {
                ;
            }

            return false;
        }

        public int AddAnswerDocExecutors(int answerDocId, int currentDocId, int? signerWorkPlaceId, int workPlaceId)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@answerDocId", answerDocId)
                    .Add("@currentDocId", currentDocId)
                    .Add("@signerWorkPlaceId", signerWorkPlaceId)
                    .Add("@workPlaceId", workPlaceId)
                    .Add("@result", 0, direction: ParameterDirection.InputOutput);

                UnitOfWork.ExecuteNonQueryProcedure("[dbo].[AddAnswerDocExecutors]", parameters);

                return Convert.ToInt32(parameters.FirstOrDefault(p => p.ParameterName == "@result")?.Value);
            }
            catch(Exception ex)
            {
                ;
            }

            return 0;
        }
    }
}