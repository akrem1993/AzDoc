using BLL.BaseAdapter;
using CustomHelpers;
using DMSModel;
using LogHelpers;
using Model.Models.FeedBack;
using Newtonsoft.Json;
using Repository.Extensions;
using Repository.Infrastructure;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web.Mvc;
using BLL.Common.Enums;

namespace BLL.Adapters
{
    /// <summary>
    /// FeedBackController'le isleyen adapter
    /// </summary>
    public class FeedbackAdapter : AdapterBase
    {
        public FeedbackAdapter(IUnitOfWork unitOfWork) : base(unitOfWork)
        {
        }

        /// <summary>
        /// Esas cedveli doldurur
        /// </summary>
        /// <returns></returns>
        public JsonViewModel<RequestModel> GetAllRequests(int? pageIndex, int pageSize)
        {
            Log.AddInfo("GetAllRequests", $"pageIndex:{pageIndex},pageSize:{pageSize}", "BLL.FeedbackAdapter.GetAllRequests");
            try
            {
                var parameters = Extension.Init()
              .Add("@pageIndex", pageIndex)
              .Add("@pageSize", pageSize)
              .Add("@totalCount", 0, ParameterDirection.Output);
                var modelItems = UnitOfWork.ExecuteProcedure<RequestModel>("[dbo].[spGetRequests_TEST]", parameters).ToList();

                return new JsonViewModel<RequestModel>
                {
                    Items = modelItems,
                    TotalCount = CustomHelpers.Extensions.ToInt(parameters.First(x => x.ParameterName == "@totalCount").Value)
                };
            }
            catch(Exception ex)
            {
                Log.AddError(ex.Message, "", "BLL.FeedbackAdapter.GetAllRequests");
                throw;
            }
        }

        /// <summary>
        /// Sorgunun ya cavabin yadda saxlanilmasi
        /// </summary>
        /// <param name="requestId">Sorgu nomresi</param>
        /// <param name="requestText">Sorgu mesaji</param>
        /// <param name="answerText">Sorgunun cavabi</param>
        /// <param name="feedBackType">SorguYaCavab</param>
        /// <param name="requestType"></param>
        /// <param name="requestStatus"></param>
        /// <param name="workPlaceId">WorkPlace</param>
        /// <returns></returns>
        public int SetFeedbackRequest(string requestText,
                                      int requestType,
                                      int workPlaceId)
        {
            Log.AddInfo("SetFeedbackRequest", $"requestText:{requestText}," +
                                              $"workplaceId:{workPlaceId}",
                                              "BLL.FeedbackAdapter.SetFeedbackRequest");
            try
            {
                var parameters = Extension.Init().
                           Add("@requestId", 0, ParameterDirection.InputOutput).
                           Add("@answerText", "nothing").
                           Add("@requestText", requestText)
                           .Add("@lastMessageId", 0, ParameterDirection.InputOutput)
                           .Add("@workPlaceId", workPlaceId)
                           .Add("@requestType", requestType);
                UnitOfWork.ExecuteNonQueryProcedure("[dbo].[spFeedBackRequest_TEST]", parameters);
                return parameters.First(x => x.ParameterName == "@lastMessageId").Value.ToInt();
            }
            catch(Exception ex)
            {
                Log.AddError(ex.Message, "", "BLL.FeedbackAdapter.SetFeedbackRequest");
                throw;
            }
        }

        /// <summary>
        /// Muracietin butun mesajlarini ve ona bagli fayllari getirir
        /// </summary>
        /// <param name="requestId">Sorgu nomresi</param>
        /// /// <param name="workPlaceId">workplace nomre</param>
        /// <returns></returns>
        public FeedBackViewModel GetFeedBackChat(int requestId, int workPlaceId)
        {
            Log.AddInfo("GetFeedBackChat",
                        $"requestId:{requestId},workPlaceId:{workPlaceId}",
                        "BLL.FeedbackAdapter.GetFeedBackChat");
            try
            {
                var parameters = Extension.Init()
             .Add("@requestId", requestId)
             .Add("@workPLaceId", workPlaceId);
                string jsonData = UnitOfWork.ExecuteProcedure<string>("[dbo].[spGetFeedBackChat]", parameters).Aggregate((i, j) => i + j);
                return JsonConvert.DeserializeObject<IEnumerable<FeedBackViewModel>>(jsonData).First();
            }
            catch(Exception ex)
            {
                Log.AddError(ex.Message, "", "BLL.FeedbackAdapter.GetFeedBackChat");
                throw;
            }
        }

        /// <summary>
        /// Cavab vermek ucun prosedurun icra edilmesi
        /// </summary>
        /// <param name="requestId">Sorgu nomresi</param>
        /// <param name="answerText">Cavab</param>
        /// <param name="lastMessageId">Cavab verilecek mesaj</param>
        /// <param name="workPlaceId"></param>
        public int AnswerFeedBack(int requestId,
                                  string answerText,
                                  int? lastMessageId,
                                  int workPlaceId)
        {
            Log.AddInfo("AnswerFeedBack",
                $"requestId:{requestId},answerText:{answerText},lastMessageId:{lastMessageId},workPlaceId:{workPlaceId}",
                                                                                    "BLL.FeedbackAdapter.AnswerFeedBack");
            try
            {
                var parameters = Extension.Init().Add("@requestId", requestId, ParameterDirection.InputOutput)
                                                                          .Add("@answerText", answerText)
                                                                          .Add("@requestText", "asd")
                                                                          .Add("@lastMessageId", lastMessageId, ParameterDirection.InputOutput)
                                                                          .Add("@workPlaceId", workPlaceId)
                                                                          .Add("@requestType", 0);
                UnitOfWork.ExecuteNonQueryProcedure("[dbo].[spFeedBackRequest_TEST]", parameters);
                return CustomHelpers.Extensions.ToInt(parameters.First(x => x.ParameterName == "@lastMessageId").Value);
            }
            catch(Exception ex)
            {
                Log.AddError(ex.Message, "", "BLL.FeedbackAdapter.AnswerFeedBack");
                throw;
            }
        }

        /// <summary>
        /// Sorguda yaranan fayllarin melumatini db ye yaziriq
        /// </summary>
        /// <param name="messageId"></param>
        /// <param name="fileGuid"></param>
        /// <param name="workPlaceId"></param>
        /// <param name="fileInfoCapacity"></param>
        /// <param name="fileInfoName"></param>
        /// <param name="fileExtension"></param>
        /// <param name="fileInfoPath"></param>
        public void AddFeedBackFile(int messageId,
                                    string fileGuid,
                                    int workPlaceId,
                                    long? fileInfoCapacity,
                                    string fileInfoName,
                                    string fileExtension,
                                    string fileInfoPath)
        {
            Log.AddInfo("AddFeedBackFile",
                       $"messageId:{messageId},workPlaceId:{workPlaceId},fileInfoName:{fileInfoName},fileInfoPath:{fileInfoPath}",
                         "BLL.FeedbackAdapter.AddFeedBackFile");
            try
            {
                var parameters = Extension.Init()
                          .Add("@messageId", messageId)
                          .Add("@fileGuid", fileGuid)
                          .Add("@fileWorkPlace", workPlaceId)
                          .Add("@fileInfoCapacity", fileInfoCapacity)
                          .Add("@fileInfoName", fileInfoName)
                          .Add("@fileExtension", fileExtension)
                          .Add("@fileInfoPath", fileInfoPath);
                UnitOfWork.ExecuteNonQueryProcedure("[dbo].[spAddFeedBackFile]", parameters);
            }
            catch(Exception ex)
            {
                Log.AddError(ex.Message, "", "BLL.FeedbackAdapter.AddFeedBackFile");
                throw;
            }
        }

        /// <summary>
        /// Müraciətin növü gətirilir
        /// </summary>
        /// <param></param>
        /// <returns></returns>
        public IEnumerable<SelectListItem> GetRequestTypes()
        {
            Log.AddInfo("GetRequestTypes", "BLL.FeedbackAdapter.GetRequestTypes");
            try
            {
                return UnitOfWork.ExecuteProcedure<DC_REQUESTTYPE>("dbo.spGetFeedBackTypes", Extension.Init()).Select(i => new SelectListItem
                {
                    Value = i.RequestTypeId.ToString(),
                    Text = i.RequestTypeName
                });
            }
            catch(Exception ex)
            {
                Log.AddError(ex.Message, "", "BLL.FeedbackAdapter.GetRequestTypes");
                throw;
            }
        }

        public FeedBackMain MainDetails(int workPlaceId)
        {
            Log.AddInfo("MainDetails", $"workPlaceId:{workPlaceId}",
                                  "BLL.FeedbackAdapter.MainDetails");
            try
            {
                return new FeedBackMain
                {
                    UserIsHelper = UnitOfWork.ExecuteScalar<bool>(
                                   "select [dbo].[fnIsPersonnHelperByWorkPlace] (@workPlaceId)",
                                   Extension.Init().Add("@workPlaceId", workPlaceId))
                };
            }
            catch(Exception ex)
            {
                Log.AddError(ex.Message, "", "BLL.FeedbackAdapter.MainDetails");
                throw;
            }
        }

        /// <summary>
        /// baxilmayan mesajlarin istifadeciye gore tapiriq
        /// </summary>
        /// <param name="workPlaceId"></param>
        /// <returns></returns>
        public int GetNotificationCount(int workPlaceId)
        {
            Log.AddInfo("GetNotificationCount", $"workPlaceId:{workPlaceId}", "BLL.FeedbackAdapter.GetNotificationCount");
            try
            {
                return UnitOfWork.ExecuteScalar<int>("select [dbo].[fnGetFeedBackNotificationCount] (@workPlaceId)",
               Extension.Init().Add("@workPlaceId", workPlaceId));
            }
            catch(Exception ex)
            {
                Log.AddError(ex.Message, "", "BLL.FeedbackAdapter.GetNotificationCount");
                throw;
            }
        }
        

    }
}