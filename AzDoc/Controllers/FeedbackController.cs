using AzDoc.Attributes;
using AzDoc.Helpers;
using BLL.Adapters;
using Model.Models.FeedBack;
using Repository.Infrastructure;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using AzDoc.BaseControllers;
using LogHelpers;
using AppCore.Interfaces;

namespace AzDoc.Controllers
{
    public class FeedbackController : BaseController
    {
        public FeedbackController(IUnitOfWork unitOfWork) : base(unitOfWork) { }

        /// <summary>
        /// Esas sehifeye giris ve detallarini gondermek
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public ActionResult FeedbackRequest()
        {
            using(FeedbackAdapter adapter = new FeedbackAdapter(unitOfWork))
            {
                var model = adapter.MainDetails(SessionHelper.WorkPlaceId);
                return View(model);
            }
        }

        /// <summary>
        /// Butun muracietleri getiren ve esas cedvele yigan metod
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        public JsonResult FeedBackData(int? pageIndex, int pageSize = 20)
        {
            using(FeedbackAdapter feedbackAdapter = new FeedbackAdapter(unitOfWork))
            {
                return Json(feedbackAdapter.GetAllRequests(pageIndex, pageSize));
            }
        }

        /// <summary>
        /// Yeni muracietin yaradilmasi formasi
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public ActionResult RequestFormPartial()
        {
            using(var adapter = new FeedbackAdapter(unitOfWork))
            {
                ViewData["Menu"] = adapter.GetRequestTypes();
                return PartialView("_RequestFormPartial");
            }
        }

        /// <summary>
        /// Muracietin mesajlarini almaq ve view'ya oturmek
        /// </summary>
        /// <param name="requestId"></param>
        /// <returns></returns>
        [HttpGet]
        public ActionResult GetRequestMessages(int requestId)
        {
            using(FeedbackAdapter feedbackAdapter = new FeedbackAdapter(unitOfWork))
            {
                FeedBackViewModel model = feedbackAdapter.GetFeedBackChat(requestId, SessionHelper.WorkPlaceId);
                return PartialView("_RequestDetailsPartial", model);
            }
        }

        /// <summary>
        /// Mesajlari gormek ucun view
        /// </summary>
        /// <param name="message"></param>
        /// <param name="status"></param>
        /// <returns></returns>
        [HttpGet]
        public ActionResult FeedbackMessage(string message, int status)
        {
            ViewBag.Message = message;
            ViewBag.Status = status;
            return PartialView();
        }

        /// <summary>
        /// yeni sorgu yaradilmasi ucun post metod
        /// </summary>
        /// <param name="RequestTxtMemo"></param>
        /// <param name="RequestType"></param>
        /// <param name="files"></param>
        /// <returns></returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult FeedbackRequest(string RequestTxtMemo, int RequestType, IEnumerable<HttpPostedFileBase> files)
        {
            using(FeedbackAdapter adapter = new FeedbackAdapter(unitOfWork))
            {
                int messageId = adapter.SetFeedbackRequest(RequestTxtMemo,
                    RequestType,
                    SessionHelper.WorkPlaceId);

                return UploadFeedBackFiles(adapter, files, messageId);
            }

        }

        /// <summary>
        /// Ftp server isleyib islememeyini yoxlayiriq
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        public JsonResult PingFtp() => Json(SFTPHelper.CheckSftpServer());

        /// <summary>
        /// Ftp server isleyib islememeyini yoxlayiriq
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        public JsonResult PingSession() => Json(Session.Timeout);

        /// <summary>
        /// Fayllarrin melumatini ftp-ye atib ve onun metlumatini bazaya yazmaq
        /// </summary>
        /// <param name="adapter"></param>
        /// <param name="files"></param>
        /// <param name="requestId"></param>
        /// <param name="messageId"></param>
        private ActionResult UploadFeedBackFiles(FeedbackAdapter adapter, IEnumerable<HttpPostedFileBase> files, int messageId)
        {
            if(files.First() != null)
            {
                foreach(var file in files)
                {
                    var fileInfo = UploadControlHelper.UploadDocsFile(file);
                    if(fileInfo != null)
                    {
                        adapter.AddFeedBackFile(messageId,
                            fileInfo.FileInfoGuId,
                            SessionHelper.WorkPlaceId,
                            fileInfo.FileInfoCapacity,
                            fileInfo.FileInfoName,
                            fileInfo.FileInfoExtention,
                            fileInfo.FileInfoPath);
                    }
                    else
                    {
                        return RedirectToAction(nameof(FeedbackMessage), new
                        {
                            message = "Faylın yüklənməsində xəta baş verdi!" + Environment.NewLine +
                                      "Müraciət faylsız qeydə alındı.",
                            status = 0
                        });
                    }
                }
            }

            return RedirectToAction(nameof(FeedbackMessage), new { message = "Müraciət qeydə alındı !", status = 1 });
        }

        /// <summary>
        /// Baxilmayayan mesajlarini sayini tapiriq
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public string GetUnseenMessagesCount()
        {
            using(FeedbackAdapter adapter = new FeedbackAdapter(unitOfWork))
            {
                return adapter.GetNotificationCount(SessionHelper.WorkPlaceId).ToString();
            }
        }

        /// <summary>
        /// Cavab vermek ucun post metodu
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Answer(FeedBackViewModel model, HttpPostedFileBase[] files)
        {
            using(FeedbackAdapter adapter = new FeedbackAdapter(unitOfWork))
            {
                int messageId = adapter.AnswerFeedBack(model.RequestId,
                                                        model.AnswerText,
                                                        model.LastMessageId,
                                                        SessionHelper.WorkPlaceId);

                UploadFeedBackFiles(adapter, files, messageId);
            }

            return RedirectToAction(nameof(GetRequestMessages), new { requestId = model.RequestId });
        }
    }
}