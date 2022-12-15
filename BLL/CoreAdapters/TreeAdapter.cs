using DataCache.Core;
using DMSModel;
using Repository.Infrastructure;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using LogHelpers;

namespace BLL.Adapters
{
    public class TreeAdapter : IDisposable
    {
        private bool disposed;

        private readonly IUnitOfWork _unitOfWork;

        public TreeAdapter(IUnitOfWork unitOfWork)
        {
            Log.AddInfo("TreeAdapter", $"unitOfWork:{unitOfWork}", "BLL.TreeAdapter.TreeAdapter");
            try
            {
                _unitOfWork = unitOfWork;
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "BLL.TreeAdapter.TreeAdapter");
                throw ;
            }
        }

        public List<DC_TREE> GetAll()
        {
            Log.AddInfo("GetAll", "BLL.TreeAdapter.GetAll");
            CacheKey key = CacheKey.New(CacheTable.DC_TREE, "-1");

            try
            {
                List<DC_TREE> retVal;
                if (CacheProvider.Instance.IsExist(key))
                {
                    retVal = CacheProvider.Instance.Get(key) as List<DC_TREE>;
                }
                else
                {
                    retVal = _unitOfWork.GetRepository<DC_TREE>().GetAll().Include(t => t.DOC_TYPE_GROUP).ToList();
                    CacheProvider.Instance.Set(key, retVal);
                }

                return retVal;
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "", "BLL.TreeAdapter.GetAll");
                throw ;
            }
        }
        public IQueryable<DC_TREE> IGetAll()
        {
            Log.AddInfo("IGetAll", "BLL.TreeAdapter.IGetAll");
            try
            {
                return _unitOfWork.GetRepository<DC_TREE>().GetAll().Include(t => t.DOC_TYPE_GROUP);
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "", "BLL.TreeAdapter.IGetAll");
                throw ;
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
                        _unitOfWork?.Dispose();
                    }
                    disposed = true;
                }
        }
    }
}