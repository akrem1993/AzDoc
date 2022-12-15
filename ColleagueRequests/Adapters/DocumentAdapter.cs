using BLL.BaseAdapter;
using BLL.Models.Document;
using ColleagueRequests.Common.Enums;
using ColleagueRequests.Model.EntityModel;
using ColleagueRequests.Model.FormModel;
using ColleagueRequests.Model.ViewModel;
using CustomHelpers;
using LogHelpers;
using Newtonsoft.Json;
using Repository.Extensions;
using Repository.Infrastructure;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.Mvc;

namespace ColleagueRequests.Adapters
{
    public class DocumentAdapter : AdapterBase
    {
        public DocumentAdapter(IUnitOfWork unitOfWork) : base(unitOfWork) { }


        public DocumentInfoViewModel GetDocView(int docId)
        {
            var parameters = Extension.Init()
                .Add("@docId", docId);

            return UnitOfWork.ExecuteProcedure<DocumentInfoViewModel>("[colleaguerequests].[GetDocView]", parameters).FirstOrDefault();
        }

        public IEnumerable<Applicant> GetDocApplicants(int docId)
        {
            var parameters = Extension.Init()
                .Add("@docId", docId);

            return UnitOfWork.ExecuteCommand<Applicant>("SELECT dav.* FROM colleaguerequests.DocApplicantsView dav	 WHERE dav.AppDocId=@docId", parameters);
        }

        public IEnumerable<PreviosRequests> GetDocPreviousRequests(int docId)
        {
            var parameters = Extension.Init()
                .Add("@docId", docId);

            return UnitOfWork.ExecuteProcedure<PreviosRequests>($"[colleaguerequests].[GetPreviousRequests]", parameters);
        }

        public DocumentGridViewModel GetDocumentGridModel(string docIds, int workPlaceId)
        {
            var parameters = Extension.Init()
                .Add("@docIds", docIds)
                .Add("@workPlace", workPlaceId);

            var data = UnitOfWork.ExecuteProcedure<DocumentGridModel>("[colleaguerequests].[GetDocs]", parameters).ToList();

            return new DocumentGridViewModel
            {
                TotalCount = 0,
                Items = data
            };
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

            return UnitOfWork.ExecuteProcedure<DocResult>("[colleaguerequests].[GetFilteredDocs]", parameters);
        }


        public List<ChooseModel> GetChooseModel(int docType, int workPlaceId)
        {
            var parameters = Extension.Init()
                        .Add("@docType", docType)
                        .Add("@workPlaceId", workPlaceId);
            return UnitOfWork.ExecuteProcedure<ChooseModel>("[colleaguerequests].[spAddNewDocumentLoad]", parameters).ToList();
        }

        public List<RelatedDocModel> GetRelatedDocModel()
        {
            var parameters = Extension.Init()
                .Add("@formTypeId", (int)BasicInformation.RelatedDocument);
            return UnitOfWork.ExecuteProcedure<RelatedDocModel>("[colleaguerequests].[spAddNewDocumentLoad]", parameters).ToList();
        }

        public List<AuthorModel> GetAuthorModel()
        {
            var parameters = Extension.Init()
                .Add("@formTypeId", (int)BasicInformation.Author);
            return UnitOfWork.ExecuteProcedure<AuthorModel>("[colleaguerequests].[spAddNewDocumentLoad]", parameters).ToList();
        }

        public List<SubordinateModel> GetSubordinateModel(int organizationId, int docTopicId)
        {
            var parameters = Extension.Init()
                .Add("@formTypeId", (int)BasicInformation.Subordinate)
                .Add("@organizationId", organizationId)
                .Add("@topicTypeId", docTopicId);
            return UnitOfWork.ExecuteProcedure<SubordinateModel>("[colleaguerequests].[spAddNewDocumentLoad]", parameters).ToList();
        }

        public List<SubtitleModel> GetSubtitleModel(int topicTypeId)
        {
            var parameters = Extension.Init()
                .Add("@formTypeId", (int)BasicInformation.Subtitle)
                .Add("@topicTypeId", topicTypeId);
            return UnitOfWork.ExecuteProcedure<SubtitleModel>("[colleaguerequests].[spAddNewDocumentLoad]", parameters).ToList();
        }
        /// <summary>
        /// ///
        /// </summary>
        /// <param name="topicId"></param>
        /// <returns></returns>

        public List<SubtitleModel> GetSubtitleOrgan(int topicId, int workPlaceId)
        {
            var parameters = Extension.Init()
                .Add("@formTypeId", (int)BasicInformation.Organization)
                .Add("@workPlaceId", workPlaceId)
                .Add("@topicid", topicId);
            return UnitOfWork.ExecuteProcedure<SubtitleModel>("[colleaguerequests].[spAddNewDocumentLoad]", parameters).ToList();
        }




        public List<RegionModel> GetRegionModel(int countryId)
        {
            var parameters = Extension.Init()
                .Add("@formTypeId", (int)BasicInformation.Region)
                .Add("@countryId", countryId);
            return UnitOfWork.ExecuteProcedure<RegionModel>("[colleaguerequests].[spAddNewDocumentLoad]", parameters).ToList();
        }

        public List<RegionModel> GetVillageModel(int regionId)
        {
            var parameters = Extension.Init()
                .Add("@formTypeId", (int)BasicInformation.Villages)
                .Add("@regionId", regionId);
            return UnitOfWork.ExecuteProcedure<RegionModel>("[colleaguerequests].[spAddNewDocumentLoad]", parameters).ToList();
        }

        public List<ApplyAgainModel> GetApplyAgainModel(int docType, string surName, string firstName, int organizationId)
        {
            var parameters = Extension.Init()
                .Add("@docTypeId", docType)
                .Add("@organizationId", organizationId)
                .Add("@surName", surName.Trim())
                .Add("@firstName", firstName.Trim());
            var data = UnitOfWork.ExecuteProcedure<ApplyAgainModel>("[colleaguerequests].[spGetApplicant]", parameters).ToList();
            return data;
        }

        public List<ApplyAgainModel> GetApplyAgainModel(int docId)
        {
            var parameters = Extension.Init()
                .Add("@docId", docId);

            var data = UnitOfWork.ExecuteProcedure<ApplyAgainModel>("[colleaguerequests].[spGetApplicant]", parameters).ToList();
            return data;
        }

        public DocumentModel GetDocumentModel(int docId)
        {
            var parameters = Extension.Init()
                .Add("@docId", docId)
                .Add("@formTypeId", (int)Document.BasicInformation);
            string jsonData = UnitOfWork.ExecuteProcedure<string>("[colleaguerequests].[spAddNewDocumentLoad]", parameters).Aggregate((i, j) => i + j);
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
                        .Add("@documentStatusId", (int)DocumentStatus.Registered)
                        .Add("@docEnterDate", model.DocumentModel.DocEnterDate)
                        .Add("@applytypeId", model.TypeOfApplication.Id)
                        .Add("@whomAddressId", model.WhomAddress.Id)
                        .Add("@topicTypeId", model.TopicTypeName.Id)
                        .Add("@subtitleId", model.Subtitle.Id)
                        .Add("@executionStatusId", model.ExecutionStatus.Id)
                        .Add("@receivedFormId", model.ReceivedForm.Id)
                        .Add("@numberOfApplicants", model.DocumentModel.ColleaguesCount)
                        .Add("@plannedDate", model.DocumentModel.PlannedDate)
                        .Add("@organizationId", model.Organization?.Id)
                        .Add("@subordinateId", model.Subordinate?.Id)
                        .Add("@typeOfDocumentId", model.TypeOfDocument.Id)
                        .Add("@docNo", model.DocumentModel.DocNo)
                        .Add("@docDate", model.DocumentModel.DocDate)
                        .Add("@corruption", model.DocumentModel.Corruption)
                        .Add("@supervision", model.DocumentModel.Supervision)
                        .Add("@shortContent", model.DocumentModel.ShortContent)
                        .Add("@colleagueType", model.ColleagueType.Id)
                        .Add("@docId", docId)
                        .Add("@result", 0, direction: ParameterDirection.InputOutput);

                var dataRelated = Extensions.ToDataTable((model.RelatedDocModels ?? new List<RelatedDocModel>()) as IEnumerable<RelatedDocModel>);
                var dataAuthor = Extensions.ToDataTable(model.AuthorModels ?? new List<AuthorModel>());
                var dataApplication = Extensions.ToDataTable(model.ApplicationModels ?? new List<ApplicationModel>());

                if (dataRelated != null)
                    parameters.Add("@related", dataRelated, "[dbo].[UdttRelated]");
                if (dataAuthor != null)
                    parameters.Add("@author", dataAuthor, "[colleaguerequests].[UdttAuthor]");
                if (dataApplication != null)
                    parameters.Add("@application", dataApplication, "[dbo].[UdttApplication]");

                UnitOfWork.ExecuteNonQueryProcedure("[colleaguerequests].[spDocsOperation]", parameters);

                return result = Convert.ToInt32(parameters.FirstOrDefault(p => p.ParameterName == "@result")?.Value);
            }
            catch (Exception exception)
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
                    .Add("@applytypeId", model.TypeOfApplication.Id)
                    .Add("@whomAddressId", model.WhomAddress.Id)
                    .Add("@topicTypeId", model.TopicTypeName.Id)
                    .Add("@subtitleId", model.Subtitle.Id)
                    .Add("@executionStatusId", model.ExecutionStatus.Id)
                    .Add("@receivedFormId", model.ReceivedForm.Id)
                    .Add("@numberOfApplicants", (int?)model.DocumentModel.ColleaguesCount)
                    .Add("@plannedDate", model.DocumentModel.PlannedDate)
                    .Add("@organizationId", model.Organization.Id)
                    .Add("@subordinateId", model.Subordinate.Id)
                    .Add("@typeOfDocumentId", model.TypeOfDocument.Id)
                    .Add("@docNo", model.DocumentModel.DocNo)
                    .Add("@docDate", model.DocumentModel.DocDate)
                    .Add("@corruption", model.DocumentModel.Corruption)
                    .Add("@supervision", model.DocumentModel.Supervision)
                    .Add("@shortContent", model.DocumentModel.ShortContent)
                    .Add("@docId", docId)
                    .Add("@result", 0, direction: ParameterDirection.InputOutput);

                var dataRelated = CustomHelpers.Extensions.ToDataTable((model.RelatedDocModels ?? new List<RelatedDocModel>()) as IEnumerable<RelatedDocModel>);
                var dataAuthor = CustomHelpers.Extensions.ToDataTable(model.AuthorModels ?? new List<AuthorModel>());
                var dataApplication = CustomHelpers.Extensions.ToDataTable(model.ApplicationModels ?? new List<ApplicationModel>());
                if (dataRelated != null)
                    parameters.Add("@related", dataRelated, "[dbo].[UdttRelated]");
                if (dataAuthor != null)
                    parameters.Add("@author", dataAuthor, "[colleaguerequests].[UdttAuthor]");
                if (dataApplication != null)
                    parameters.Add("@application", dataApplication, "[dbo].[UdttApplication]");
                UnitOfWork.ExecuteNonQueryProcedure("[colleaguerequests].[spDocsOperation]", parameters);

                return result = Convert.ToInt32(parameters.FirstOrDefault(p => p.ParameterName == "@result")?.Value);
            }
            catch (Exception exception)
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

                UnitOfWork.ExecuteNonQueryProcedure("[colleaguerequests].[spDocsOperation]", parameters);

                return result = Convert.ToInt32(parameters.FirstOrDefault(p => p.ParameterName == "@result")?.Value);
            }
            catch (Exception exception)
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

                string jsonData = UnitOfWork.ExecuteProcedure<string>("[colleaguerequests].spGetDocView", parameters).Aggregate((i, j) => i + j);
                return JsonConvert.DeserializeObject<IEnumerable<DocumentInfoViewModel>>(jsonData).First();
            }
            catch (Exception exception)
            {
                throw;
            }
        }

        public ElectronicDocumentViewModel ElectronicDocument(int docId, int docType, int workPlaceId, int executorId)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@docId", docId)
                    .Add("@docType", docType)
                    .Add("@workPlaceId", workPlaceId)
                    .Add("@executorId", executorId);

                string jsonData = UnitOfWork.ExecuteProcedure<string>("[colleaguerequests].[spGetElectronicDocument]", parameters).Aggregate((i, j) => i + j);
                return JsonConvert.DeserializeObject<IEnumerable<ElectronicDocumentViewModel>>(jsonData).First();
            }
            catch (Exception exception)
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

                string jsonData = UnitOfWork.ExecuteProcedure<string>("[colleaguerequests].[spGetElectronicDocument]", parameters).Aggregate((i, j) => i + j);
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
            }

            return null;
        }
    }
}
