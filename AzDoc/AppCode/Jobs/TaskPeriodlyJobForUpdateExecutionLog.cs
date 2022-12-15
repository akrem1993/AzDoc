using BLL.Adapters;
using ORM.Context;
using Quartz;
using Repository.UnitOfWork;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;

namespace AzDoc.AppCode.Jobs
{
    public class TaskPeriodlyJobForUpdateExecutionLog : IJob
    {
        Task IJob.Execute(IJobExecutionContext context)
        {
            using (var unitOfWork = new EFUnitOfWork<DMSContext>())
            using (ReportAdapter adapter = new ReportAdapter(unitOfWork))
            {
                //adapter.GetTaskPeriodForUpdateExecutionLog();
                return null;
            }
        }
    }
}