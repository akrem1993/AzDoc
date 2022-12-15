using BLL.BaseAdapter;
using BLL.Models.Account;
using BLL.Models.Document;
using DMSModel;
using Newtonsoft.Json;
using Repository.Extensions;
using Repository.Infrastructure;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace BLL.Adapters
{
    public class SettingAdapter : AdapterBase
    {
        private bool disposed;

        public SettingAdapter(IUnitOfWork unitOfWork) : base(unitOfWork) { }


        public SettingModel GetNotifications(int userid)
        {
            var parameters = Extension.Init()
                .Add("@userid", userid);
            return UnitOfWork.ExecuteProcedure<SettingModel>("[dbo].[spGetNotifications]", parameters).FirstOrDefault();
        }

        public SettingModel Settings(int userId)
        {
            var parameters = Extension.Init()
                .Add("@userId", userId);
            string jsonData = UnitOfWork.ExecuteProcedure<string>("[dbo].[spGetSettings]", parameters).Aggregate((i, j) => i + j);
            return JsonConvert.DeserializeObject<IEnumerable<SettingModel>>(jsonData).First();
        }
        /// <summary>
        /// Istifade parolunu deyishmek istiyirse
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="oldPassword"></param>
        /// <param name="newPassword"></param>
        /// <param name="result"></param>
        /// <returns>result</returns>
        public bool ChangePassword(int? userId, string oldPassword, string newPassword)
        {
            var parameters = Extension.Init()
           .Add("@userId", userId)
           .Add("@oldPassword", CustomHelpers.CustomHelper.Encrypt(oldPassword))
           .Add("@newPassword", CustomHelpers.CustomHelper.Encrypt(newPassword))
           .Add("@result", 0, direction: ParameterDirection.InputOutput);

            UnitOfWork.ExecuteNonQueryProcedure("[dbo].[spChangePassword]", parameters);
            return Convert.ToInt16(parameters.FirstOrDefault(p => p.ParameterName == "@result")?.Value) == 1;

        }
        public string GetPasswordByWorkPlaceId(int? userId)
        {
            var parameters = Extension.Init()
            .Add("@userId", userId);

            string a = UnitOfWork.ExecuteProcedure<string>(" [dbo].[spGetPasswordByWorkPlaceId]", parameters).FirstOrDefault().ToString();
            return a;
        }

        /// <summary>
        /// Menu getirir
        /// </summary>
        /// <returns></returns>
        public IEnumerable<DC_TREE> GetChangeDefaultPage()
        {
            return UnitOfWork.ExecuteProcedure<DC_TREE>("[dbo].[spGetDcTree]").ToList();
        }
        //Dili get elemek
        public IEnumerable<ChooseModel> GetChangeDefaultLanguage(int? userId)
        {
            var parametrs = Extension.Init()
                .Add("@userId", userId);
            return UnitOfWork.ExecuteProcedure<ChooseModel>("[dbo].[spGetLanguage]", parametrs).ToList();
        }
        /// <summary>
        /// Istifade default veziyyetde hansi menudan istifade etsin
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="treeId"></param>
        /// <param name="result"></param>
        /// <returns>result</returns>
        public int ChangeDefaultPage(int? userId, int? treeId, out int result)
        {
            var parameters = Extension.Init()
           .Add("@userId", userId)
           .Add("@treeId", treeId)
           .Add("@result", -100, direction: ParameterDirection.Output);
            UnitOfWork.ExecuteNonQueryProcedure("[dbo].[spDcTreeOperation]", parameters);
            result = Convert.ToInt32(parameters.FirstOrDefault(p => p.ParameterName == "@result")?.Value);
            return result;
        }
        public int NotifySettingPartial(int? userId, bool? notifications, out int result)
        {
            var parameters = Extension.Init()
                          .Add("@userId", userId)
                          .Add("@notifications", notifications)
                          .Add("@result", -100, direction: ParameterDirection.Output);
            UnitOfWork.ExecuteNonQueryProcedure("[dbo].[spNotificationsOperation]", parameters);
            result = Convert.ToInt32(parameters.FirstOrDefault(p => p.ParameterName == "@result")?.Value);
            return result;
        }

        public IEnumerable<ChooseModel> GetDefaultLanguage(int? userId)
        {
            var parameters = Extension.Init()
            .Add("@userId", userId);
            return UnitOfWork.ExecuteProcedure<ChooseModel>("[dbo].[spGetLanguage]", parameters).ToList();
        }
        public int AddDefaultLanguage(int? userId, int langId, out int result)
        {
            var parameters = Extension.Init()
                      .Add("@userId", userId)
                      .Add("@langId", langId)
                      .Add("@result", -100, direction: ParameterDirection.InputOutput);
            UnitOfWork.ExecuteNonQueryProcedure("[dbo].[spAddLanguage]", parameters);

            return result = Convert.ToInt16(parameters.FirstOrDefault(p => p.ParameterName == "@result")?.Value);

        }

        public override void Dispose()
        {
            Dispose(true);
            base.Dispose();
        }
        protected virtual void Dispose(bool disposing)
        {
            if (!this.disposed)
            {
                if (disposing)
                {
                    UnitOfWork.Dispose();
                }
                disposed = true;
            }
        }



    }
}
