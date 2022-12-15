using System;
using System.Data.Common;
using System.Data.Entity;
using System.Threading.Tasks;

namespace Repository.Infrastructure
{
    public interface IUnitOfWork : IDisposable 
    {
        IRepository<T> GetRepository<T>() where T : class;

        DbContext Context { get; }

        DbConnection Connection { get; }

        int SaveChanges();

        Task<int> SaveChangesAsync();
    }
}