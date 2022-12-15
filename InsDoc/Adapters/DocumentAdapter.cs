using BLL.BaseAdapter;
using BLL.Models.Document;
using CustomHelpers;
using InsDoc.Common.Enums;
using InsDoc.Model.EntityModel;
using InsDoc.Model.FormModel;
using InsDoc.Model.ViewModel;
using LogHelpers;
using Newtonsoft.Json;
using Repository.Extensions;
using Repository.Infrastructure;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace InsDoc.Adapters
{
    public class DocumentAdapter : AdapterBase
    {
        public DocumentAdapter(IUnitOfWork unitOfWork) : base(unitOfWork)
        {
            Log.AddInfo("Init DocumentAdapter", " ", "InsDoc.Adapters.DocumentAdapter.DocumentAdapter");
        }

        public DocumentGridViewModel GetDocumentGridModel(int workPlaceId, int? periodId, int docType, int? pageIndex, int pageSize, List<SqlParameter> searchParams)
        {
            Log.AddInfo("GetDocumentGridModel", $"workPlaceId:{workPlaceId},periodId:{periodId},docType:{docType},pageIndex:{pageIndex},pageSize:{pageSize}",
                                                                             "InsDoc.Adapters.DocumentAdapter.GetDocumentGridModel");
            try
            {
                var parameters = Extension.Init()
                                   .Add("@workPlaceId", workPlaceId)
                                   .Add("@periodId", periodId)
                                   .Add("@pageIndex", pageIndex)
                                   .Add("@pageSize", pageSize)
                                   .Add("@docTypeId", docType)
                                   .Add("@totalCount", 0, ParameterDirection.Output);

                parameters.AddRange(searchParams);

                var data = UnitOfWork.ExecuteProcedure<DocumentGridModel>("[dms_insdoc].[spGetDocs]", parameters).ToList();
                return new DocumentGridViewModel
                {
                    TotalCount = Convert.ToInt32(parameters.First(p => p.ParameterName == "@totalCount").Value),
                    Items = data
                };
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "InsDoc.Adapters.DocumentAdapter.GetDocumentGridModel");
                throw;
            }
        }


        public IEnumerable<DocResult> GetFilteredDocs(int workPlaceId, int? periodId, int docType, int? pageIndex, int pageSize, List<SqlParameter> searchParams)
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

                

                return UnitOfWork.ExecuteProcedure<DocResult>("[dms_insdoc].[GetFilteredDocs]", parameters).ToList();
            }
            catch (Exception e)
            {
                throw;
            }
        }


        public DocumentGridViewModel GetDocumentGridModel(string docIds, int workPlaceId)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@docIds", docIds)
                    .Add("@workPlace", workPlaceId);

                var data = UnitOfWork.GetDataFromSP<DocumentGridModel>("[dms_insdoc].[GetDocs]", new { docIds, workPlace = workPlaceId }).ToList(); //UnitOfWork.ExecuteProcedure<DocumentGridModel>("[dms_insdoc].[GetDocs]", parameters).ToList();

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

        public int DeleteDoc(int docId)
        {
            Log.AddInfo("DeleteDoc", $"docId:{docId}", "InsDoc.Adapters.DocumentAdapter.DeleteDoc");
            try
            {
                var parameters = Extension.Init()
                            .Add("@docId", docId)
                            .Add("@result", 0, ParameterDirection.InputOutput);

                UnitOfWork.ExecuteNonQueryProcedure("" +
                                                     "[dbo].[spDeleteDoc]", parameters);

                return Convert.ToInt32(parameters.FirstOrDefault(x => x.ParameterName == "@result")?.Value);
            }
            catch (Exception exception)
            {
                Log.AddError(exception.Message, "InsDoc.Adapters.DocumentAdapter.DeleteDoc");
                throw;
            }
        }

        public int DeleteDocAddition(int docId)
        {
            Log.AddInfo("DeleteDocAddition", $"docId:{docId}", "InsDoc.Adapters.DocumentAdapter.DeleteDocAddition");
            try
            {
                var parameters = Extension.Init()
                            .Add("@docId", docId)
                            .Add("@result", 0, ParameterDirection.InputOutput);

                UnitOfWork.ExecuteNonQueryProcedure("" +
                                                     "[dbo].[spDeleteDocAddition]", parameters);

                return Convert.ToInt32(parameters.FirstOrDefault(x => x.ParameterName == "@result")?.Value);
            }
            catch (Exception exception)
            {
                Log.AddError(exception.Message, "InsDoc.Adapters.DocumentAdapter.DeleteDocAddition");
                throw;
            }
        }

        public List<ChooseModel> GetChooseModel(int docType, int workPlaceId)
        {
            Log.AddInfo("GetChooseModel", $"docType:{docType},workPlaceId:{workPlaceId}",
                                           "InsDoc.Adapters.DocumentAdapter.GetChooseModel");
            try
            {
                var parameters = Extension.Init()
                      .Add("@docType", docType)
                      .Add("@workPlaceId", workPlaceId);
                return UnitOfWork.ExecuteProcedure<ChooseModel>("[dms_insdoc].[NewDocumentLoad]", parameters).ToList();
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "InsDoc.Adapters.DocumentAdapter.GetChooseModel");
                throw;
            }
        }

        public ChiefModel GetChiefModel(int workplaceid)
        {
            var parameters = Extension.Init()
                .Add("@workplaceid", workplaceid);
            string jsonData = UnitOfWork.ExecuteProcedure<string>("[dbo].[spAddExecutorChiefsLast]", parameters).Aggregate((i, j) => i + j);
            return JsonConvert.DeserializeObject<IEnumerable<ChiefModel>>(jsonData).First();
        }

        public List<RelatedDocModel> GetRelatedDocModel()
        {
            Log.AddInfo("GetRelatedDocModel", "InsDoc.Adapters.DocumentAdapter.GetRelatedDocModel");
            try
            {
                var parameters = Extension.Add(Extension.Init(), "@formTypeId", (int)BasicInformation.RelatedDocument);
                return UnitOfWork.ExecuteProcedure<RelatedDocModel>("[dms_insdoc].[NewDocumentLoad]", parameters).ToList();
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "InsDoc.Adapters.DocumentAdapter.GetRelatedDocModel");
                throw;
            }
        }

        public DocumentModel GetDocumentModel(int docId)
        {
            Log.AddInfo("GetDocumentModel", $"docId:{docId}", "InsDoc.Adapters.DocumentAdapter.GetDocumentModel");
            try
            {
                var parameters = Extension.Init()
                               .Add("@docId", docId)
                               .Add("@formTypeId", (int)Document.BasicInformation);
                return UnitOfWork.ExecuteProcedure<DocumentModel>("[dms_insdoc].[NewDocumentLoad]", parameters).FirstOrDefault();
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "InsDoc.Adapters.DocumentAdapter.GetDocumentModel");
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

                return UnitOfWork.ExecuteProcedure<TaskModel>("[dms_insdoc].[NewDocumentLoad]", parameters).ToList();
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "InsDoc.Adapters.DocumentAdapter.GetTaskModel");
                throw;
            }
        }

        public List<RelatedDocModel> GetRelatedModel(int docId, int docType)
        {
            var parameters = Extension.Init()
                .Add("@docId", docId)
                .Add("@docType", docType)
                .Add("@formTypeId", (int)Document.RelatedInformation);

            return UnitOfWork.ExecuteProcedure<RelatedDocModel>("[dms_insdoc].[NewDocumentLoad]", parameters).ToList();
        }

        public int SaveDocument(int workPlaceId, int docType, int? docId, DocumentFormModel model, out int result)
        {
            Log.AddInfo("SaveDocument", $"workPlaceId:{workPlaceId},docType:{docType},docId:{docId},model:{model}",
                                                                      "InsDoc.Adapters.DocumentAdapter.SaveDocument");
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
                        .Add("@confirmingPersonId", model.ConfirmingPerson.Id)
                        .Add("@shortContent", model.DocumentModel.ShortContent)
                        .Add("@subtypeOfDocumentId", model.SubtypeOfDocument.Id)
                        .Add("@docId", docId)
                        .Add("@vizaDataJson", model.VizaDataJson)
                        .Add("@result", 0, direction: ParameterDirection.InputOutput);

                var data = model.TaskFormModels.ToDataTable();
                var dataRelated = model.RelatedDocModels.ToDataTable();
                var redirected = model.RedirectPersonInput.ToDataTable();

                parameters.Add("@tasks", data, "[dms_insdoc].[UdttTask]");
                parameters.Add("@related", dataRelated, "[dbo].[UdttRelated]");
                parameters.Add("@redirectPerson", redirected, "dbo.RedirectPerson");

                UnitOfWork.ExecuteNonQueryProcedure("[dms_insdoc].[spDocsOperation]", parameters);

                return result = Convert.ToInt32(parameters.FirstOrDefault(p => p.ParameterName == "@result")?.Value);
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "InsDoc.Adapters.DocumentAdapter.SaveDocument");
                throw;
            }
        }

        public int EditDocument(int workPlaceId, int docType, int docId, DocumentFormModel model, out int result)
        {
            Log.AddInfo("EditDocument", $"workPlaceId:{workPlaceId},docType:{docType},docId:{docId},model:{model}",
                                                                       "InsDoc.Adapters.DocumentAdapter.EditDocument");
            try
            {
                var dataRelated = model.RelatedDocModels.ToDataTable();
                var dataTask = model.TaskFormModels.ToDataTable();
                var redirected = model.RedirectPersonInput.ToDataTable();

                var parameters = Extension.Init()
                    .Add("@operationType", (int)OperationType.Update)
                    .Add("@workPlaceId", workPlaceId)
                    .Add("@docTypeId", docType)
                    .Add("@typeOfDocumentId", model.TypeOfDocument.Id)
                    .Add("@signatoryPersonId", model.SignatoryPerson.Id)
                    .Add("@confirmingPersonId", model.ConfirmingPerson.Id)
                    .Add("@shortContent", model.DocumentModel.ShortContent)
                    .Add("@vizaDataJson", model.VizaDataJson)
                    .Add("@docId", docId)
                    .Add("@result", 0, direction: ParameterDirection.InputOutput);

                parameters.Add("@related", dataRelated, "[dbo].[UdttRelated]");
                parameters.Add("@tasks", dataTask, "[dms_insdoc].[UdttTask]");
                parameters.Add("@redirectPerson", redirected, "dbo.RedirectPerson");

                UnitOfWork.ExecuteNonQueryProcedure("[dms_insdoc].[spDocsOperation]", parameters);

                return result = Convert.ToInt32(parameters.FirstOrDefault(p => p.ParameterName == "@result")?.Value);
            }
            catch (Exception exception)
            {
                Log.AddError(exception.Message, "InsDoc.Adapters.DocumentAdapter.EditDocument");
                throw;
            }
        }

        public int DeleteDocument(int rowId, int formTypeId, out int result)
        {
            Log.AddInfo("DeleteDocument", $"taskId:{rowId}", "InsDoc.Adapters.DocumentAdapter.DeleteDocument");
            try
            {
                var parameters = Extension.Init()
                    .Add("@operationType", (int)OperationType.Delete)
                    .Add("@formTypeId", formTypeId)
                    .Add("@rowId", rowId)
                    .Add("@result", 0, direction: ParameterDirection.InputOutput);

                UnitOfWork.ExecuteNonQueryProcedure("[dms_insdoc].[spDocsOperation]", parameters);

                return result = Convert.ToInt32(parameters.FirstOrDefault(p => p.ParameterName == "@result")?.Value);
            }
            catch (Exception exception)
            {
                Log.AddError(exception.Message, "InsDoc.Adapters.DocumentAdapter.DeleteDocument");
                throw;
            }
        }

        public void DeleteRedirect(int redirectId)
        {
            UnitOfWork.ExecuteScalar<object>(
               "UPDATE dbo.RedirectedPersons SET IsDeleted = 1 WHERE dbo.RedirectedPersons.RedirectId =@redirectId",
               new List<SqlParameter>().Add("@redirectId", redirectId));
        }

        public DocumentInfoViewModel DocInfo(int docId, int docType, int workPlaceId)
        {
            Log.AddInfo("DocInfo", $"docId:{docId},workPlaceId:{workPlaceId}",
                                       "InsDoc.Adapters.DocumentAdapter.DocInfo");
            try
            {
                var parameters = Extension.Init()
                    .Add("@docId", docId)
                    .Add("@docType", docType)
                    .Add("@workPlaceId", workPlaceId);

                string jsonData = UnitOfWork.ExecuteProcedure<string>("[dms_insdoc].spGetDocView", parameters).Aggregate((i, j) => i + j);
                return JsonConvert.DeserializeObject<IEnumerable<DocumentInfoViewModel>>(jsonData).First();
            }
            catch (Exception exception)
            {
                Log.AddError(exception.Message, "InsDoc.Adapters.DocumentAdapter.DocInfo");
                throw;
            }
        }

        public ElectronicDocumentViewModel ElectronDocView(int docId, int executorId)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@docId", docId)
                    .Add("@executorId", executorId);

                var model = UnitOfWork.ExecuteProcedure<ElectronicDocumentViewModel>("[dms_insdoc].[GetElectronDocView]", parameters).FirstOrDefault();

                return model;
            }
            catch (Exception exception)
            {
                Log.AddError(exception.Message, "InsDoc.Adapters.DocumentAdapter.ElectronicDocument");
                throw;
            }
        }

        public ElectronicDocumentViewModel ElectronicDocument(int docId, int docType, int workPlaceId, int executorId)
        {
            Log.AddInfo("ElectronicDocument", $"docId:{docId},docType:{docType},workPlaceId:{workPlaceId}",
                                                         "InsDoc.Adapters.DocumentAdapter.ElectronicDocument");
            try
            {
                var parameters = Extension.Init()
                    .Add("@docId", docId)
                    .Add("@docType", docType)
                    .Add("@workPlaceId", workPlaceId)
                    .Add("@executorId", executorId);

                string jsonData = UnitOfWork.ExecuteProcedure<string>("[dms_insdoc].[spGetElectronicDocument]", parameters).Aggregate((i, j) => i + j);
                return JsonConvert.DeserializeObject<IEnumerable<ElectronicDocumentViewModel>>(jsonData).First();
            }
            catch (Exception exception)
            {
                Log.AddError(exception.Message, "InsDoc.Adapters.DocumentAdapter.ElectronicDocument");
                throw;
            }
        }

        public FileInfoModel ElectronicDocument(int docInfoId)
        {
            Log.AddInfo("ElectronicDocument", $"docInfoId:{docInfoId}", "InsDoc.Adapters.DocumentAdapter.ElectronicDocument");
            try
            {
                var parameters = Extension.Init()
                    .Add("@docInfoId", docInfoId);

                string jsonData = UnitOfWork.ExecuteProcedure<string>("[dms_insdoc].[spGetElectronicDocument]", parameters).Aggregate((i, j) => i + j);
                return JsonConvert.DeserializeObject<IEnumerable<FileInfoModel>>(jsonData).First();
            }
            catch (Exception exception)
            {
                Log.AddError(exception.Message, "InsDoc.Adapters.DocumentAdapter.ElectronicDocument");
                throw;
            }
        }
    }
}