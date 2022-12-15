using Admin.Common.Enums;
using Admin.Model.ViewModel;
using BLL.BaseAdapter;
using BLL.Models.Direction.Direction;
using BLL.Models.Document;
using DMSModel;
using Model.DB_Tables;
using Repository.Extensions;
using Repository.Infrastructure;
using System;
using System.Collections.Generic;
using System.Linq;
using ExecutorModel = Admin.Model.ViewModel.ExecutorModel;

namespace Admin.Adapters
{
    public static class DocumentAdapter
    {
        private static object unitOfWork;

        public static DeleteResolutionViewModel GetInfo(this IUnitOfWork unitOfWork, string docenterno, int pageIndex, int pageSize)
        {

            List<DeleteResolutionModel> result = new List<DeleteResolutionModel>();
            var parameters = Extension.Init()
                 .Add("@docenterno", docenterno);


            var data = unitOfWork.ExecuteProcedure<DeleteResolutionModel>("dbo.[adminGetInfo]", parameters).ToList();
            var totalCount = data.Count();
            result = data.Skip((pageIndex - 1) * pageSize).Take(pageSize).ToList();
            var totalPages = (int)Math.Ceiling((decimal)totalCount / (decimal)pageSize);

            var viewModel = new DeleteResolutionViewModel
            {
                TotalCount = totalCount,
                Items = result
            };
            return viewModel;
        }

        public static int DeleteResolutionInfo(this IUnitOfWork unitOfWork, int docid, int executorworkplaceid, int directionid, int operationtype, int workplaceid, string ip, int sendstatus)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@docid", docid)
                    .Add("@executorworkplaceid", executorworkplaceid)
                    .Add("@directionid", directionid)
                    .Add("@operationtype", operationtype)
                    .Add("@workplaceid", workplaceid)
                    .Add("@ip", ip)
                    .Add("@sendstatus", sendstatus);

                unitOfWork.ExecuteNonQueryProcedure("dbo.[adminDeleteResolution]", parameters);

                return 1;
            }
            catch (Exception)
            {
                throw;
            }

        }


        public static List<CreateResolutionRoleModel> SelectUser(this IUnitOfWork unitOfWork)
        {

            List<CreateResolutionRoleModel> result = new List<CreateResolutionRoleModel>();
            var parameters = Extension.Init();


            var data = unitOfWork.ExecuteProcedure<CreateResolutionRoleModel>("dbo.[adminGetUserforResolution]", parameters).ToList();
            result = data.ToList();
            return result;
        }

        public static int AddResolutionUser(this IUnitOfWork unitOfWork, int workplaceid1, int workplaceid2, int workplaceid, string ip)
        {
            try
            {
                var parameters = Extension.Init()
                 .Add("@workplaceid1", workplaceid1)
                 .Add("@workplaceid2", workplaceid2)
                 .Add("@workplaceid", workplaceid)
                 .Add("@ip", ip);


                unitOfWork.ExecuteProcedure<CreateResolutionRoleModel>("dbo.[adminAddResolutionRole]", parameters);


                return 1;
            }
            catch (Exception)
            {
                throw;
            }
        }


        public static List<ExecutorModel> GetExecutor(this IUnitOfWork unitOfWork, int doctype, string docno)
        {

            List<ExecutorModel> result = new List<ExecutorModel>();
            var parameters = Extension.Init()
                .Add("@docno", docno)
                .Add("@doctype", doctype);


            var data = unitOfWork.ExecuteProcedure<ExecutorModel>("dbo.[adminEditDocOperation]", parameters).ToList();
            result = data.ToList();
            return result;
        }

        public static int AddDocsEditWorkplace(this IUnitOfWork unitOfWork, int doctype, string docno, int execworkplaceid, int workplaceid, string ip)
        {
            try
            {
                var parameters = Extension.Init()
                 .Add("@docno", docno)
                 .Add("@doctype", doctype)
                 .Add("@execworkplaceid", execworkplaceid)
                 .Add("@ip", ip)
                 .Add("@workplaceid", workplaceid);


                unitOfWork.ExecuteProcedure<CreateResolutionRoleModel>("dbo.[adminEditDocOperation]", parameters);


                return 1;
            }
            catch (Exception)
            {
                throw;
            }
        }
        public static int AddExecutorForDirection(this IUnitOfWork unitOfWork, int directionworkplaceid, int executorworkplaceid, string checkvalue, DateTime inserteddate, int userworkplaceid)
        {
            try
            {
                var parameters = Extension.Init()
                 .Add("@directionworkplaceid", directionworkplaceid)
                 .Add("@executorworkplaceid", executorworkplaceid)
                 .Add("@checkvalue", checkvalue)
                 .Add("@inserteddate", inserteddate)
                 .Add("@userworkplaceid", userworkplaceid);

                unitOfWork.ExecuteNonQueryProcedure("[admin].[AddAndDeleteExecutorForDirection]", parameters);

                return 1;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public static int GetDocStatus(this IUnitOfWork unitOfWork, int docId)
        {

            var param = Extension.Init()
                .Add("@docId", docId);

            int result = unitOfWork.ExecuteScalar<int>("SELECT [dbo].[fnGetCurrentDocStatus](@docId)", param);

            return result;
        }

        public static List<ChooseModel> GetDocStatusList(this IUnitOfWork unitOfWork)
        {
            return unitOfWork.GetRepository<DOC_DOCUMENTSTATUS>()
                .GetAll(d => d.DocumentstatusStatus)
                .Select(x => new ChooseModel
                {
                    Id = x.DocumentstatusId,
                    Name = x.DocumentstatusName
                }).ToList();
        }
        public static List<ChooseModel> GetDocUnderControlStatusList(this IUnitOfWork unitOfWork)
        {
            return unitOfWork.GetRepository<DOC_UNDERCONTROLSTATUS>()
                .GetAll()
                .Select(x => new ChooseModel
                {
                    Id = x.UnderControlStatusValue,
                    Name = x.UnderControlStatusName
                }).ToList();
        }
        public static DOC GetDocById(this IUnitOfWork unitOfWork, int docId)
        {
            return unitOfWork.GetRepository<DOC>()
                .GetAll(d => d.DocId == docId)
                .FirstOrDefault();
        }
        public static void ChangeDocStatus(this IUnitOfWork unitOfWork, int docId, int docStatus,int docUnderControlStatus)
        {
            try
            {
                var parameters = Extension.Init()
                    
                    .Add("@docid", docId)
                    .Add("@docStatus", docStatus)
                    .Add("@docUnderControlStatus", docUnderControlStatus)
                    ;

                unitOfWork.ExecuteNonQueryProcedure("[admin].[EditDocumentParameters]", parameters);
            }
            catch (Exception)
            {
                throw;
            }
        }

    }



}

