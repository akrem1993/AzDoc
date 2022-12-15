using DMSModel;
using Repository.Infrastructure;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using LogHelpers;

namespace InsDoc.Adapters
{
    public class DocumentRelatedAdapter : IDisposable
    {
        private bool disposed;
        private IUnitOfWork _unitOfWork;
        private IRepository<DOCS_RELATED> _DCUDocRelatedRepository;

        public DocumentRelatedAdapter(IUnitOfWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
            _DCUDocRelatedRepository = _unitOfWork.GetRepository<DOCS_RELATED>();
            Log.AddInfo("Init DocumentRelatedAdapter", $"unitOfWork:{unitOfWork}", "InsDoc.Adapters.DocumentRelatedAdapter.DocumentRelatedAdapter");
        }

        public DOCS_RELATED GetById(int RelatedId)
        {
            Log.AddInfo("GetById", $"RelatedId:{RelatedId}", "InsDoc.Adapters.DocumentRelatedAdapter.GetById");
            try
            {
                return _DCUDocRelatedRepository.Get(x => x.RelatedId == RelatedId);
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "InsDoc.Adapters.DocumentRelatedAdapter.GetById");
                throw ex;
            }
        }
        public List<DOCS_RELATED> GetDocId(int RelatedDocId)
        {
            Log.AddInfo("GetDocId", $"RelatedDocId:{RelatedDocId}", "InsDoc.Adapters.DocumentRelatedAdapter.GetDocId");
            try
            {
                return _DCUDocRelatedRepository.GetAll(x => x.RelatedDocId == RelatedDocId).ToList();
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "InsDoc.Adapters.DocumentRelatedAdapter.GetDocId");
                throw ex;
            }
        }

        public List<DOCS_RELATED> GetByRelatedDocId(int RelatedDocId)
        {
            Log.AddError("GetByRelatedDocId", $"RelatedDocId:{RelatedDocId}", "InsDoc.Adapters.DocumentRelatedAdapter.GetByRelatedDocId");
            try
            {
                return _DCUDocRelatedRepository.GetAll(x => x.RelatedDocId == RelatedDocId).ToList();
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "InsDoc.Adapters.DocumentRelatedAdapter.GetByRelatedDocId");
                throw ex;
            }
        }

        public int Add(DOCS_RELATED item)
        {
            Log.AddInfo("Add", $"item:{item}", "InsDoc.Adapters.DocumentRelatedAdapter.Add");
            try
            {
                _DCUDocRelatedRepository.Add(item);
                return _unitOfWork.SaveChanges();
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "InsDoc.Adapters.DocumentRelatedAdapter.Add");
                throw ex;
            }
        }

        public int AddRange(List<DOCS_RELATED> items)
        {
            Log.AddInfo("AddRange", $"items", "InsDoc.Adapters.DocumentRelatedAdapter.AddRange");
            try
            {
                items.ForEach(item => _DCUDocRelatedRepository.Add(item));
                return _unitOfWork.SaveChanges();
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "InsDoc.Adapters.DocumentRelatedAdapter.AddRange");
                throw ex;
            }
        }

        public int Update(DOCS_RELATED item)
        {
            Log.AddInfo("Update", $"item:{item}", "InsDoc.Adapters.DocumentRelatedAdapter.Update");
            try
            {
                _DCUDocRelatedRepository.Update(item);
                return _unitOfWork.SaveChanges();
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "InsDoc.Adapters.DocumentRelatedAdapter.Update");
                throw ex;
            }
        }

        public int Delete(DOCS_RELATED item)
        {
            Log.AddInfo("Delete", $"item:{item}", "InsDoc.Adapters.DocumentRelatedAdapter.Delete");
            try
            {
                _DCUDocRelatedRepository.Delete(item);
                return _unitOfWork.SaveChanges();
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "InsDoc.Adapters.DocumentRelatedAdapter.Delete");
                throw ex;
            }
        }

        public int Delete(int RelatedDocId, int RelatedDocumentId)
        {
            Log.AddInfo("Delete", $"RelatedDocId:{RelatedDocId},RelatedDocumentId:{RelatedDocumentId}", 
                                                         "InsDoc.Adapters.DocumentRelatedAdapter.Delete");
            try
            {
                _DCUDocRelatedRepository.GetAll(x => ((x.RelatedDocId == RelatedDocId) && (x.RelatedDocumentId == RelatedDocumentId))).ToList()
                           .ForEach(y => _DCUDocRelatedRepository.Delete(y));
                return _unitOfWork.SaveChanges();
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "InsDoc.Adapters.DocumentRelatedAdapter.Delete");
                throw ex;
            }
        }

        public List<DOCS_RELATED> GetAll(Expression<Func<DOCS_RELATED, bool>> predicate)
        {
            Log.AddInfo("GetAll", $"predicate:{predicate}", "InsDoc.Adapters.DocumentRelatedAdapter.GetAll");
            try
            {
                return _DCUDocRelatedRepository.GetAll(predicate).ToList();
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "InsDoc.Adapters.DocumentRelatedAdapter.GetAll");
                throw ex;
            }
        }

        public IQueryable<DOCS_RELATED> GetAll()
        {
            Log.AddInfo("GetAll","InsDoc.Adapters.DocumentRelatedAdapter.GetAll");
            try
            {
                return _DCUDocRelatedRepository.GetAll();
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "InsDoc.Adapters.DocumentRelatedAdapter.GetAll");
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
                if (!disposed)
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