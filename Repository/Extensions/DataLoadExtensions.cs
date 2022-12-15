using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;
using Dapper;
using Repository.Infrastructure;

namespace Repository.Extensions
{
    public static class DataLoadExtensions
    {
        public static async Task<IEnumerable<T>> GetDataFromSpAsync<T>(this IUnitOfWork unitOfWork, string query, object sqlParameters)
        {
            return await unitOfWork.ExecuteAsync<T>(query, sqlParameters, CommandType.StoredProcedure);
        }

        public static IEnumerable<T> GetDataFromSP<T>(this IUnitOfWork unitOfWork, string query, object sqlParameters)
        {
            return unitOfWork.Execute<T>(query, sqlParameters, CommandType.StoredProcedure);
        }

        public static async Task<IEnumerable<T>> GetDataFromSpAsync<T>(this IUnitOfWork unitOfWork, string query, List<SqlParameter> sqlParameters = null)
        {
            var args = sqlParameters.GetDynamicParameters();

            var data = await unitOfWork.GetDataFromSpAsync<T>(query, args);

            sqlParameters.SetOutputParameters(args);

            return data;
        }

        public static IEnumerable<T> GetDataFromSP<T>(this IUnitOfWork unitOfWork, string query, List<SqlParameter> sqlParameters = null)
        {
            var args = sqlParameters.GetDynamicParameters();

            var data = unitOfWork.GetDataFromSP<T>(query, args);

            sqlParameters.SetOutputParameters(args);

            return data;
        }

        public static IEnumerable<T> GetDataFromQuery<T>(this IUnitOfWork unitOfWork, string queryText, object sqlParameters)
        {
            return unitOfWork.Execute<T>(queryText, sqlParameters);
        }

        public static void ExecuteSP(this IUnitOfWork unitOfWork, string procedure, object parameters = null)
        {
            unitOfWork.Connection.Execute(procedure, parameters, commandType: CommandType.StoredProcedure);
        }

        public static void ExecuteSP(this IUnitOfWork unitOfWork, string procedure, List<SqlParameter> sqlParameters = null)
        {
            var args = sqlParameters.GetDynamicParameters();

            ExecuteSP(unitOfWork, procedure, args);

            sqlParameters.SetOutputParameters(args);
        }

    }
}
