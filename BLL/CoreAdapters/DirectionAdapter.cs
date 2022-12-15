using BLL.Models.Direction.Direction;
using Repository.Extensions;
using Repository.Infrastructure;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace BLL.Adapters
{
    static public class DirectionAdapter
    {
        static public IEnumerable<T> GetDirection<T>(this IUnitOfWork unitOfWork, int? docId, int workPlaceId, int resolution, int? pageIndex, int pageSize, out int totalCount, int? executorId = 0) where T : class
        {
            try
            {
                totalCount = 0;

                var parameters = Extension.Init().Add("@docId", docId)
                    .Add("@workPlaceId", workPlaceId)
                    .Add("@redirectTypeId", resolution)
                    .Add("@pageIndex", pageIndex)
                    .Add("@pageSize", pageSize)
                    .Add("@totalCount", totalCount, direction: ParameterDirection.Output);
                var data = unitOfWork.ExecuteProcedure<T>("exec [resolution].[spGetDirections]", parameters);
                totalCount = Convert.ToInt32(parameters.FirstOrDefault(p => p.ParameterName == "@totalCount").Value);
                return data;
            }
            catch(Exception ex)
            {
                throw;
            }
        }

        static public IEnumerable<T> GetDocsInfo<T>(this IUnitOfWork unitOfWork, int docId) where T : class
        {
            try
            {
                var parameters = Extension.Init().Add("@docId", docId);
                var data = unitOfWork.ExecuteProcedure<T>("exec [resolution].[spGetDocsInfo]", parameters);

                return data;
            }
            catch(Exception ex)
            {
                throw;
            }
        }

        static public IEnumerable<T> GetDirectionDocs<T>(this IUnitOfWork unitOfWork, int? docId, int directionId, int? workplaceId) where T : class
        {
            try
            {
                var parameters = Extension.Init().Add("@docId", docId)
                     .Add("@directionId", directionId)
                    .Add("@workplaceId", workplaceId);
                var data = unitOfWork.ExecuteProcedure<T>("exec [resolution].[spGetDirectionDocs]", parameters);
                return data;
            }
            catch(Exception ex)
            {
                throw;
            }
        }

        static public IEnumerable<T> GetDirectionExecutors<T>(this IUnitOfWork unitOfWork, int directionId, int? directionWorkplaceId) where T : class
        {
            try
            {
                var parameters = Extension.Init().Add("@directionId", directionId).
                    Add("@directionWorkplaceId", directionWorkplaceId);
                var data = unitOfWork.ExecuteProcedure<T>("exec [resolution].[GetDirectionExecutors]", parameters);
                return data;
            }
            catch(Exception ex)
            {
                throw;
            }
        }

        public static IEnumerable<T> GetWorkplaceFullInfo<T>(this IUnitOfWork unitOfWork, int workplaceId) where T : class
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@workPlaceId", workplaceId);

                var data = unitOfWork.ExecuteProcedure<T>("exec [resolution].[spWorkplaceFullInfo]", parameters);
                return data;
            }
            catch(Exception ex)
            {
                throw;
            }
        }

        static public IEnumerable<T> GetWorkplaceFullInfo<T>(this IUnitOfWork unitOfWork, int workplaceId, out int result) where T : class
        {
            try
            {
                var parameters = Extension.Init()
                                                .Add("@workPlaceId", workplaceId)
                                                .Add("@result", 1, ParameterDirection.InputOutput);

                var data = unitOfWork.ExecuteProcedure<T>("exec [resolution].[spWorkplaceFullInfo]", parameters);
                result = Convert.ToInt32(parameters.FirstOrDefault(p => p.ParameterName == "@result")?.Value);
                return data;
            }
            catch(Exception ex)
            {
                throw;
            }
        }
        static public IEnumerable<T> AddExecutor<T>(this IUnitOfWork unitOfWork, IEnumerable<ExecutorModel> executorList, int directionId, int directionTypeId, DirectionModel direction) where T : class
        {
            try
            {
                var table = CustomHelpers.Extensions.ToDataTable(executorList);

                var parameters = Extension.Init().Add("@executorList", table, "dbo.UdttDirectionExecutor")
                     .Add("@directionControlStatus", direction.DirectionControlStatus)
                 .Add("@directionPlanneddate", direction.DirectionPlanneddate)
                    .Add("@directionId", directionId)
                 .Add("@directionTypeId", directionTypeId);
                var data = unitOfWork.ExecuteProcedure<T>("exec [resolution].[spAddExecutorBulk] ", parameters);
                return data;
            }
            catch(Exception ex)
            {
                throw;
            }
        }

        static public IEnumerable<T> AddDirection<T>(this IUnitOfWork unitOfWork, DirectionModel directionModel, IEnumerable<ExecutorModel> executorList, int operationtype) where T : class
        {
            try
            {
                var table = CustomHelpers.Extensions.ToDataTable(executorList);

                var parameters = Extension.Init()
                     .Add("@operationtype", operationtype)
                    .Add("@directionId", directionModel.DirectionId)
                    .Add("@directionDate", directionModel.DirectionDate)
                    .Add("@directionDocId", directionModel.DirectionDocId)
                    .Add("@directionTypeId", directionModel.DirectionTypeId)
                    .Add("@directionWorkplaceId", directionModel.DirectionWorkplaceId)
                    .Add("@directionInsertedDate", directionModel.DirectionInsertedDate)
                    .Add("@directionPersonFullName", directionModel.DirectionPersonFullName)
                   .Add("@directionCreatorWorkplaceId", directionModel.DirectionCreatorWorkplaceId)
                   .Add("@directionControlStatus", directionModel.DirectionControlStatus)
                   .Add("@directionPlanneddate", directionModel.DirectionPlanneddate)
                    .Add("@directionConfirmed", directionModel.DirectionConfirmed)
                    .Add("@directionSendStatus", directionModel.DirectionSendStatus)
                .Add("@directionUnixTime", directionModel.DirectionUnixTime)
                .Add("@executorList", table, "dbo.UdttDirectionExecutor");

                var data = unitOfWork.ExecuteProcedure<T>("exec [resolution].[AddDirectionNew]", parameters);
                return data;
            }
            catch(Exception ex)
            {
                throw;
            }
        }

        static public IEnumerable<T> GetInfo<T>(this IUnitOfWork unitOfWork, int docId, int docTypeId) where T : class
        {
            try
            {
                var parameters = Extension.Init().Add("@docId", docId)
                 .Add("@docTypeId", docTypeId);
                var data = unitOfWork.ExecuteProcedure<T>("exec [resolution].[spGetDirectionInfo] ", parameters);
                return data;
            }
            catch(Exception ex)
            {
                throw;
            }
        }

        static public IEnumerable<T> DeleteDirection<T>(this IUnitOfWork unitOfWork, int directionId) where T : class
        {
            try
            {
                var parameters = Extension.Init().Add("@directionId", directionId);
                var data = unitOfWork.ExecuteProcedure<T>("exec [resolution].[spDeleteDirection]", parameters);
                return data;
            }
            catch(Exception ex)
            {
                throw;
            }
        }

        static public IEnumerable<T> GetAuthorForDirection<T>(this IUnitOfWork unitOfWork, int docId, int directionId, int directionConfirmedId, int directionCreatorWorkplaceId, int directionWorkplaceId) where T : class
        {
            try
            {
                var parameters = Extension.Init()
                   .Add("@docId", docId)
                   .Add("@directionId", directionId)
                   .Add("@directionConfirmedId", directionConfirmedId)
                   .Add("@directionCreatorWorkplaceId", directionCreatorWorkplaceId)
                   .Add("@directionWorkplaceId", directionWorkplaceId);
                var data = unitOfWork.ExecuteProcedure<T>("exec [resolution].[GetAuthors]", parameters);
                return data;
            }
            catch(Exception ex)
            {
                throw;
            }
        }

        static public IEnumerable<T> GetDirectionInfo<T>(this IUnitOfWork unitOfWork, int docId, int directionId) where T : class
        {
            try
            {
                var parameters = Extension.Init().Add("@docId", docId)
                    .Add("@directionId", directionId);

                var data = unitOfWork.ExecuteProcedure<T>("exec [resolution].[GetExecutors]", parameters);
                return data;
            }
            catch(Exception ex)
            {
                throw;
            }
        }

        static public IEnumerable<T> GetUsers<T>(this IUnitOfWork unitOfWork, int author, int docid, List<SqlParameter> @params = null) where T : class
        {
            try
            {
                var parameters = Extension.Init().Add("@workplaceId", author)
                    .Add("@docId", docid);
                if(@params != null)
                    parameters.AddRange(@params.ToArray());

                var data = unitOfWork.ExecuteProcedure<T>("exec [resolution].[spUsers]", parameters);

                return data;
            }
            catch(Exception ex)
            {
                throw;
            }
        }

        static public IEnumerable<T> ChangeExecutor<T>(this IUnitOfWork unitOfWork, int? changeType, int? directioId, int command, int docTypeId, int? newWorkplaceId, string resolutionNote, int docId, int directionTypeId, int? currentWorkplaceId, bool? jointExecutor) where T : class
        {
            try
            {
                //  var table = CustomHelpers.Extensions.ToDataTable(executorList);

                var parameters = Extension.Init()
                    .Add("@operation", command)
                    .Add("@docTypeId", docTypeId)
                    .Add("@currentWorkplaceId", currentWorkplaceId)
                    .Add("@docId", docId)
                    .Add("@executorResolutionNote", resolutionNote)
                    .Add("@directionTypeId", directionTypeId)
                    .Add("@newWorkplaceId", newWorkplaceId)
                    .Add("@directionId", directioId)
                    .Add("@jointExecutor", jointExecutor = jointExecutor == null ? true : jointExecutor);
                var data = unitOfWork.ExecuteProcedure<T>("[resolution].[ChangeExecutor]", parameters);
                return data;
            }
            catch(Exception ex)
            {
                throw;
            }
        }

        static public int GetAuthorWorkplace(this IUnitOfWork unitOfWork, int docId, int workplaceId)
        {
            try
            {
                var parameter = Extension.Init().Add("@docId", docId)
                    .Add("@workplaceId", workplaceId);
                return unitOfWork.ExecuteScalar<int>("SELECT [resolution].[fnGetAuthoWorkplaceId](@workPlaceId,@docId)", parameter);
            }
            catch(Exception ex)
            {
                throw;
            }
        }

        static public IEnumerable<T> GetOldExecutor<T>(this IUnitOfWork unitOfWork, int id) where T : class
        {
            try
            {
                var parameter = Extension.Init().Add("@directionId", id);
                var data = unitOfWork.ExecuteProcedure<T>("exec  [resolution].[GetChangedExecutor]", parameter);
                return data;
            }
            catch(Exception ex)
            {
                throw;
            }
        }

        static public DateTime? GetExecutionDate(this IUnitOfWork unitOfWork, int docId)
        {
            try
            {
                var parameter = Extension.Init().Add("@docId", docId);
                return unitOfWork.ExecuteScalar<DateTime?>("select DocPlannedDate from DOCS where DocId=@docId", parameter);
            }
            catch(Exception ex)
            {
                throw;
            }
        }

        static public IEnumerable<T> ChangeExecutionDate<T>(this IUnitOfWork unitOfWork, int? changeType, int? directionId, int command, int docTypeId, int currentWorkplaceId, string resolutionNote, int docId, int directionTypeId, DateTime? newDirectionPlannedDate) where T : class
        {
            try
            {
                //  var table = CustomHelpers.Extensions.ToDataTable(executorList);

                var parameters = Extension.Init()
                    .Add("@operation", command)
                    .Add("@docTypeId", docTypeId)
                    .Add("@currentWorkplaceId", currentWorkplaceId)
                    .Add("@docId", docId)
                    .Add("@executorResolutionNote", resolutionNote)
                 .Add("@directionTypeId", directionTypeId)
                 .Add("@newDirectionPlannedDate", newDirectionPlannedDate)
                      .Add("@directionId ", directionId);
                var data = unitOfWork.ExecuteProcedure<T>("exec  [resolution].[ChangeExecutionDate]", parameters);
                return data;
            }
            catch(Exception ex)
            {
                throw;
            }
        }

        static public IEnumerable<T> GetChangedDate<T>(this IUnitOfWork unitOfWork, int docId) where T : class
        {
            try
            {
                var parameter = Extension.Init()
                    .Add("@docId", docId);
                var data = unitOfWork.ExecuteProcedure<T>("exec  [resolution].[GetChangedDateTime]", parameter);
                return data;
            }
            catch(Exception ex)
            {
                throw;
            }
        }

        static public IEnumerable<T> GetInfoExecutors<T>(this IUnitOfWork unitOfWork, int docId, int workplaceid) where T : class
        {
            try
            {
                var parameter = Extension.Init()
                     .Add("@executorWorkplaceId", workplaceid)
                    .Add("@docId", docId);
                var data = unitOfWork.ExecuteProcedure<T>("exec  [resolution].[GetSendStatus]", parameter);
                return data;
            }
            catch(Exception ex)
            {
                throw;
            }
        }
       
        static public string GetInfoDirection(this IUnitOfWork unitOfWork, int docId, int workplaceid)
        {
            try
            {
                var parameter = Extension.Init()
                     .Add("@workplaceId", workplaceid)
                    .Add("@docId", docId);
                var data = unitOfWork.ExecuteScalar<string>("SELECT [resolution].[fnGetFullNameByDocId](@workPlaceId,@docId)", parameter);            
                return data;
            }
            catch (Exception ex)
            {
                throw;
            }
        }

    }
}