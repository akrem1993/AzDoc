using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using BLL.BaseAdapter;
using BLL.Models.Account;
using LogHelpers;
using Repository.Extensions;
using Repository.Infrastructure;

namespace BLL.CoreAdapters
{
    public class AccountAdapter : AdapterBase
    {
        private bool disposed;

        public AccountAdapter(IUnitOfWork unitOfWork) : base(unitOfWork)
        {
            Log.AddInfo("Init AccountAdapter", " ", "BLL.Adapters.AccountAdapter");
        }

        /// <summary>
        /// Istifadecinin dogrulugunu yoxlayir
        /// </summary>
        /// <param name="userName"></param>
        /// <param name="password"></param>
        /// <param name="result"></param>
        /// <returns>result</returns>
        public UserModel Login(string userName, string password)
        {
            Log.AddInfo("Login", $"params: username={userName}", "BLL.AccoutAdapter.Login");
            try
            {
                var parameters = Extension.Init()
                    .Add("@userName", userName)
                    .Add("@userPassword", CustomHelpers.CustomHelper.Encrypt(password));

                var data = UnitOfWork.ExecuteProcedure<UserModel>("[dbo].[spLoginNew]", parameters).FirstOrDefault();
                return data;
            }
            catch(Exception ex)
            {
                Log.AddError(ex.Message, "BLL.AccountAdapter.Login");
                throw;
            }
        }
        public UserModel ChangeExpirePassword(string userName, string passwordOld, string passwordNew)
        {
            Log.AddInfo("ChangeExpirePassword", $"params: username={userName}", "BLL.AccoutAdapter.ChangeExpirePassword");
            try
            {
                var parameters = Extension.Init()
                    .Add("@userName", userName)
                    .Add("@userPasswordOld", passwordOld)
                    .Add("@userPasswordNew", CustomHelpers.CustomHelper.Encrypt(passwordNew));

                var data = UnitOfWork.ExecuteProcedure<UserModel>("[dbo].[spLoginChangePassword]", parameters).FirstOrDefault();
                return data;
            }
            catch (Exception ex)
            {
                Log.AddError(ex.Message, "BLL.AccountAdapter.ChangeExpirePassword");
                throw;
            }
        }

        public int? GetAuthorityStatus(int workPlaceId)
        {
            Log.AddInfo("GetAuthorityStatus", $"params: workPlaceId={workPlaceId}", "BLL.AccoutAdapter.GetAuthorityStatus");
            try
            {
                var parameters = Extension.Init()
                    .Add("@workPlaceId", workPlaceId);

                int? result = UnitOfWork.ExecuteScalar<int?>("SELECT [dbo].[fnGetAuthorityId](@workPlaceId)", parameters);
                return result;
            }
            catch(Exception ex)
            {
                Log.AddError(ex.Message, "BLL.AccountAdapter.Login");
                throw;
            }
        }


        public List<WorkPlaceModel> GetDcWorkPlace(int? workPlaceUserId)
        {
            Log.AddInfo("GetDcWorkPlace", $"workPlaceUserId:{workPlaceUserId}", "BLL.AccountAdapter.GetDcWorkPlace");
            try
            {
                var parameters = Repository.Extensions.Extension.Init()
                               .Add("@workPlaceUserId", workPlaceUserId)
                               .Add("@result", -100, direction: ParameterDirection.Output);

                var currentUser = UnitOfWork.ExecuteProcedure<WorkPlaceModel>("[dbo].[spGetDcWorkPlace]", parameters).ToList();

                return currentUser;
            }
            catch(Exception ex)
            {
                Log.AddError(ex.Message, "BLL.AccountAdapter.GetDcWorkPlace");
                throw;
            }
        }

        /// <summary>
        /// Istifadeci parolu unudubsa
        /// </summary>
        /// <param name="resetCode"></param>
        /// <param name="userName"></param>
        /// <param name="password"></param>
        /// <param name="result"></param>
        /// <returns>result</returns>
        public void ForgotPassword(string resetCode, string userName, string password, out int result)
        {
            Log.AddInfo("ForgotPassword", $"parametr:{userName},  ", "BLL.AccountAdapter.ForgotPassword");
            try
            {
                var parameters = Extension.Init()
              .Add("@resetCode", resetCode)
              .Add("@userName", userName)
              .Add("@password", CustomHelpers.CustomHelper.Encrypt(password))
              .Add("@result", -100, direction: ParameterDirection.Output);

                UnitOfWork.ExecuteNonQueryProcedure("[dbo].[spForgotPassword]", parameters);
                result = Convert.ToInt32(parameters.First(p => p.ParameterName == "@result").Value);
                Log.AddInfo("RestoredPassword", "BLL.AccountAdapter.ForgotPassword");
            }
            catch(Exception ex)
            {
                Log.AddError(ex.Message, "BLL.AccountAdapter.ForgotPassword");
                throw;
            }
        }

        public override void Dispose()
        {
            Dispose(true);
            base.Dispose();
        }

        protected virtual void Dispose(bool disposing)
        {
            if(!this.disposed)
            {
                if(disposing)
                {
                    UnitOfWork.Dispose();
                }
                disposed = true;
            }
        }
    }
}