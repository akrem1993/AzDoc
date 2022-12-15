
using BLL.Adapters;
using Model.Models.Log;
using ORM.Context;
using Repository.UnitOfWork;

namespace AzDoc.Helpers
{
    public static class LogHelper
    {
        public static void DbLog(LogModel model)
        {
            using(var unitOfWork = new EFUnitOfWork<DMSContext>())
            {
                using(var adapter = new LogAdapter(unitOfWork))
                {
                    adapter.LogData(model);
                }
            }
        }
    }
}