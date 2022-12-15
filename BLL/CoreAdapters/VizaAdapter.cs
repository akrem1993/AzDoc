using BLL.BaseAdapter;
using BLL.Common.Enums;
using BLL.Models.Document;
using LogHelpers;
using Model.DB_Views;
using Model.Models.Viza;
using Repository.Extensions;
using Repository.Infrastructure;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace BLL.Adapters
{
    public class VizaAdapter : AdapterBase
    {
        private bool disposed;

        public VizaAdapter(IUnitOfWork unitOfWork) : base(unitOfWork)
        {
            Log.AddInfo("Init VizaAdapter", $"unitOfWork:{unitOfWork}", "InsDoc.Adapters.VizaAdapter.VizaAdapter");
        }

        public List<VW_DOCS_VIZA> GetVizaByFileInfoId(int? fileInfoId)
        {
            Log.AddInfo("GetVizaByFileInfoId", $"fileInfoId:{fileInfoId}", "InsDoc.Adapters.VizaAdapter.GetVizaByFileInfoId");
            try
            {
                var parameters = Extension.Init()
                    .Add("@fileInfoId", fileInfoId)
                    .Add("@operType", (int)OperType.Select)
                    .Add("@selectType", (int)SelectType.GetVizaByFileInfoId);

                return UnitOfWork.ExecuteProcedure<VW_DOCS_VIZA>("" +
                                                                 "[dbo].[spFileOperations]", parameters).ToList();
            }
            catch (Exception exception)
            {
                Log.AddError(exception.Message, "InsDoc.Adapters.VizaAdapter.GetVizaByFileInfoId");
                throw;
            }
        }

        public int AddNewVizaExecutors(int fileInfoId, int vizaDocId, int orderIndex, int workPlaceId, int vizaWorkPlaceId)
        {
            Log.AddInfo("AddNewVizaExecutors", $"fileInfoId:{fileInfoId},vizaDocId:{vizaDocId},orderIndex:{orderIndex},workPlaceId:{workPlaceId},vizaWorkPlaceId:{vizaWorkPlaceId}",
                                                                                                   "InsDoc.Adapters.VizaAdapter.AddNewVizaExecutors");
            try
            {
                var parameters = Extension.Init()
                    .Add("@fileInfoId", fileInfoId)
                    .Add("@vizaDocId", vizaDocId)
                    .Add("@orderIndex", orderIndex)
                    .Add("@workPlaceId", workPlaceId)
                    .Add("@vizaWorkPlaceId", vizaWorkPlaceId)
                    .Add("@result", -1, ParameterDirection.InputOutput);

                UnitOfWork.ExecuteNonQueryProcedure("" +
                                                     "[dbo].[spAddNewVizaExecutors]", parameters);

                return Convert.ToInt16(parameters.First(x => x.ParameterName == "@result").Value);
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "InsDoc.Adapters.VizaAdapter.AddNewVizaExecutors");
                throw;
            }
        }

        public int VizaDelete(int vizaId)
        {
            Log.AddInfo("VizaDelete", $"vizaId:{vizaId}", "InsDoc.Adapters.VizaAdapter.VizaDelete");
            try
            {
                var parameters = Extension.Init()
                    .Add("@vizaId", vizaId)
                    .Add("@result", 0, ParameterDirection.InputOutput);

                UnitOfWork.ExecuteNonQueryProcedure("" +
                                                     "[dbo].[spVizaDelete]", parameters);

                return Convert.ToInt16(parameters.First(x => x.ParameterName == "@result").Value);
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "InsDoc.Adapters.VizaAdapter.VizaDelete");
                throw;
            }
        }

        public List<ChooseModel> GetResPersonByOrgId(int? workPlaceId)
        {
            var parameters = Extension.Init()
                    .Add("@workPlaceId", workPlaceId)
                    .Add("@operType", (int)OperType.Select)
                    .Add("@selectType", (int)SelectType.GetResPersonByOrgId);

            return UnitOfWork.ExecuteProcedure<ChooseModel>("" +
                                                             "[dbo].[spFileOperations]", parameters).ToList();
        }

        public List<VizaModel> GetJointExecutors(int? workPlaceId, int? CurrentDocId, string answerDocs)
        {
            var parameters = Extension.Init()
                .Add("@workPlaceId", workPlaceId)
                .Add("@CurrentDocId", CurrentDocId)
                .Add("@answerDocs", answerDocs);

            var result = UnitOfWork.ExecuteProcedure<VizaModel>("[dbo].[GetJointExecutors] ", parameters).ToList();
            return result;
        }
         public bool IsSameDepartment(int? vizaWorkplaceId, int? workPlaceId)
        {
            var parameters = Extension.Init()
                .Add("@vizaWorkplaceId", @vizaWorkplaceId)
                .Add("@workPlaceId", @workPlaceId);
            var result = UnitOfWork.ExecuteScalar<bool>("select [dbo].[IsSameDepartment](@vizaWorkplaceId,@workPlaceId)", parameters);
            return result;
        }
        public List<DocCreatorModel> GetDocumentCreator(int? currentdocid)

        {
            var parameters = Extension.Init()
               .Add("@CurrentDocId", currentdocid);
            var result = UnitOfWork.ExecuteProcedure<DocCreatorModel>("[dbo].[GetDocumentCreator]", parameters).ToList();
            return result;
        }
        public override void Dispose()
        {
            Dispose(true);
            base.Dispose();
        }

        protected virtual void Dispose(bool disposing)
        {
            if (!disposed)
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