using Repository.Attributes;
using Repository.Infrastructure;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Data.SqlClient;
using System.Linq;
using System.Linq.Expressions;
using System.Threading.Tasks;

namespace Repository.Repository
{
    /// <summary>
    /// EntityFramework için hazırlıyor olduğumuz bu repositoriyi daha önceden tasarladığımız generic repositorimiz olan IRepository arayüzünü implemente ederek tasarladık.
    /// Bu şekilde tasarlamamızın ana sebebi ise veritabanına independent(bağımsız) bir durumda kalabilmek. Örneğin MongoDB için ise ilgili provider'ı aracılığı ile MongoDBRepository tasarlayabiliriz.
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public class EFRepository<T> : IRepository<T> where T : class
    {
        private readonly DbContext _dbContext;
        private readonly DbSet<T> _dbSet;

        public EFRepository(DbContext dbContext)
        {
            if (dbContext == null)
                throw new ArgumentNullException("dbContext can not be null.");

            _dbContext = dbContext;
            _dbSet = _dbContext.Set<T>();
        }

        #region IRepository Members

        public IQueryable<T> GetAll()
        {
            return _dbSet.AsNoTracking<T>();
        }

        public IQueryable<T> GetAll(Expression<Func<T, bool>> predicate)
        {
            if (predicate == null)
                return GetAll();

            return _dbSet.Where(predicate).AsNoTracking<T>();
        }

        public Task<IQueryable<T>> GetAllAsync()
        {
            return Task.FromResult(GetAll());
        }

        public Task<IQueryable<T>> GetAllAsync(Expression<Func<T, bool>> predicate)
        {
            return Task.FromResult(GetAll(predicate));
        }

        public T GetById(int id)
        {
            return _dbSet.Find(id);
        }

        public T Get(Expression<Func<T, bool>> predicate)
        {
            if (predicate == null)
                return _dbSet.AsNoTracking().SingleOrDefault();

            return _dbSet.Where(predicate).AsNoTracking().FirstOrDefault();
        }


        public T GetForAdmin(Expression<Func<T, bool>> predicate)
        {
            if (predicate == null)
                return _dbSet.AsNoTracking().SingleOrDefault();

            return _dbSet.Where(predicate).AsNoTracking().FirstOrDefault();
        }

        public Task<T> GetByIdAsync(int id)
        {
            return _dbSet.FindAsync(id);
        }

        public Task<T> GetAsync(Expression<Func<T, bool>> predicate)
        {
            return Task.FromResult(Get(predicate));
        }

        public void Add(T entity)
        {
            _dbSet.Add(entity);
        }

        public void Update(T entity)
        {
            _dbSet.Attach(entity);
            _dbContext.Entry(entity).State = EntityState.Modified;
        }

        public void Delete(T entity)
        {
            // Eğer sizlerde genelde bir kayıtı silmek yerine IsDelete şeklinde bool bir flag alanı tutuyorsanız,
            // Küçük bir refleciton kodu yardımı ile bunuda otomatikleştirebiliriz.
            if (entity.GetType().GetProperty("IsDelete") != null)
            {
                T _entity = entity;

                _entity.GetType().GetProperty("IsDelete").SetValue(_entity, true);

                this.Update(_entity);
            }
            else
            {
                // Önce entity'nin state'ini kontrol etmeliyiz.
                DbEntityEntry dbEntityEntry = _dbContext.Entry(entity);

                if (dbEntityEntry.State != EntityState.Deleted)
                {
                    dbEntityEntry.State = EntityState.Deleted;
                }
                else
                {
                    _dbSet.Attach(entity);
                    _dbSet.Remove(entity);
                }
            }
        }

        public void Delete(int id)
        {
            var entity = GetById(id);
            if (entity == null) return;
            else
            {
                if (entity.GetType().GetProperty("IsDelete") != null)
                {
                    T _entity = entity;
                    _entity.GetType().GetProperty("IsDelete").SetValue(_entity, true);

                    this.Update(_entity);
                }
                else
                {
                    Delete(entity);
                }
            }
        }

        public Task<int> CountAsync(Expression<Func<T, bool>> predicate)
        {
            return Task.FromResult(_dbSet.Count(predicate));
        }

        public IEnumerable<T> ExecuteProcedure<D>(string procedure, D searchTmp) where D : class
        {
            var pmt = new List<SqlParameter>();
            try
            {
                if (searchTmp == null)
                    return _dbContext.Database.SqlQuery<T>(procedure).ToList();

                var props = searchTmp.GetType().GetProperties()
                    .Where(prop => prop.GetValue(searchTmp, null) != null && prop.GetCustomAttributes(typeof(ParamAttribute), false).Any());

                props.Select(prop => new { Value = prop.GetValue(searchTmp), Attribute = prop.GetCustomAttributes(typeof(ParamAttribute), false).First() as ParamAttribute })
                .ToList()
                .ForEach(prop =>
                {
                    pmt.Add(prop.Attribute.Size.HasValue ?
                        new SqlParameter(prop.Attribute.Name, prop.Attribute.Type, prop.Attribute.Size.Value) { Value = prop.Value, Direction = prop.Attribute.Direction }
                      : new SqlParameter(prop.Attribute.Name, prop.Attribute.Type) { Value = prop.Value, Direction = prop.Attribute.Direction });
                });

                var result = _dbContext.Database.SqlQuery<T>(string.Concat(procedure
                    , " "
                    , string.Join(",", pmt.Where(p => p.Direction != ParameterDirection.ReturnValue)
                    .Select(p => string.Format("{0}={0}{1}", p.ParameterName, (p.Direction == ParameterDirection.InputOutput || p.Direction == ParameterDirection.Output) ? " out" : ""))))
                    , pmt.ToArray()).ToList();

                foreach (var prop in props
                    .Select(v => new { Property = v, Attribute = v.GetCustomAttributes(typeof(ParamAttribute), false).First() as ParamAttribute })
                    .Where(p => p.Attribute.Direction != ParameterDirection.Input && p.Property.GetValue(searchTmp, null) != null))
                {
                    prop.Property.SetValue(searchTmp, pmt.Find(p => p.ParameterName == prop.Attribute.Name).Value);
                }

                return result;
            }
            catch
            {
                throw;
            }
            finally
            {
                pmt.Clear();
                pmt = null;
            }
        }

        public IEnumerable<T> ExecuteFunction<D>(string procedure, D searchTmp) where D : class
        {
            var pmt = new List<SqlParameter>();
            try
            {
                var props = searchTmp.GetType().GetProperties()
                    .Where(prop => prop.GetValue(searchTmp, null) != null && prop.GetCustomAttributes(typeof(ParamAttribute), false).Any());

                props.Select(prop => new { Value = prop.GetValue(searchTmp), Attribute = prop.GetCustomAttributes(typeof(ParamAttribute), false).First() as ParamAttribute })
                .ToList()
                .ForEach(prop =>
                {
                    pmt.Add(prop.Attribute.Size.HasValue ?
                        new SqlParameter(prop.Attribute.Name, prop.Attribute.Type, prop.Attribute.Size.Value) { Value = prop.Value, Direction = prop.Attribute.Direction }
                      : new SqlParameter(prop.Attribute.Name, prop.Attribute.Type) { Value = prop.Value, Direction = prop.Attribute.Direction });
                });

                var result = _dbContext.Database.SqlQuery<T>(procedure, pmt.ToArray()).ToList();

                return result;
            }
            catch
            {
                throw;
            }
            finally
            {
                pmt.Clear();
                pmt = null;
            }
        }

        public void ExecuteNonQueryProcedure<D>(string procedure, D searchTmp) where D : class
        {
            var pmt = new List<SqlParameter>();
            try
            {
                var props = searchTmp.GetType().GetProperties()
                    .Where(prop => prop.GetValue(searchTmp, null) != null && prop.GetCustomAttributes(typeof(ParamAttribute), false).Any());

                props.Select(prop => new { Value = prop.GetValue(searchTmp), Attribute = prop.GetCustomAttributes(typeof(ParamAttribute), false).First() as ParamAttribute })
                .ToList()
                .ForEach(prop =>
                {
                    pmt.Add(prop.Attribute.Size.HasValue ?
                        new SqlParameter(prop.Attribute.Name, prop.Attribute.Type, prop.Attribute.Size.Value) { Value = prop.Value, Direction = prop.Attribute.Direction }
                      : new SqlParameter(prop.Attribute.Name, prop.Attribute.Type) { Value = prop.Value, Direction = prop.Attribute.Direction });
                });

                using (var cmd = new SqlCommand(procedure, new SqlConnection(this._dbContext.Database.Connection.ConnectionString)) { CommandType = CommandType.StoredProcedure })
                {
                    cmd.Parameters.AddRange(pmt.ToArray());
                    cmd.Connection.Open();
                    cmd.ExecuteNonQuery();
                    cmd.Connection.Close();
                }

                foreach (var prop in props
                    .Select(v => new { Property = v, Attribute = v.GetCustomAttributes(typeof(ParamAttribute), false).First() as ParamAttribute })
                    .Where(p => p.Attribute.Direction != ParameterDirection.Input))
                {
                    prop.Property.SetValue(searchTmp, pmt.Find(p => p.ParameterName == prop.Attribute.Name).Value);
                }
            }
            catch
            {
                throw;
            }
            finally
            {
                pmt.Clear();
                pmt = null;
            }
        }

        #endregion IRepository Members
    }
}