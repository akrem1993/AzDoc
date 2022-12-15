using AzDoc.App_Start;
using GleamTech.DocumentUltimate.AspNet;
using LogHelpers;
using System;
using System.Web;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;
using AzDoc.AppCode.Jobs;
using Quartz;
using Quartz.Impl;

namespace AzDoc
{
    public class MvcApplication : HttpApplication
    {
        StdSchedulerFactory factory;

        private IScheduler scheduler = null;
        private IJobDetail job = null;
        private ITrigger trigger;

        protected void Application_Start()
        {
            Log.LogApplicationStart();
            AreaRegistration.RegisterAllAreas();
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
            ModelBinderConfig.Configure(ModelBinders.Binders);
            MapperConfig.Register();
            ControllerBuilder.Current.SetControllerFactory(typeof(AsyncControllerFactory));
            DocumentUltimateWebConfiguration.Current.CacheMaxAge = TimeSpan.Zero;

            DependencyResolver.SetResolver(new NInjectResolver());

            //PeriodlyTaskForReport();
            //PeriodlyTask();

        }

        //private void PeriodlyTask()
        //{
        //    scheduler = StdSchedulerFactory.GetDefaultScheduler();
        //    scheduler.Start();

        //    job = JobBuilder.Create<TaskPeriodlyJob>().Build();
        //    trigger = TriggerBuilder.Create()
        //        .WithIdentity("TaskPeriodlyJob", "TaskJobGroup")
        //        .WithCronSchedule("0 0 22 * * ? *")
        //        //.WithCronSchedule("* * * ? * * *")
        //        .Build();
        //    scheduler.ScheduleJob(job, trigger);

        //}

        //private async void PeriodlyTaskForReport()
        //{
        //    if (factory == null)
        //    {
        //        factory = new StdSchedulerFactory();
        //    }
        //    // get a scheduler
        //    scheduler = await factory.GetScheduler();
        //    await scheduler.Start();

        //    //scheduler = StdSchedulerFactory.GetDefaultScheduler();
        //    //scheduler.Start();

        //    job = JobBuilder.Create<TaskPeriodlyJobForUpdateExecutionLog>().Build();
        //    trigger = TriggerBuilder.Create()
        //        .WithIdentity("TaskPeriodlyJobForUpdateExecutionLog", "TaskJobGroup")
        //        .WithCronSchedule("0 0/5 * * * ?")
        //        //.WithCronSchedule("0 0 22 * * ? *")
        //        //.WithCronSchedule("* * * ? * * *")
        //        .Build();
        //    await scheduler.ScheduleJob(job, trigger);

        //}

        protected void Application_End() => Log.LogApplicationEnd();
    }
}