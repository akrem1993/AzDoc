using Ninject;
using ORM.Context;
using Repository.Infrastructure;
using Repository.UnitOfWork;
using System;
using System.Collections.Generic;
using System.Web.Mvc;
using AppCore.Interfaces;
using AzDoc.Models.Application;

namespace AzDoc.App_Start
{
    public class NInjectResolver : IDependencyResolver
    {
        private IKernel kernel;

        public NInjectResolver(IKernel kernel)
        {
            this.kernel = kernel;

            BindUnitOfWork();

            BindServerPathHandler();
        }

        private void BindUnitOfWork() => kernel.Bind<IUnitOfWork>().To<EFUnitOfWork<DMSContext>>();

        private void BindServerPathHandler() => kernel.Bind<IServerPath>().To<ServerPathHandler>();

        public NInjectResolver() : this(new StandardKernel()) { }

        public object GetService(Type serviceType) => kernel.TryGet(serviceType);

        public IEnumerable<object> GetServices(Type serviceType) => kernel.GetAll(serviceType);

    }
}