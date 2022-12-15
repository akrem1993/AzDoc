using DMSModel;
using InsDoc.Model.EntityModel;
using Repository.Extensions;
using Repository.Infrastructure;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Linq.Expressions;
using Custom = CustomHelpers;
using LogHelpers;

namespace InsDoc.Adapters
{
    public class DirectionAdapter : IDisposable
    {
        private IUnitOfWork _unitOfWork;
        private bool disposed;

        public DirectionAdapter(IUnitOfWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
            Log.AddInfo("Init DirectionAdapter", " ", "InsDoc.Adapters.DirectionAdapter");
        }

        public List<DOCS_DIRECTIONS> GetDirection(int docId, int directionType)
        {
            Log.AddInfo("GetDirection", $"docId:{docId},directionType:{directionType}", "InsDoc.Adapters.DirectionAdapter.GetDirection");
            try
            {
                return _unitOfWork.GetRepository<DOCS_DIRECTIONS>()
                               .GetAll(x =>
                                   x.DirectionDocId == docId &&
                                   x.DirectionTypeId == directionType).ToList();
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "InsDoc.Adapters.DirectionAdapter.GetDirection");
                throw ex;
            }
        }

        public DOCS_DIRECTIONS GetById(int directionId)
        {
            Log.AddInfo("GetById", $"directionId:{directionId}", "InsDoc.Adapters.DirectionAdapter.GetById");
            try
            {
                DOCS_DIRECTIONS retVal = null;
                retVal = _unitOfWork.GetRepository<DOCS_DIRECTIONS>()
                    .Get(x => x.DirectionId == directionId);

                return retVal;
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "InsDoc.Adapters.DirectionAdapter.GetById");
                throw ex;
            }
        }

        public int Delete(DOCS_DIRECTIONS direc, List<DOCS_EXECUTOR> executors)
        {
            Log.AddInfo("Delete", $"direc:{direc},executors:{executors}", "InsDoc.Adapters.DirectionAdapter.Delete");
            try
            {
                if (direc.DOCS_DIRECTIONCHANGE.Count > 0)
                {
                    var directionChange = direc.DOCS_DIRECTIONCHANGE.ToList();
                    directionChange.ForEach(t => _unitOfWork.GetRepository<DOCS_DIRECTIONCHANGE>().Delete(t));
                }
                if (executors != null && executors.Count > 0)
                {
                    executors.ForEach(executor => _unitOfWork.GetRepository<DOCS_EXECUTOR>().Delete(executor));
                }

                _unitOfWork.GetRepository<DOCS_DIRECTIONS>().Delete(direc);
                return _unitOfWork.SaveChanges();
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "InsDoc.Adapters.DirectionAdapter.Delete");
                throw ex;
            }
        }

        public List<DOCS_DIRECTIONS> GetDocId(int docId)
        {
            Log.AddInfo("GetDocId", $"docId:{docId}", "InsDoc.Adapters.DirectionAdapter.GetDocId");
            try
            {
                var retVal = _unitOfWork.GetRepository<DOCS_DIRECTIONS>()
                    .GetAll(x => x.DirectionDocId == docId).ToList();

                return retVal;
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "InsDoc.Adapters.DirectionAdapter.GetDocId");
                throw ex;
            }
        }

        public int Add(DOCS_DIRECTIONS direction)
        {
            Log.AddInfo("Add", $"direction:{direction}", "InsDoc.Adapters.DirectionAdapter.Add");
            try
            {
                direction.DirectionUnixTime = Custom.CustomHelper.GetUnixTimeSeconds(DateTime.Now);
                _unitOfWork.GetRepository<DOCS_DIRECTIONS>().Add(direction);

                return _unitOfWork.SaveChanges();
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "InsDoc.Adapters.DirectionAdapter.Add");
                throw ex;
            }
        }

        public int AddDirection(DirectionModel model)
        {
            Log.AddInfo("AddDirection", $"model:{model}", "InsDoc.Adapters.DirectionAdapter.AddDirection");
            try
            {
                var parameters = Extension.Init()
                        .Add("@directionDate", model.DirectionDate)
                        .Add("@directionDocId", model.DirectionDocId)
                        .Add("@directionTypeId", model.DirectionTypeId)
                        .Add("@directionUnixTime", model.DirectionUnixTime)
                        .Add("@directionWorkplaceId", model.DirectionWorkplaceId)
                        .Add("@directionInsertedDate", model.DirectionInsertedDate)
                        .Add("@directionPersonFullName", model.DirectionPersonFullName)
                        .Add("@directionCreatorWorkplaceId", model.DirectionCreatorWorkplaceId)
                        .Add("@directionId", 0, ParameterDirection.InputOutput)
                        .Add("@result", 0, ParameterDirection.InputOutput);

                _unitOfWork.ExecuteNonQueryProcedure("" +
                                                     "[dbo].[spAddDirection]", parameters);

                model.DirectionId = Convert.ToInt32(parameters.FirstOrDefault(x => x.ParameterName == "@directionId")?.Value);
                return Convert.ToInt32(parameters.FirstOrDefault(x => x.ParameterName == "@result")?.Value);
            }
            catch (Exception exception)
            {
                Log.AddError(exception.Message, "InsDoc.Adapters.DirectionAdapter.AddDirection");
                throw new Exception(exception.InnerException?.ToString());
            }
        }

        public int UpdateDirection(DirectionModel model)
        {
            Log.AddInfo("UpdateDirection", $"model:{model}", "InsDoc.Adapters.DirectionAdapter.UpdateDirection");
            try
            {
                var parameters = Extension.Init()
                        .Add("@directionId", model.DirectionId)
                        .Add("@directionDate", model.DirectionDate)
                        .Add("@directionDocId", model.DirectionDocId)
                        .Add("@directionTypeId", model.DirectionTypeId)
                        .Add("@directionUnixTime", model.DirectionUnixTime)
                        .Add("@directionWorkplaceId", model.DirectionWorkplaceId)
                        .Add("@directionInsertedDate", model.DirectionInsertedDate)
                        .Add("@directionPersonFullName", model.DirectionPersonFullName)
                        .Add("@directionCreatorWorkplaceId", model.DirectionCreatorWorkplaceId)
                        .Add("@result", 0, ParameterDirection.InputOutput);

                _unitOfWork.ExecuteNonQueryProcedure("" +
                                                     "[dbo].[spUpdateDirection]", parameters);

                return Convert.ToInt32(parameters.FirstOrDefault(x => x.ParameterName == "@result")?.Value);
            }
            catch (Exception exception)
            {
                Log.AddError(exception.Message, "InsDoc.Adapters.DirectionAdapter.UpdateDirection");
                throw new Exception(exception.InnerException?.ToString());
            }
        }

        public int AddExecutor(ExecutorModel model)
        {
            Log.AddInfo("AddExecutor", $"model:{model}", "InsDoc.Adapters.DirectionAdapter.AddExecutor");
            try
            {
                var parameters = Extension.Init()
                        .Add("@executorReadStatus", false)
                        .Add("@executorMain", model.ExecutorMain)
                        .Add("@executorDocId", model.ExecutorDocId)
                        .Add("@directionTypeId", model.DirectionTypeId)
                        .Add("@executorSection", model.ExecutorSection)
                        .Add("@executorSubsection", model.ExecutorSubsection)
                        .Add("@executorDepartment", model.ExecutorDepartment)
                        .Add("@executorFullName", model.ExecutorFullName)
                        .Add("@executorWorkplaceId", model.ExecutorWorkplaceId)
                        .Add("@executorDirectionId", model.ExecutorDirectionId)
                        .Add("@executorTopDepartment", model.ExecutorTopDepartment)
                        .Add("@executorOrganizationId", model.ExecutorOrganizationId)
                        .Add("@result", 0, ParameterDirection.InputOutput);

                _unitOfWork.ExecuteNonQueryProcedure("" +
                                                     "[dbo].[spAddExecutor]", parameters);

                return Convert.ToInt32(parameters.FirstOrDefault(x => x.ParameterName == "@result")?.Value);
            }
            catch (Exception exception)
            {
                Log.AddError(exception.Message, "InsDoc.Adapters.DirectionAdapter.AddExecutor");
                throw new Exception(exception.InnerException?.ToString());
            }
        }

        public int AddRange(DirectionModel direction, List<ExecutorModel> executors)
        {
            Log.AddInfo("AddRange", $"direction:{direction},executors:{executors}", "InsDoc.Adapters.DirectionAdapter.AddRange");
            try
            {
                int result = 0;
                if (direction.DirectionDate == DateTime.MinValue)
                    direction.DirectionDate = DateTime.Now;

                direction.DirectionInsertedDate = DateTime.Now;
                direction.DirectionUnixTime = Custom.CustomHelper.GetUnixTimeSeconds(DateTime.Now);

                if (direction.DirectionDate.Date == DateTime.MinValue)
                {
                    direction.DirectionDate = DateTime.Now;
                }

                if (direction.DirectionDate.Hour == 0)
                {
                    direction.DirectionDate = direction.DirectionDate
                        .AddHours(DateTime.Now.Hour)
                        .AddMinutes(DateTime.Now.Minute)
                        .AddSeconds(DateTime.Now.Second);
                }

                result = direction.DirectionId == 0 ? AddDirection(direction) : UpdateDirection(direction);

                if (result != 0)
                {
                    foreach (var executor in executors)
                    {
                        executor.ExecutorDirectionId = direction.DirectionId;
                        result = AddExecutor(executor);
                    }
                }
                return result;
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "InsDoc.Adapters.DirectionAdapter.AddRange");
                throw ex;
            }
        }

        public int RemoveRange(List<DOCS_DIRECTIONS> directions)
        {
            Log.AddInfo("RemoveRange", $"directions:{directions}", "InsDoc.Adapters.DirectionAdapter.RemoveRange");
            try
            {
                directions.ForEach(dir => _unitOfWork.GetRepository<DOCS_DIRECTIONS>().Delete(dir));
                return _unitOfWork.SaveChanges();
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "InsDoc.Adapters.DirectionAdapter.RemoveRange");
                throw ex;
            }
        }

        public int RemoveExecutorsRange(List<DOCS_EXECUTOR> executors, bool deleteDirection)
        {
            Log.AddInfo("RemoveExecutorsRange", $"executors:{executors},deleteDirection:{deleteDirection}",
                                                                      "InsDoc.Adapters.DirectionAdapter.RemoveExecutorsRange");
            try
            {
                executors.ForEach(exec => _unitOfWork.GetRepository<DOCS_EXECUTOR>().Delete(exec));

                if (deleteDirection)
                {
                    DOCS_DIRECTIONS direction = _unitOfWork.GetRepository<DOCS_DIRECTIONS>().GetById(executors.FirstOrDefault().ExecutorDirectionId);
                    _unitOfWork.GetRepository<DOCS_DIRECTIONS>().Delete(direction);
                }

                return _unitOfWork.SaveChanges();
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "InsDoc.Adapters.DirectionAdapter.RemoveExecutorsRange");
                throw ex;
            }
        }

        public int UpdateExecutor(DOCS_EXECUTOR executor)
        {
            Log.AddInfo("UpdateExecutor", $"executor:{executor}", "InsDoc.Adapters.DirectionAdapter.UpdateExecutor");
            try
            {
                _unitOfWork.GetRepository<DOCS_EXECUTOR>().Update(executor);
                return _unitOfWork.SaveChanges();
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "InsDoc.Adapters.DirectionAdapter.UpdateExecutor");
                throw ex;
            }
        }

        public int UpdateRangeExecutor(List<DOCS_EXECUTOR> executors)
        {
            Log.AddInfo("UpdateRangeExecutor", $"executors:{executors}", "InsDoc.Adapters.DirectionAdapter.UpdateRangeExecutor");
            try
            {
                executors.ForEach(x => _unitOfWork.GetRepository<DOCS_EXECUTOR>().Update(x));
                return _unitOfWork.SaveChanges();
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "InsDoc.Adapters.DirectionAdapter.UpdateRangeExecutor");
                throw ex;
            }
        }

        public int Update(DOCS_DIRECTIONS direction)
        {
            Log.AddInfo("Update", $"direction:{direction}", "InsDoc.Adapters.DirectionAdapter.Update");
            try
            {
                direction.DirectionUnixTime = Custom.CustomHelper.GetUnixTimeSeconds(DateTime.Now);
                _unitOfWork.GetRepository<DOCS_DIRECTIONS>().Update(direction);
                return _unitOfWork.SaveChanges();
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "InsDoc.Adapters.DirectionAdapter.Update");
                throw ex;
            }
        }

        public IQueryable<DOCS_DIRECTIONS> GetAll()
        {
            Log.AddInfo("GetAll", "InsDoc.Adapters.DirectionAdapter.GetAll");
            try
            {
                IQueryable<DOCS_DIRECTIONS> retVal = null;
                retVal = _unitOfWork.GetRepository<DOCS_DIRECTIONS>().GetAll();
                return retVal;
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "InsDoc.Adapters.DirectionAdapter.GetAll");
                throw ex;
            }
        }

        public List<DOCS_DIRECTIONS> GetAll(Expression<Func<DOCS_DIRECTIONS, bool>> predicate)
        {
            Log.AddInfo("GetAll", $"predicate:{predicate}", "InsDoc.Adapters.DirectionAdapter.GetAll");
            try
            {
                return _unitOfWork.GetRepository<DOCS_DIRECTIONS>().GetAll(predicate).ToList();
            }
            catch (Exception ex) 
            {
                Log.AddError(ex.Message, "InsDoc.Adapters.DirectionAdapter.GetAll");
                throw ex;
            }
        }

        public bool ResolutionExecutorMainExists(int workplaceId, int docId)
        {
            Log.AddInfo("ResolutionExecutorMainExists", $"workplaceId:{workplaceId},docId:{docId}",
                                                   "InsDoc.Adapters.DirectionAdapter.ResolutionExecutorMainExists");
            try
            {
                return _unitOfWork.GetRepository<DOCS_EXECUTOR>().GetAll().Any(x => x.ExecutorDocId == docId && (x.DirectionTypeId == (int)Custom.DirectionType.Resolution || x.DirectionTypeId == (int)Custom.DirectionType.ExecuteServiceLetter)
                                            && x.ExecutorWorkplaceId == workplaceId && x.ExecutorMain == 1);
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "InsDoc.Adapters.DirectionAdapter.ResolutionExecutorMainExists");
                throw ex;
            }
        }

        public bool ResolutionExecutorExists(int workplaceId, int docId)
        {
            Log.AddInfo("ResolutionExecutorExists", $"workplaceId:{workplaceId},docId:{docId}",
                                                      "InsDoc.Adapters.DirectionAdapter.ResolutionExecutorExists");
            try
            {
                return _unitOfWork.GetRepository<DOCS_EXECUTOR>().GetAll().Any(x => x.ExecutorDocId == docId && (x.DirectionTypeId == (int)Custom.DirectionType.Resolution || x.DirectionTypeId == (int)Custom.DirectionType.ExecuteServiceLetter)
                                           && x.ExecutorWorkplaceId == workplaceId);
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "InsDoc.Adapters.DirectionAdapter.ResolutionExecutorExists");
                throw ex;
            }
        }

        public IQueryable<DOCS_EXECUTOR> GetExecutor(Expression<Func<DOCS_EXECUTOR, bool>> predicate)
        {
            Log.AddInfo("GetExecutor", $"predicate:{predicate}", "InsDoc.Adapters.DirectionAdapter.GetExecutor");
            try
            {
                return _unitOfWork.GetRepository<DOCS_EXECUTOR>().GetAll(predicate);
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "InsDoc.Adapters.DirectionAdapter.GetExecutor");
                throw ex;
            }
        }

        public void Dispose()
        {
                Dispose(true);
                GC.SuppressFinalize(this);
        }

        protected virtual void Dispose(bool disposing)
        {
                if (!this.disposed)
                {
                    if (disposing)
                    {
                        _unitOfWork.Dispose();
                    }

                    disposed = true;
                }
        }
    }
}