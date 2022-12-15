using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;
using Dapper;
using Repository.Infrastructure;

namespace Repository.Extensions
{
    public static class DataLoadHelper
    {
        public static IEnumerable<T> Execute<T>(this IUnitOfWork unitOfWork,
                                                           string query,
                                                           object parameters = null,
                                                           CommandType commandType = CommandType.Text)
        {
            var data = unitOfWork.Connection.Query<T>(query, parameters, commandType: commandType);

            return data;
        }


        public static async Task<IEnumerable<T>> ExecuteAsync<T>(this IUnitOfWork unitOfWork,
            string query,
            object parameters = null,
            CommandType commandType = CommandType.Text)
        {
            return await unitOfWork.Connection.QueryAsync<T>(query, parameters, commandType: commandType);
        }

        public static DynamicParameters GetDynamicParameters(this List<SqlParameter> sqlParameters)
        {
            var args = new DynamicParameters(new { });
            sqlParameters?.ForEach(p => args.Add(p.ParameterName, p.Value, dbType: p.DbType, direction: p.Direction));

            return args;
        }

        public static void SetOutputParameters(this List<SqlParameter> sqlParameters, DynamicParameters args)
        {
            sqlParameters?.ForEach(x =>
            {
                if (x.Direction == ParameterDirection.Output || x.Direction == ParameterDirection.InputOutput)
                {
                    x.Value = args.Get<object>(x.ParameterName.Replace("@", ""));
                }
            });
        }
    }
}
