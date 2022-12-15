using Repository.Infrastructure;
using Repository.Repository;
using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Data.Entity;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace Repository.UnitOfWork
{
    public class EFUnitOfWork<D> : IUnitOfWork where D : DbContext, new()
    {
        private string _guid;
        public string Key => _guid;

        private readonly DbContext _dbContext;
        public DbContext Context => _dbContext;

        public DbConnection Connection => Context.Database.Connection;

        public EFUnitOfWork()
        {
            //_guid = Guid.NewGuid().ToString();
            //Database.SetInitializer(new CreateDatabaseIfNotExists<D>());
            //Database.SetInitializer(new DropCreateDatabaseAlways<T>());

            //if (dbContext == null)
            //    throw new ArgumentNullException("dbContext can not be null.");

            _dbContext = new D();

            //_dbContext = dbContext;

            // istədiyimiz kimi burda Entity Frameworku configurasiya edə bilərik
            //_dbContext.Configuration.LazyLoadingEnabled = false;
            //_dbContext.Configuration.ValidateOnSaveEnabled = false;
            //_dbContext.Configuration.ProxyCreationEnabled = false;
        }

        #region IUnitOfWork Members

        public IRepository<T> GetRepository<T>() where T : class
        {
            return new EFRepository<T>(_dbContext);
        }

        public int SaveChanges()
        {
            try
            {
                // Transaction əməliyyatlarını burda yerinə yetirəbilərik
                // yalnızdəyisən hissləri update etmesini təmin edə bilərik.
                return _dbContext.SaveChanges();
            }
            catch
            {
                // Bu hissədə DbEntityValidationException xətalarını handle edə bilərik.
                throw;
            }
        }

        public Task<int> SaveChangesAsync()
        {
            try
            {
                // Transaction əməliyyatlarını burda yerinə yetirəbilərik
                // yalnızdəyisən hissləri update etmesini təmin edə bilərik.
                return _dbContext.SaveChangesAsync();
            }
            catch
            {
                // Bu hissədə DbEntityValidationException xətalarını handle edə bilərik.
                throw;
            }
        }

        public void ExecuteNonQueryProcedure<T>(string v, List<SqlParameter> parameters)
        {
            throw new NotImplementedException();
        }

        #endregion IUnitOfWork Members

        #region IDisposable Members

        // Bu hissədə IUnitOfWork interfeysini implement ettiyimiz IDisposable interfeysinin Dispose Patternini implement edirik.
        private bool disposed = false;

        protected virtual void Dispose(bool disposing)
        {
            if (!this.disposed)
            {
                if (disposing)
                {
                    _dbContext.Dispose();
                }
            }

            this.disposed = true;
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        #endregion IDisposable Members
    }
}