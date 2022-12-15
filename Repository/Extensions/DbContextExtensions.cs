using Repository.Infrastructure;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Runtime.InteropServices;
using System.Threading.Tasks;

namespace Repository.Extensions
{
    public static partial class Extension
    {
        public static string GetDirectionHint(this ParameterDirection direction)
        {
            switch (direction)
            {
                case ParameterDirection.Output:
                case ParameterDirection.InputOutput:
                    return " out";

                case ParameterDirection.ReturnValue:
                case ParameterDirection.Input:
                default:
                    return "";
            }
        }


        public static List<T> ExecuteSqlQuery<T>(this IUnitOfWork uow, string sqlCommand)
        {
            try
            {
                return uow.Context.Database.SqlQuery<T>(sqlCommand).ToList();
            }
            catch
            {
                throw;
            }
        }

        static public T ExecuteScalar<T>(this IUnitOfWork uow, string sqlCommand, List<SqlParameter> parameters)
        {
            try
            {
                return uow.Context.Database.SqlQuery<T>(sqlCommand, parameters.ToArray()).FirstOrDefault();
            }
            catch
            {
                throw;
            }
            finally
            {
                parameters.Clear();
            }
        }

        static public List<T> ExecuteCommand<T>(this IUnitOfWork uow, string sqlCommand, List<SqlParameter> parameters)
        {
            try
            {
                //    var connection = (SqlConnection)uow.Context.Database.Connection;

                //        connection.Open();
                return uow.Context.Database.SqlQuery<T>(sqlCommand, parameters.ToArray()).ToList();


            }
            catch
            {
                throw;
            }
            finally
            {
                parameters.Clear();
            }
        }

        public static T ExecuteValueProcedure<T>(this IUnitOfWork uow, string procedure, [Optional] List<SqlParameter> parameters) where T : class
        {
            try
            {
                if (parameters == null) return uow.Context.Database.SqlQuery<T>(procedure).First();

                string parameterList = string.Join(",", parameters.ToList().Select(
                    x => $"{x.ParameterName}={x.ParameterName}{x.Direction.GetDirectionHint()}"));

                procedure = $"{procedure} {parameterList}";

                return uow.Context.Database.SqlQuery<T>(procedure, parameters.ToArray()).First();
            }
            catch
            {
                throw;
            }
            finally
            {
            }
        }

        static public IEnumerable<T> ExecuteProcedure<T>(this IUnitOfWork uow, string procedure, [Optional] List<SqlParameter> parameters) where T : class
        {
            try
            {
                if (parameters == null)
                    return uow.Context.Database.SqlQuery<T>(procedure).ToList();

                string parameterList = string.Join(",",
                    parameters.ToList().Select(x =>
                        string.Format("{0}={0}{1}", x.ParameterName, x.Direction.GetDirectionHint())));
                procedure = string.Format("{0} {1}", procedure, parameterList);

                var data = uow.Context.Database.SqlQuery<T>(procedure, parameters.ToArray()).ToList();
                return data;
            }
            catch
            {
                throw;
            }
            finally
            {
            }
        }



        static public IEnumerable<T> ExecuteProcedure2<T>(this IUnitOfWork uow, string procedure, [Optional] List<SqlParameter> parameters) where T : class
        {
            try
            {
                if (parameters == null)
                    return uow.Context.Database.SqlQuery<T>(procedure).ToList();

                return uow.Context.Database.SqlQuery<T>(procedure, parameters.ToArray()).ToList();
            }
            catch
            {
                throw;
            }
            finally
            {
            }
        }

        static public IEnumerable<T> ExecuteFunction<T>(this IUnitOfWork uow, string procedure, [Optional] List<SqlParameter> parameters)
        {
            try
            {
                if (parameters == null)
                    return uow.Context.Database.SqlQuery<T>(procedure).ToList();

                var result = uow.Context.Database.SqlQuery<T>(procedure, parameters).ToList();

                return result;
            }
            catch
            {
                throw;
            }
            finally
            {
            }
        }

        static public void ExecuteNonQueryProcedure(this IUnitOfWork uow, string procedure, [Optional] List<SqlParameter> parameters)
        {
            using (var cmd = new SqlCommand(procedure, (SqlConnection)uow.Context.Database.Connection) { CommandType = CommandType.StoredProcedure })
            {
                try
                {
                    if (parameters != null)
                        cmd.Parameters.AddRange(parameters.ToArray());
                    cmd.Connection.Open();
                    cmd.ExecuteNonQuery();
                }
                catch
                {
                    throw;
                }
                finally
                {
                    cmd.Connection.Close();
                }
            }
        }


        public static void ExcTransaction(this IUnitOfWork uow, string procedure, [Optional] List<SqlParameter> parameters)
        {
            var connection = (SqlConnection)uow.Context.Database.Connection;
            var command = new SqlCommand(procedure, connection)
            {
                CommandType = CommandType.StoredProcedure
            };

            using (connection)
            using (command)
            {
                if (parameters != null) command.Parameters.AddRange(parameters.ToArray());

                using (var transaction = connection.BeginTransaction())
                {
                    try
                    {
                        command.Transaction = transaction;
                        command.Connection.Open();
                        command.ExecuteNonQuery();
                        transaction.Commit();
                    }
                    catch
                    {
                        transaction.Rollback();
                        throw;
                    }
                }
            }
        }

        public static void ExecuteAllCommandTasks(this IUnitOfWork unitOfWork, params Action[] actions)
        {
            var connection = (SqlConnection)unitOfWork.Context.Database.Connection;

            if (connection.State != ConnectionState.Open)
                connection.Open();

            Task.WaitAll(actions.Select(x => Task.Run(x)).ToArray());
        }
    }
}