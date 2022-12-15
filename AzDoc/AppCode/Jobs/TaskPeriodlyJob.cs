using System.Threading.Tasks;
using BLL.Adapters;
using ORM.Context;
using Quartz;
using Repository.UnitOfWork;

namespace AzDoc.AppCode.Jobs
{
    public class TaskPeriodlyJob : IJob
    {
        //public void Execute(IJobExecutionContext context)
        //{
        //    using (var unitOfWork = new EFUnitOfWork<DMSContext>())
        //    using (DocumentAdapter adapter = new DocumentAdapter(unitOfWork))
        //    {
        //        adapter.GetTaskPeriod();
        //    }
        //}

        Task IJob.Execute(IJobExecutionContext context)
        {
            using (var unitOfWork = new EFUnitOfWork<DMSContext>())
            using (DocumentAdapter adapter = new DocumentAdapter(unitOfWork))
            {
                adapter.GetTaskPeriod();
                return null;
            }
        }
    }
}