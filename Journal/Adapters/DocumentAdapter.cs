using AutoMapper;
using Journal.Model.EntityModel;
using Newtonsoft.Json;
using Repository.Extensions;
using Repository.Infrastructure;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using DocumentViewModel = JournalLib.Model.EntityModel.DocumentViewModel;

namespace Journal.Adapters
{
    public static class JournalAdapter
    {
        private static object unitOfWork;

        public static object GetJournal(this IUnitOfWork unitOfWork, int type, int docid, int year, int pageIndex,
            int pageSize, int organizationId, int doctypeid, List<SqlParameter> searchParams)
        {
            int skip = pageSize * ((pageIndex == 0 ? 1 : pageIndex) - 1);
            var parameters = Extension.Init()
                .Add("@type", type)
                .Add("@docid", docid)
                .Add("@year", year)
                .Add("@organizationId", organizationId)
                .Add("@skip", skip)
                .Add("@pageSize", pageSize)
                .Add("@doctypeid", doctypeid)
                .Add("@totalCount", 0, ParameterDirection.InputOutput);
            parameters.AddRange(searchParams);

            dynamic data = unitOfWork.ExecuteProcedure<DocumentModel>("dbo.[JournalInfo]", parameters).ToList();

            var totalCount = (int) parameters.First(x => x.ParameterName == "@totalCount").Value;
            dynamic dataView = data;

            if (doctypeid != 3)
                dataView = Mapper.Map<List<DocumentModelDto>>(data);

            var viewModel = new
            {
                TotalCount = totalCount,
                Items = dataView
            };
            return viewModel;
        }

        public static IEnumerable<DocumentModel> GetNoteArchive(this IUnitOfWork unitOfWork, int type, int docid,
            int year, int docType)
        {
            List<DocumentModel> result = new List<DocumentModel>();
            var parameters = Extension.Init()
                .Add("@type", type)
                .Add("@docid", docid)
                .Add("@year", year)
                .Add("@doctypeid", docType)
                .Add("@totalCount",0,ParameterDirection.InputOutput);

            var data = unitOfWork.ExecuteProcedure<DocumentModel>("dbo.[JournalInfo]", parameters).ToList();
            result = data.ToList();
            return result;
        }


        public static int EditNote(this IUnitOfWork unitOfWork, int docid, string note, int userId, int docType)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@docid", docid)
                    .Add("@note", note)
                    .Add("@user", userId)
                    .Add("@doctypeid", docType);

                unitOfWork.ExecuteNonQueryProcedure("dbo.JournalOperations", parameters);

                return
                    1; //result = Convert.ToInt32(parameters.FirstOrDefault(p => p.ParameterName == "@result")?.Value);
            }
            catch (Exception)
            {
                throw;
            }
        }

        public static object GetRequestInfo(this IUnitOfWork unitOfWork, int type, int docid, int year,
            int pageIndex, int pageSize, int organizationId, int docType, List<SqlParameter> searchParams)
        {
            int skip = pageSize * ((pageIndex == 0 ? 1 : pageIndex) - 1);
            
            var parameters = Extension.Init()
                .Add("@type", type)
                .Add("@docid", docid)
                .Add("@skip", skip)
                .Add("@pageSize", pageSize)
                .Add("@year", year)
                .Add("@organizationId", organizationId)
                .Add("@doctypeid", docType)
                .Add("@totalCount",0,ParameterDirection.InputOutput);
            parameters.AddRange(searchParams);


            var data = unitOfWork.ExecuteProcedure<DocumentModel>("dbo.[JournalInfoOutgoingDocs]", parameters).ToList();
            var totalCount = (int) parameters.First(x => x.ParameterName == "@totalCount").Value;
            
            var viewModel = new
            {
                TotalCount = totalCount,
                Items =  Mapper.Map<List<DocumentModelDto>>(data)
            };
            
            return viewModel;
        }
        
        public static object GetRequestInfoForOtherDocTypes(this IUnitOfWork unitOfWork, int type, int docid, int year,
            int pageIndex, int pageSize, int organizationId, int docType, List<SqlParameter> searchParams)
        {
            var parameters = Extension.Init()
                .Add("@type", type)
                .Add("@docid", docid)
                .Add("@year", year)
                .Add("@organizationId", organizationId)
                .Add("@doctypeid", docType);
            parameters.AddRange(searchParams);


            var data = unitOfWork.ExecuteProcedure<GridModel>("dbo.[JournalInfoForOthers]", parameters).ToList();
            var totalCount = data.Count;
            
            var viewModel = new
            {
                TotalCount = totalCount,
                Items = Mapper.Map<List<GridModelDto>>( data.Skip((pageIndex - 1) * pageSize).Take(pageSize).ToList())
            };
            return viewModel;
        }
        

        public static IEnumerable<BlankTypeModel> GetBlankType(this IUnitOfWork unitOfWork, string prevblank,
            string newblanktype, int newblankno, int key, int docid)
        {
            List<BlankTypeModel> result = new List<BlankTypeModel>();
            var parameters = Extension.Init()
                .Add("@prevblank", prevblank)
                .Add("@newblanktype", newblanktype)
                .Add("@newblankno", newblankno)
                .Add("@key", key)
                .Add("@docid", docid);

            var data = unitOfWork.ExecuteProcedure<BlankTypeModel>("dbo.[JournalBlankNumber]", parameters).ToList();
            result = data.ToList();
            return result;
        }

        public static int EditBlank(this IUnitOfWork unitOfWork, string prevblank, int newblanktype, int newblankno,
            int key, int docid)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@prevblank", prevblank)
                    .Add("@newblanktype", newblanktype)
                    .Add("@newblankno", newblankno)
                    .Add("@key", key)
                    .Add("@docid", docid);

                unitOfWork.ExecuteNonQueryProcedure("[dbo].[JournalBlankNumber]", parameters);

                return 1;
            }
            catch (Exception)
            {
                throw;
            }
        }
    }
}