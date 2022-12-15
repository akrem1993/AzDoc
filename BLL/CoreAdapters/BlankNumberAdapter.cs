using BLL.Models.BlankNumber;
using Repository.Extensions;
using Repository.Infrastructure;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Mvc;

namespace BLL.CoreAdapters
{
    static public class BlankNumberAdapter
    {
        static public IEnumerable<T> GetBlankNumber<T>(this IUnitOfWork unitOfWork)
        {
            try
            {
               
                return unitOfWork.ExecuteSqlQuery<T>("select Id, BlankType from DocBlankTypes");

            }
            catch (Exception ex)
            {

                throw;
            }

        }
        static public IEnumerable<T> AddBlankNumber<T>(this IUnitOfWork unitOfWork, List<BlankNumberModel> blanks, int blankDocId) where T:class
        {
            try
            {
                var table = CustomHelpers.Extensions.ToDataTable(blanks);
                var parameters = new List<SqlParameter>();           
                parameters.Add("@blankNumbers",table, "dbo.UdttBlankNumbers")
                    .Add("@blankDocId", blankDocId)
                    .Add("@blankDocType", 12);
                var data = unitOfWork.ExecuteProcedure<T>("[outgoingdoc].[AddBlankNumber]", parameters);
                return data;
                
                   

                
            }
            catch (Exception ex)
            {

                throw;
            }

        }
    }
}
