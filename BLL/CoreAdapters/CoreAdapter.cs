using BLL.BaseAdapter;
using BLL.Common.Enums;
using BLL.Models.Document;
using LogHelpers;
using Repository.Extensions;
using Repository.Infrastructure;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace BLL.CoreAdapters
{
    public class CoreAdapter : AdapterBase
    {
        public CoreAdapter(IUnitOfWork unitOfWork) : base(unitOfWork)
        {
        }

        public List<ChooseModel> GetDocumentActions(int docId, int workPlaceId, int menuTypeId, int executorId = 0)
        {
            var parameters = Extension.Init()
                .Add("@docId", docId)
                .Add("@executorId", executorId)
                .Add("@workPlaceId", workPlaceId)
                .Add("@menuTypeId", menuTypeId);

            return UnitOfWork.ExecuteProcedure<ChooseModel>("[dbo].[GetDocumentActions]", parameters).ToList();
        }


        public void CacheDoc(int docId)
        {
            if (docId < 1)
                return;

            var parameters = Extension.Init()
                .Add("@docId", docId);

            UnitOfWork.ExecuteNonQueryProcedure("[dbo].[CacheDoc]", parameters);
        }


        public T ElectronDocView<T>(int docId, int executorId) where T : BaseElectronDoc
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@docId", docId)
                    .Add("@executorId", executorId);

                var model = UnitOfWork.ExecuteProcedure<T>("[dbo].[GetElectronDocView]", parameters).FirstOrDefault();

                if (model != null)
                {
                    model.ExecutorId = executorId;
                    model.DocId = docId;
                }

                return model;
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public T ElectronDocView<T>(int docId, int workPlace, int menuTypeId, int executorId = 0)
            where T : BaseElectronDoc
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@docId", docId)
                    .Add("@executorId", executorId);

                var model = UnitOfWork.ExecuteProcedure<T>("[dbo].[GetElectronDocView]", parameters).FirstOrDefault();

                if (model != null)
                {
                    model.ExecutorId = executorId;
                    model.DocId = docId;

                    UnitOfWork.ExecuteAllCommandTasks(() =>
                    {
                        model.DocActions = GetDocumentActions(docId, workPlace, menuTypeId, executorId);
                        model.DocFiles = new DocInfoAdapter(UnitOfWork).GetDocFiles(docId);
                    });
                }

                return model;
            }
            catch (Exception ex)
            {
                throw;
            }
        }


        public int ExecuteOperation(ActionType actionId, int docId, int workPlaceId, string description, out int result,
            int executorId = 0)
        {
            Log.AddInfo("PostActionOperation", $"actionId:{actionId},docId:{docId},workPlaceId:{workPlaceId}",
                "BLL.Adapters.DocumentAdapter.PostActionOperation");
            try
            {
                var parameters = Extension.Init()
                    .Add("@actionId", (int) actionId)
                    .Add("@docId", docId)
                    .Add("@workPlaceId", workPlaceId)
                    .Add("@note", description)
                    .Add("@executorId", executorId)
                    .Add("@result", 0, direction: ParameterDirection.InputOutput);
                UnitOfWork.ExecuteNonQueryProcedure("[dbo].spPostActionOperation", parameters);

                return result = Convert.ToInt32(parameters.First(p => p.ParameterName == "@result").Value);
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "BLL.Adapters.DocumentAdapter.PostActionOperation");
                throw;
            }
        }
    }
}