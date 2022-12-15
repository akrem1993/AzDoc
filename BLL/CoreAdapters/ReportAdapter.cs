using BLL.BaseAdapter;
using BLL.Models.Document;
using BLL.Models.Report;
using BLL.Models.Report.Filter;
using CustomHelpers;
using LogHelpers;
using Newtonsoft.Json;
using Repository.Extensions;
using Repository.Infrastructure;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;

namespace BLL.Adapters
{
    public class ReportAdapter : AdapterBase
    {
        bool disposed;
        readonly string connectionString = ConfigurationManager.ConnectionStrings["DmsDbContext"].ConnectionString;

        public ReportAdapter(IUnitOfWork unitOfWork) : base(unitOfWork)
        {
            Log.AddInfo("Init ReportAdapter", "BLL.Adapters.ReportAdapter");
        }

        public List<ChooseModel> GetChooseModel(int? docType, int? workPlaceId)
        {
            Log.AddInfo("GetChooseModel", $"docType:{docType},workPlaceId:{workPlaceId}",
                "GetChooseModel");
            try
            {
                if (docType != null)
                {
                    var parameters = Extension.Init()
                        .Add("@docType", docType);
                    return UnitOfWork.ExecuteProcedure<ChooseModel>("[report].[spGetDasboard]", parameters).ToList();
                }
                else
                {
                    var parameters = Extension.Init()
                        .Add("@workPlaceId", workPlaceId);
                    return UnitOfWork.ExecuteProcedure<ChooseModel>("[report].[spGetDasboard]", parameters).ToList();
                }
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "GetChooseModel");
                throw;
            }
        }

        public List<ChooseModel> GetChooseModel(int? docTypeId, int? documentStatus, int? resultOfExecution)
        {
            Log.AddInfo("GetChooseModel");
            try
            {
                var parameters = Extension.Init()
                    .Add("@docTypeId", docTypeId)
                    .Add("@documentStatusId", documentStatus)
                    .Add("@resultOfExecution", resultOfExecution);
                return UnitOfWork.ExecuteProcedure<ChooseModel>("[report].[spGetReports]", parameters).ToList();
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "GetChooseModel");
                throw;
            }
        }

        public List<ReportModel> GetReportModel(int workPlaceId, DateTime? beginDate, DateTime? endDate, int? docTypeId,
            int? documentStatus, int? resultOfExecution)
        {
            Log.AddInfo("GetReportModel");
            try
            {
                var parameters = Extension.Init()
                    .Add("@workPlaceId", workPlaceId)
                    .Add("@beginDate", beginDate)
                    .Add("@endDate", endDate)
                    .Add("@docTypeId", docTypeId)
                    .Add("@documentStatusId", documentStatus)
                    .Add("@resultOfExecution", resultOfExecution);
                return UnitOfWork.ExecuteProcedure<ReportModel>("[report].[spGetReportDoc]", parameters).ToList();
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "GetReportModel");
                throw;
            }
        }

        public List<ReportForm1Model> GetReportForm1Model(int workPlaceId, DateTime? beginDate, DateTime? endDate)
        {
            Log.AddInfo("GetReportForm1Model");
            try
            {
                var parameters = Extension.Init()
                    .Add("@workPlaceId", workPlaceId)
                    .Add("@beginDate", beginDate)
                    .Add("@endDate", endDate);
                return UnitOfWork.ExecuteProcedure<ReportForm1Model>("[report].[spReportForm1]", parameters).ToList();
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "GetReportForm1Model");
                throw;
            }
        }

        public List<ReportForm2Model> GetReportForm2Model(int workPlaceId, DateTime? beginDate, DateTime? endDate)
        {
            Log.AddInfo("GetReportForm1Model");
            try
            {
                var parameters = Extension.Init()
                    .Add("@workPlaceId", workPlaceId)
                    .Add("@beginDate", beginDate)
                    .Add("@endDate", endDate);
                return UnitOfWork.ExecuteProcedure<ReportForm2Model>("[report].[spReportForm2]", parameters).ToList();
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "GetReportForm1Model");
                throw;
            }
        }

        #region Ruslan

        public List<DropDownModel> GetReportDropDown(int executorOrganizationId, int workPlaceId,
            int? executorOrganizationType)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@workPlaceId", workPlaceId)
                    .Add("@executorOrganizationType", executorOrganizationType)
                    .Add("@executorOrganizationId", executorOrganizationId);

                return UnitOfWork.ExecuteProcedure<DropDownModel>("[report].[spGetReportDropDown]", parameters)
                    .ToList();
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "spGetReportDropDown");
                throw;
            }
        }

        public List<AgencyModel> GetReportAgencyModel()
        {
            try
            {
                return UnitOfWork.ExecuteProcedure<AgencyModel>("[report].[spGetReportDropDownForAgency]").ToList();
                //var sqlQuery = "select da.AgencyId," +
                //                      "da.AgencyName," +
                //                      "da.AgencyTopId," +
                //                      "da.AgencyOrganizationId," +
                //                      "dsa.TopicTypeId from dbo.DC_AGENCY da      left join dbo.DocSubtitleAgency dsa on dsa.AgencyId = da.AgencyId";
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "GetReportAgencyModel");
                throw;
            }
        }

        public ReportPdfHeading GetReportHeading(int organizationId, int executorOrganizationType,
            int? organizationDepartmentOrOrganizations)
        {
            try
            {
                var sqlQuery = "";
                switch (executorOrganizationType)
                {
                    case -1: //-1 olduqda butun melumati getirir hansi ki nazirlik daxili ve qurumlara geden
                        sqlQuery =
                            $"SELECT isnull(orn.OrganizationName,do.OrganizationName) AS CurrentOrganizationName FROM dbo.DC_ORGANIZATION do LEFT JOIN dbo.OrganizationNew orn ON do.OrganizationId=orn.OrganizationId WHERE do.OrganizationId = {organizationId}";
                        break;
                    case 0: //0 olduqda qurum varsa qurumu yoxdursa umumi getirir
                        sqlQuery =
                            " SELECT isnull(orn.OrganizationName, do.OrganizationName) AS CurrentOrganizationName," +
                            $"(SELECT isnull(do.OrganizationName, orn.OrganizationName) " +
                            $"FROM dbo.DC_ORGANIZATION do WHERE do.OrganizationStatus = 1 AND do.OrganizationId = {organizationDepartmentOrOrganizations}) as TargetName " +
                            $"FROM dbo.DC_ORGANIZATION do " +
                            $"LEFT JOIN dbo.OrganizationNew orn ON do.OrganizationId=orn.OrganizationId " +
                            $"WHERE do.OrganizationStatus = 1 AND do.OrganizationId = {organizationId}";
                        break;
                    case 1: //1 olduqda movcud qurumun departamenti varsa departmenti yoxdursa umumi qurumu getirir
                        sqlQuery =
                            "SELECT isnull(orn.OrganizationName, do.OrganizationName) AS CurrentOrganizationName," +
                            $"(SELECT dd.DepartmentName FROM dbo.DC_DEPARTMENT dd WHERE dd.DepartmentStatus = 1 AND dd.DepartmentId = {organizationDepartmentOrOrganizations}) as TargetName " +
                            $"FROM dbo.DC_ORGANIZATION do LEFT JOIN dbo.OrganizationNew orn ON do.OrganizationId = orn.OrganizationId WHERE do.OrganizationStatus = 1 AND do.OrganizationId = {organizationId}";
                        break;
                    default:
                        break;
                }

                return UnitOfWork.ExecuteSqlQuery<ReportPdfHeading>(sqlQuery).FirstOrDefault();
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "GetReportHeading");
                throw;
            }
        }

        #region InExecutionDocsMethods

        public IEnumerable<JsonDocIds> GetReportInExecutionDocsIds(int executorOrganizationId, int workPlaceId,
            ReportInExecutionDocsFilter reportInExecutionDocsFilter)
        {
            var parameters = Extension.Init()
                .Add("@workPlaceId", workPlaceId)
                .Add("@docType", reportInExecutionDocsFilter.docTypeId)
                .Add("@executorOrganizationId", executorOrganizationId)
                .Add("@executorOrganizationType", reportInExecutionDocsFilter.executorOrganizationType)
                .Add("@organizationDepartmentOrOrganizations",
                    reportInExecutionDocsFilter.organizationDepartmentOrOrganizations)
                .Add("@beginDate", reportInExecutionDocsFilter.beginDate)
                .Add("@endDate", reportInExecutionDocsFilter.endDate)
                .Add("@topicType", reportInExecutionDocsFilter.topicType)
                .Add("@topicTypeEmployee", reportInExecutionDocsFilter.topicTypeEmployee)
                .Add("@topic", reportInExecutionDocsFilter.topic)
                .Add("@regions", reportInExecutionDocsFilter.regions)
                .Add("@villages", reportInExecutionDocsFilter.villages)
                .Add("@socialStatusId", reportInExecutionDocsFilter.socialStatusId)
                .Add("@docFormId", reportInExecutionDocsFilter.docFormId)
                .Add("@executorWorkPlaceId", reportInExecutionDocsFilter.executor)
                .Add("@docControlStatus", reportInExecutionDocsFilter.docControlStatus)
                .Add("@docControlStatusStructures", reportInExecutionDocsFilter.docControlStatusStructures)
                .Add("@docApplyType", reportInExecutionDocsFilter.docApplyType)
                .Add("@complainedOfDocStructure", reportInExecutionDocsFilter.complainedOfDocStructure)
                .Add("@complainedOfDocSubStructure", reportInExecutionDocsFilter.complainedOfDocSubStructure)
                .Add("@entryFromWhere", reportInExecutionDocsFilter.entryFromWhere)
                .Add("@remaningDay", reportInExecutionDocsFilter.remaningDay)
                .Add("@docResult", reportInExecutionDocsFilter.docResult);

            return UnitOfWork.ExecuteProcedure<JsonDocIds>("[report].[spGetReportInExecutionDocIds]", parameters);
        }

        public List<ReportInExecutionDocsModel> GetReportInExecutionDocsModels(int executorOrganizationId,
            int workPlaceId, ReportInExecutionDocsFilter reportInExecutionDocsFilter, out int totalItems,
            out int totalPages, int pageSize, int currentPage)
        {
            List<ReportInExecutionDocsModel> result = new List<ReportInExecutionDocsModel>();
            try
            {
                var docsIds =
                    GetReportInExecutionDocsIds(executorOrganizationId, workPlaceId, reportInExecutionDocsFilter);

                //paging
                totalItems = docsIds.Count();
                var resultIds = docsIds.Skip((currentPage - 1) * pageSize).Take(pageSize).ToList();
                totalPages = (int)Math.Ceiling((decimal)totalItems / (decimal)pageSize);

                var jsonData = JsonConvert.SerializeObject(resultIds.Select(x => x.DocId));

                var parameters = Extension.Init()
                    .Add("@docIds", jsonData)
                    .Add("@docType", reportInExecutionDocsFilter.docTypeId)
                    .Add("@remaningDay", reportInExecutionDocsFilter.remaningDay)
                    .Add("@workPlaceId", workPlaceId);

                result = UnitOfWork
                    .ExecuteProcedure<ReportInExecutionDocsModel>("[report].[spGetReportInExecutionDocs]", parameters)
                    .ToList();

                result.ForEach(row =>
                    row.TokenForDocId =
                        HttpUtility.UrlEncode(
                            CustomHelper.Encrypt($"{workPlaceId}-{DateTime.Now:dd.MM.yyyyHH:mm:ss}-{row.DocId}")));
                foreach (var row in result)
                {
                    row.TokenForDocId =
                        HttpUtility.UrlEncode(
                            CustomHelper.Encrypt($"{workPlaceId}-{DateTime.Now:dd.MM.yyyyHH:mm:ss}-{row.DocId}"));
                    if (row.ReplyDocIds != null)
                    {
                        string[] replyDocIds = row.ReplyDocIds.Split(',');
                        string[] replyDocNumbers = row.ReplyDocNumbers.Split(',');

                        for (int i = 0; i < replyDocIds.Length; i++)
                        {
                            row.ReplyDocNumbersForView.Add(
                                HttpUtility.UrlEncode(CustomHelper.Encrypt(
                                    $"{workPlaceId}-{DateTime.Now:dd.MM.yyyyHH:mm:ss}-{replyDocIds[i]}")),
                                replyDocNumbers[i]);
                        }
                    }

                    if (row.RelationDocIds != null)
                    {
                        string[] relationDocIds = row.RelationDocIds.Split(',');
                        string[] relationDocNumbers = row.RelationDocNumbers.Split(',');

                        for (int j = 0; j < relationDocIds.Length; j++)
                        {
                            var mm = relationDocIds[j];
                            row.RelationDocNumbersForView.Add(
                                HttpUtility.UrlEncode(CustomHelper.Encrypt(
                                    $"{workPlaceId}-{DateTime.Now:dd.MM.yyyyHH:mm:ss}-{relationDocIds[j]}")),
                                relationDocNumbers[j]);
                        }
                    }
                }

                ;
                return result;
            }
            catch (Exception ex)
            {
                result = null;
                totalItems = 0;
                totalPages = 0;
                Log.AddError(ex.Message, "GetReportInExecutionDocsModels");
                throw;
            }
        }

        public List<ReportInExecutionDocsModel> GetReportInExecutionDocsModelsForExcellOrPdf(int executorOrganizationId,
            int workPlaceId, ReportInExecutionDocsFilter reportInExecutionDocsFilter)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@workPlaceId", workPlaceId)
                    .Add("@docType", reportInExecutionDocsFilter.docTypeId)
                    .Add("@executorOrganizationId", executorOrganizationId)
                    .Add("@executorOrganizationType", reportInExecutionDocsFilter.executorOrganizationType)
                    .Add("@organizationDepartmentOrOrganizations",
                        reportInExecutionDocsFilter.organizationDepartmentOrOrganizations)
                    .Add("@remaningDay", reportInExecutionDocsFilter.remaningDay)
                    .Add("@beginDate", reportInExecutionDocsFilter.beginDate)
                    .Add("@endDate", reportInExecutionDocsFilter.endDate)
                    .Add("@topicType", reportInExecutionDocsFilter.topicType)
                    .Add("@topicTypeEmployee", reportInExecutionDocsFilter.topicTypeEmployee)
                    .Add("@topic", reportInExecutionDocsFilter.topic)
                    .Add("@socialStatusId", reportInExecutionDocsFilter.socialStatusId)
                    .Add("@docFormId", reportInExecutionDocsFilter.docFormId)
                    .Add("@docControlStatus", reportInExecutionDocsFilter.docControlStatus)
                    .Add("@docControlStatusStructures", reportInExecutionDocsFilter.docControlStatusStructures)
                    .Add("@docApplyType", reportInExecutionDocsFilter.docApplyType)
                    .Add("@complainedOfDocStructure", reportInExecutionDocsFilter.complainedOfDocStructure)
                    .Add("@complainedOfDocSubStructure", reportInExecutionDocsFilter.complainedOfDocSubStructure)
                    .Add("@executorWorkPlaceId", reportInExecutionDocsFilter.executor)
                    .Add("@entryFromWhere", reportInExecutionDocsFilter.entryFromWhere)
                    .Add("@entryFromWho", reportInExecutionDocsFilter.entryFromWho)
                    .Add("@regions", reportInExecutionDocsFilter.regions)
                    .Add("@villages", reportInExecutionDocsFilter.villages)
                    .Add("@entryFromWhoCitizenName", reportInExecutionDocsFilter.entryFromWhoCitizenName);


                UnitOfWork.Context.Database.CommandTimeout = 3600;

                return UnitOfWork
                    .ExecuteProcedure<ReportInExecutionDocsModel>("[report].[spGetReportInExecutionDocsToExcell]",
                        parameters).ToList();
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "spGetReportInExecutionDocs");
                throw;
            }
            //return result;
        }

        #endregion

        #region IsExecutedDocsMethods

        public List<ReportIsExecutedDocsModel> GetReportIsExecutedDocs(int executorOrganizationId, int workPlaceId,
            ReportIsExecutedDocsFilter reportIsExecutedDocsFilter, out int totalItems, out int totalPages, int pageSize,
            int currentPage)
        {
            List<ReportIsExecutedDocsModel> result = new List<ReportIsExecutedDocsModel>();
            try
            {
                var parameters = Extension.Init()
                    .Add("@workPlaceId", workPlaceId)
                    .Add("@docType", reportIsExecutedDocsFilter.docTypeId)
                    .Add("@executorOrganizationId", executorOrganizationId)
                    .Add("@executorOrganizationType", reportIsExecutedDocsFilter.executorOrganizationType)
                    .Add("@organizationDepartmentOrOrganizations",
                        reportIsExecutedDocsFilter.organizationDepartmentOrOrganizations)
                    .Add("@isExecutedStatus", reportIsExecutedDocsFilter.isExecutedStatus)
                    .Add("@beginDate", reportIsExecutedDocsFilter.beginDate)
                    .Add("@endDate", reportIsExecutedDocsFilter.endDate)
                    .Add("@topicType", reportIsExecutedDocsFilter.topicType)
                    .Add("@topicTypeEmployee", reportIsExecutedDocsFilter.topicTypeEmployee)
                    .Add("@topic", reportIsExecutedDocsFilter.topic)
                    .Add("@regions", reportIsExecutedDocsFilter.regions)
                    .Add("@villages", reportIsExecutedDocsFilter.villages)
                    .Add("@socialStatusId", reportIsExecutedDocsFilter.socialStatusId)
                    .Add("@docFormId", reportIsExecutedDocsFilter.docFormId)
                    .Add("@docApplyType", reportIsExecutedDocsFilter.docApplyType)
                    .Add("@complainedOfDocStructure", reportIsExecutedDocsFilter.complainedOfDocStructure)
                    .Add("@complainedOfDocSubStructure", reportIsExecutedDocsFilter.complainedOfDocSubStructure)
                    .Add("@docResult", reportIsExecutedDocsFilter.docResult)
                    .Add("@docControlStatus", reportIsExecutedDocsFilter.docControlStatus)
                    .Add("@docControlStatusStructures", reportIsExecutedDocsFilter.docControlStatusStructures)
                    .Add("@entryFromWhere", reportIsExecutedDocsFilter.entryFromWhere);


                UnitOfWork.Context.Database.CommandTimeout = 400;
                result = UnitOfWork
                    .ExecuteProcedure<ReportIsExecutedDocsModel>("[report].[spGetReportIsExecutedDocs]", parameters)
                    .ToList();

                totalItems = result.Count;
                totalPages = (int)Math.Ceiling((decimal)totalItems / (decimal)pageSize);
                result = result.Skip((currentPage - 1) * pageSize).Take(pageSize).ToList();


                GenerateDocsRelationDocsForIsExecutedDocs(result, workPlaceId);
                return result;
            }
            catch (Exception ex)
            {
                result = null;
                totalItems = 0;
                totalPages = 0;
                Log.AddError(ex.Message, "spGetReportIsExecutedDocs");
                throw;
            }
        }

        public List<ReportIsExecutedDocsModel> GetReportIsExecutedDocsForExcell(int executorOrganizationId,
            int workPlaceId, ReportIsExecutedDocsFilter reportIsExecutedDocsFilter)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@docType", reportIsExecutedDocsFilter.docTypeId)
                    .Add("@workPlaceId", workPlaceId)
                    .Add("@executorOrganizationId", executorOrganizationId)
                    .Add("@executorOrganizationType", reportIsExecutedDocsFilter.executorOrganizationType)
                    .Add("@organizationDepartmentOrOrganizations",
                        reportIsExecutedDocsFilter.organizationDepartmentOrOrganizations)
                    .Add("@isExecutedStatus", reportIsExecutedDocsFilter.isExecutedStatus)
                    .Add("@beginDate", reportIsExecutedDocsFilter.beginDate)
                    .Add("@endDate", reportIsExecutedDocsFilter.endDate)
                    .Add("@topicType", reportIsExecutedDocsFilter.topicType)
                    .Add("@topicTypeEmployee", reportIsExecutedDocsFilter.topicTypeEmployee)
                    .Add("@topic", reportIsExecutedDocsFilter.topic)
                    .Add("@socialStatusId", reportIsExecutedDocsFilter.socialStatusId)
                    .Add("@docFormId", reportIsExecutedDocsFilter.docFormId)
                    .Add("@docApplyType", reportIsExecutedDocsFilter.docApplyType)
                    .Add("@complainedOfDocStructure", reportIsExecutedDocsFilter.complainedOfDocStructure)
                    .Add("@complainedOfDocSubStructure", reportIsExecutedDocsFilter.complainedOfDocSubStructure)
                    .Add("@docResult", reportIsExecutedDocsFilter.docResult)
                    .Add("@docControlStatus", reportIsExecutedDocsFilter.docControlStatus)
                    .Add("@entryFromWhere", reportIsExecutedDocsFilter.entryFromWhere)
                    .Add("@regions", reportIsExecutedDocsFilter.regions)
                    .Add("@villages", reportIsExecutedDocsFilter.villages)
                    .Add("@docControlStatusStructures", reportIsExecutedDocsFilter.docControlStatusStructures);

                UnitOfWork.Context.Database.CommandTimeout = 400;
                var result = UnitOfWork
                    .ExecuteProcedure<ReportIsExecutedDocsModel>("[report].[spGetReportIsExecutedDocs]", parameters)
                    .ToList();

                GenerateDocsRelationDocsForIsExecutedDocs(result, workPlaceId);
                return result;
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "spGetReportIsExecutedDocsToExcell");
                throw;
            }
        }

        public void GetTaskPeriodForUpdateExecutionLog()
        {
            try
            {
                UnitOfWork.ExecuteNonQueryProcedure("[report].[spUpdateExecutionLogPeriodly]");
            }
            catch
            {
                throw;
            }
        }

        private void GenerateDocsRelationDocsForIsExecutedDocs(List<ReportIsExecutedDocsModel> result, int workPlaceId)
        {
            if (result is null || !result.Any())
                return;

            result.ForEach(row =>
                row.TokenForDocId =
                    HttpUtility.UrlEncode(
                        CustomHelper.Encrypt($"{workPlaceId}-{DateTime.Now:dd.MM.yyyyHH:mm:ss}-{row.DocId}")));
            foreach (var row in result)
            {
                row.TokenForDocId =
                    HttpUtility.UrlEncode(
                        CustomHelper.Encrypt($"{workPlaceId}-{DateTime.Now:dd.MM.yyyyHH:mm:ss}-{row.DocId}"));
                if (row.ReplyDocIds != null)
                {
                    string[] replyDocIds = row.ReplyDocIds.Split(',');
                    string[] replyDocNumbers = row.ReplyDocNumbers.Split(',');

                    for (int i = 0; i < replyDocIds.Length; i++)
                    {
                        row.ReplyDocNumbersForView.Add(
                            HttpUtility.UrlEncode(
                                CustomHelper.Encrypt(
                                    $"{workPlaceId}-{DateTime.Now:dd.MM.yyyyHH:mm:ss}-{replyDocIds[i]}")),
                            replyDocNumbers[i]);
                    }
                }

                if (row.RelationDocsJson != null)
                {
                    var tt = JsonConvert.DeserializeObject<List<RelationDocs>>(row.RelationDocsJson);

                    foreach (var item in tt)
                    {
                        row.RelationDocNumbersForView.Add(
                            HttpUtility.UrlEncode(CustomHelper.Encrypt(
                                $"{workPlaceId}-{DateTime.Now:dd.MM.yyyyHH:mm:ss}-{item.RelationDocid}")),
                            item.RelationDocNumber);
                    }

                    row.RelationDocNumbers = tt.Select(x => x.RelationDocNumber).Aggregate((x, y) => x + "," + y);
                }
            }

            ;
        }

        #endregion

        #region AllDocs

        public List<ReportAllDocsModel> GetReportAllDocs(int executorOrganizationId, int workPlaceId,
            ReportAllDocsFilter reportAllDocsFilter, out int totalItems, out int totalPages, int pageSize,
            int currentPage)
        {
            List<ReportAllDocsModel> result = new List<ReportAllDocsModel>();
            try
            {
                var parameters = Extension.Init()
                    .Add("@workPlaceId", workPlaceId)
                    .Add("@docType", reportAllDocsFilter.docTypeId)
                    .Add("@executorOrganizationId", executorOrganizationId)
                    .Add("@executorOrganizationType", reportAllDocsFilter.executorOrganizationType)
                    .Add("@organizationDepartmentOrOrganizations",
                        reportAllDocsFilter.organizationDepartmentOrOrganizations)
                    .Add("@beginDate", reportAllDocsFilter.beginDate)
                    .Add("@endDate", reportAllDocsFilter.endDate)
                    .Add("@topicType", reportAllDocsFilter.topicType)
                    .Add("@topicTypeEmployee", reportAllDocsFilter.topicTypeEmployee)
                    .Add("@topic", reportAllDocsFilter.topic)
                    .Add("@socialStatusId", reportAllDocsFilter.socialStatusId)
                    .Add("@docFormId", reportAllDocsFilter.docFormId)
                    .Add("@docResult", reportAllDocsFilter.docResult)
                    .Add("@docDocumentStatus", reportAllDocsFilter.docDocumentStatus)
                    .Add("@docApplyType", reportAllDocsFilter.docApplyType)
                    .Add("@complainedOfDocStructure", reportAllDocsFilter.complainedOfDocStructure)
                    .Add("@complainedOfDocSubStructure", reportAllDocsFilter.complainedOfDocSubStructure)
                    .Add("@regions", reportAllDocsFilter.regions)
                    .Add("@villages", reportAllDocsFilter.villages)
                    .Add("@docControlStatus", reportAllDocsFilter.docControlStatus)
                    .Add("@docControlStatusStructures", reportAllDocsFilter.docControlStatusStructures)
                    .Add("@entryFromWhere", reportAllDocsFilter.entryFromWhere)
                    .Add("@outgoingPerson", reportAllDocsFilter.outgoingPerson)
                    .Add("@outgoingWhomAddressed", reportAllDocsFilter.outgoingWhomAddressed)
                    .Add("@outgoingOrganization", reportAllDocsFilter.outgoingOrganization)
                    .Add("@outgoingSigner", reportAllDocsFilter.outgoingSigner)
                    .Add("@docFormIdOutgoing", reportAllDocsFilter.docFormIdOutgoing);

                UnitOfWork.Context.Database.CommandTimeout = 400;
                result = UnitOfWork.ExecuteProcedure<ReportAllDocsModel>("[report].[spGetReportAllDocs]", parameters)
                    .ToList();


                totalItems = result.Count();
                totalPages = (int)Math.Ceiling((decimal)totalItems / (decimal)pageSize);
                result = result.Skip((currentPage - 1) * pageSize).Take(pageSize).ToList();

                GenerateDocsRelationDocs(result, workPlaceId);
                return result;
            }
            catch (Exception ex)
            {
                result = null;
                totalItems = 0;
                totalPages = 0;
                Log.AddError(ex.Message, "AllDocsReport");
                throw;
            }
        }


        private void GenerateDocsRelationDocs(List<ReportAllDocsModel> result, int workPlaceId)
        {
            if (result is null || !result.Any())
                return;

            result.ForEach(row =>
                row.TokenForDocId =
                    HttpUtility.UrlEncode(
                        CustomHelper.Encrypt($"{workPlaceId}-{DateTime.Now:dd.MM.yyyyHH:mm:ss}-{row.DocId}")));
            foreach (var row in result)
            {
                row.TokenForDocId =
                    HttpUtility.UrlEncode(
                        CustomHelper.Encrypt($"{workPlaceId}-{DateTime.Now:dd.MM.yyyyHH:mm:ss}-{row.DocId}"));
                if (row.ReplyDocIds != null)
                {
                    string[] replyDocIds = row.ReplyDocIds.Split(',');
                    string[] replyDocNumbers = row.ReplyDocNumbers.Split(',');

                    for (int i = 0; i < replyDocIds.Length; i++)
                    {
                        row.ReplyDocNumbersForView.Add(
                            HttpUtility.UrlEncode(
                                CustomHelper.Encrypt(
                                    $"{workPlaceId}-{DateTime.Now:dd.MM.yyyyHH:mm:ss}-{replyDocIds[i]}")),
                            replyDocNumbers[i]);
                    }
                }

                if (row.RelationDocsJson != null)
                {
                    var tt = JsonConvert.DeserializeObject<List<RelationDocs>>(row.RelationDocsJson);

                    foreach (var item in tt)
                    {
                        row.RelationDocNumbersForView.Add(
                            HttpUtility.UrlEncode(CustomHelper.Encrypt(
                                $"{workPlaceId}-{DateTime.Now:dd.MM.yyyyHH:mm:ss}-{item.RelationDocid}")),
                            item.RelationDocNumber);
                    }

                    row.RelationDocNumbers = tt.Select(x => x.RelationDocNumber).Aggregate((x, y) => x + "," + y);
                }
                if (row.IncomingDocsJson != null)
                {
                    var tt = JsonConvert.DeserializeObject<List<IncomingDocs>>(row.IncomingDocsJson);

                    foreach (var item in tt)
                    {
                        row.IncomingDocNumbersForView.Add(
                            HttpUtility.UrlEncode(CustomHelper.Encrypt(
                                $"{workPlaceId}-{DateTime.Now:dd.MM.yyyyHH:mm:ss}-{item.IncomingDocid}")),
                            item.IncomingDocNumber);
                        row.IncomingDocDatesForView.Add(
                            HttpUtility.UrlEncode(CustomHelper.Encrypt(
                                $"{workPlaceId}-{DateTime.Now:dd.MM.yyyyHH:mm:ss}-{item.IncomingDocid}")),
                            item.IncomingDocDate.ToString().Substring(0, 10));
                    }

                    row.IncomingDocNumbers = tt.Select(x => x.IncomingDocNumber).Aggregate((x, y) => x + "," + y);
                    row.IncomingDocDates = tt.Select(x => x.IncomingDocDate.ToString().Substring(0,10)).Aggregate((x, y) => x + "," + y);
                }
            }

            ;
        }

        public List<ReportAllDocsModel> GetReportAllDocsForExcell(int executorOrganizationId, int workPlaceId,
            ReportAllDocsFilter reportAllDocsFilter)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@workPlaceId", workPlaceId)
                    .Add("@docType", reportAllDocsFilter.docTypeId)
                    .Add("@executorOrganizationId", executorOrganizationId)
                    .Add("@executorOrganizationType", reportAllDocsFilter.executorOrganizationType)
                    .Add("@organizationDepartmentOrOrganizations",
                        reportAllDocsFilter.organizationDepartmentOrOrganizations)
                    .Add("@beginDate", reportAllDocsFilter.beginDate)
                    .Add("@endDate", reportAllDocsFilter.endDate)
                    .Add("@topicType", reportAllDocsFilter.topicType)
                    .Add("@topicTypeEmployee", reportAllDocsFilter.topicTypeEmployee)
                    .Add("@topic", reportAllDocsFilter.topic)
                    .Add("@socialStatusId", reportAllDocsFilter.socialStatusId)
                    .Add("@docFormId", reportAllDocsFilter.docFormId)
                    .Add("@docResult", reportAllDocsFilter.docResult)
                    .Add("@docDocumentStatus", reportAllDocsFilter.docDocumentStatus)
                    .Add("@complainedOfDocStructure", reportAllDocsFilter.complainedOfDocStructure)
                    .Add("@complainedOfDocSubStructure", reportAllDocsFilter.complainedOfDocSubStructure)
                    .Add("@docApplyType", reportAllDocsFilter.docApplyType)
                    .Add("@docControlStatus", reportAllDocsFilter.docControlStatus)
                    .Add("@docControlStatusStructures", reportAllDocsFilter.docControlStatusStructures)
                    .Add("@entryFromWhere", reportAllDocsFilter.entryFromWhere)
                    .Add("@regions", reportAllDocsFilter.regions)
                    .Add("@villages", reportAllDocsFilter.villages)
                    .Add("@outgoingPerson", reportAllDocsFilter.outgoingPerson)
                    .Add("@outgoingWhomAddressed", reportAllDocsFilter.outgoingWhomAddressed)
                    .Add("@outgoingOrganization", reportAllDocsFilter.outgoingOrganization)
                    .Add("@outgoingSigner", reportAllDocsFilter.outgoingSigner)
                    .Add("@docFormIdOutgoing", reportAllDocsFilter.docFormIdOutgoing);


                UnitOfWork.Context.Database.CommandTimeout = 400;
                var result = UnitOfWork
                    .ExecuteProcedure<ReportAllDocsModel>("[report].[spGetReportAllDocs]", parameters).ToList();

                GenerateDocsRelationDocs(result, workPlaceId);

                return result;
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "AllDocsReport");
                throw;
            }
        }

        #endregion

        #region ForInformationDocs

        public List<ReportForInformationDocsModel> GetReportForInformationDocsModelsDocs(int executorOrganizationId, int workPlaceId,
            ReportForInformationDocsFilter reportForInformationDocsFilter, out int totalItems, out int totalPages, int pageSize,
            int currentPage)
        {
            List<ReportForInformationDocsModel> result = new List<ReportForInformationDocsModel>();
            try
            {
                var parameters = Extension.Init()
                    .Add("@workPlaceId", workPlaceId)
                    .Add("@docType", reportForInformationDocsFilter.docTypeId)
                    .Add("@executorOrganizationId", executorOrganizationId)
                    .Add("@executorOrganizationType", reportForInformationDocsFilter.executorOrganizationType)
                    .Add("@organizationDepartmentOrOrganizations", reportForInformationDocsFilter.organizationDepartmentOrOrganizations)
                    .Add("@beginDate", reportForInformationDocsFilter.beginDate)
                    .Add("@endDate", reportForInformationDocsFilter.endDate)
                    .Add("@complainedOfDocStructure", reportForInformationDocsFilter.complainedOfDocStructure)
                    .Add("@complainedOfDocSubStructure", reportForInformationDocsFilter.complainedOfDocSubStructure)
                    .Add("@docDocumentStatus", reportForInformationDocsFilter.docDocumentStatus)
                    .Add("@docControlStatus", reportForInformationDocsFilter.docControlStatus)
                    .Add("@docControlStatusStructures", reportForInformationDocsFilter.docControlStatusStructures)
                    .Add("@topicType", reportForInformationDocsFilter.topicType)
                    .Add("@topicTypeEmployee", reportForInformationDocsFilter.topicTypeEmployee)
                    .Add("@topic", reportForInformationDocsFilter.topic)
                    .Add("@regions", reportForInformationDocsFilter.regions)
                    .Add("@villages", reportForInformationDocsFilter.villages)
                    .Add("@socialStatusId", reportForInformationDocsFilter.socialStatusId)
                    .Add("@docFormId", reportForInformationDocsFilter.docFormId)
                    .Add("@docApplyType", reportForInformationDocsFilter.docApplyType)
                    .Add("@entryFromWhere", reportForInformationDocsFilter.entryFromWhere);

                UnitOfWork.Context.Database.CommandTimeout = 400;
                result = UnitOfWork.ExecuteProcedure<ReportForInformationDocsModel>("[report].[spGetReportForInformationDocs]", parameters)
                    .ToList();


                totalItems = result.Count();
                totalPages = (int)Math.Ceiling((decimal)totalItems / (decimal)pageSize);
                result = result.Skip((currentPage - 1) * pageSize).Take(pageSize).ToList();

                GenerateDocsRelationDocs(result, workPlaceId);
                return result;
            }
            catch (Exception ex)
            {
                result = null;
                totalItems = 0;
                totalPages = 0;
                Log.AddError(ex.Message, "ForInformationDocsReport");
                throw;
            }
        }


        private void GenerateDocsRelationDocs(List<ReportForInformationDocsModel> result, int workPlaceId)
        {
            if (result is null || !result.Any())
                return;

            result.ForEach(row =>
                row.TokenForDocId =
                    HttpUtility.UrlEncode(
                        CustomHelper.Encrypt($"{workPlaceId}-{DateTime.Now:dd.MM.yyyyHH:mm:ss}-{row.DocId}")));
            foreach (var row in result)
            {
                if (row.RelationDocsJson != null)
                {
                    var tt = JsonConvert.DeserializeObject<List<RelationDocs>>(row.RelationDocsJson);

                    foreach (var item in tt)
                    {
                        row.RelationDocNumbersForView.Add(
                            HttpUtility.UrlEncode(CustomHelper.Encrypt(
                                $"{workPlaceId}-{DateTime.Now:dd.MM.yyyyHH:mm:ss}-{item.RelationDocid}")),
                            item.RelationDocNumber);
                    }

                    row.RelationDocNumbers = tt.Select(x => x.RelationDocNumber).Aggregate((x, y) => x + "," + y);
                }
            }

            ;
        }

        public List<ReportForInformationDocsModel> GetReportForInformationDocsForExcell(int executorOrganizationId, int workPlaceId,
            ReportForInformationDocsFilter reportForInformationDocsFilter)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@workPlaceId", workPlaceId)
                    .Add("@docType", reportForInformationDocsFilter.docTypeId)
                    .Add("@executorOrganizationId", executorOrganizationId)
                    .Add("@executorOrganizationType", reportForInformationDocsFilter.executorOrganizationType)
                    .Add("@organizationDepartmentOrOrganizations", reportForInformationDocsFilter.organizationDepartmentOrOrganizations)
                    .Add("@beginDate", reportForInformationDocsFilter.beginDate)
                    .Add("@endDate", reportForInformationDocsFilter.endDate)
                    .Add("@complainedOfDocStructure", reportForInformationDocsFilter.complainedOfDocStructure)
                    .Add("@complainedOfDocSubStructure", reportForInformationDocsFilter.complainedOfDocSubStructure)
                    .Add("@docDocumentStatus", reportForInformationDocsFilter.docDocumentStatus)
                    .Add("@docControlStatus", reportForInformationDocsFilter.docControlStatus)
                    .Add("@docControlStatusStructures", reportForInformationDocsFilter.docControlStatusStructures)
                    .Add("@topicType", reportForInformationDocsFilter.topicType)
                    .Add("@topicTypeEmployee", reportForInformationDocsFilter.topicTypeEmployee)
                    .Add("@topic", reportForInformationDocsFilter.topic)
                    .Add("@regions", reportForInformationDocsFilter.regions)
                    .Add("@villages", reportForInformationDocsFilter.villages)
                    .Add("@socialStatusId", reportForInformationDocsFilter.socialStatusId)
                    .Add("@docFormId", reportForInformationDocsFilter.docFormId)
                    .Add("@docApplyType", reportForInformationDocsFilter.docApplyType)
                    .Add("@entryFromWhere", reportForInformationDocsFilter.entryFromWhere);

                UnitOfWork.Context.Database.CommandTimeout = 400;
                var result = UnitOfWork
                    .ExecuteProcedure<ReportForInformationDocsModel>("[report].[spGetReportForInformationDocs]", parameters).ToList();

                GenerateDocsRelationDocs(result, workPlaceId);

                return result;
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "ForInformationDocsReport");
                throw;
            }
        }

        #endregion

        #endregion

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