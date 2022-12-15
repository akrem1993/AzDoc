using AzDoc.Helpers;
using Repository.Infrastructure;
using Smdo.Api;
using Smdo.Api.ApiModels;
using Smdo.AzDoc.Models;
using Smdo.EmailModels;
using Smdo.Enums;
using Smdo.Helpers;
using Smdo.Smpt;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Web.Mvc;
using SmdoAdapter = Smdo.AzDoc.Adapters.DocumentAdapter;

namespace AzDoc.Areas.Smdo.Controllers
{
    [AllowAnonymous]
    public class MailController : Controller
    {
        private readonly IUnitOfWork unitOfWork;

        private static string attachmentPath;
        private readonly SendMail sendMail;
        private readonly EmailHelper emailHelper;

        public MailController(IUnitOfWork unitOfWork)
        {
            this.unitOfWork = unitOfWork;
            //ImapListener.Start(Server.MapPath(@"~\App_Data\UploadTemp\"));
            emailHelper = new EmailHelper(attachmentPath,
                                          string.Empty);
            sendMail = new SendMail();
        }

        public ActionResult GetMailView()
        {
            attachmentPath = Server.MapPath(@"~\App_Data\UploadTemp\");
            return View();
        }


        private void ValidateDocForSending(GridViewDoc doc)
        {
            if (doc is null) throw new ArgumentException("Sened tapilmadi");

            if (doc.IsReceived) throw new ArgumentException("Senedi gondermek olmaz");

            if (doc.DocStatus == 1) throw new ArgumentException("Sened imzalanmayib");

            if (doc.DocStatus == 3) throw new ArgumentException("Sened artiq gonderilib");
        }


        [HttpPost]
        public JsonResult SendDocumentToSmdo()
        {
            using (SmdoAdapter adapter = new SmdoAdapter(unitOfWork))
            {
                int docId = SessionHelper.CurrentDocId;

                var doc = adapter.GetCurrentDoc(docId);

                ValidateDocForSending(doc);

                string path = attachmentPath = Server.MapPath(@"~\App_Data\UploadTemp\") + $"{doc.DocMsgGuid}/";

                EmailHelper helper = new EmailHelper(path, string.Empty);

                var xmlData = helper.GetDocXml(doc);

                var xmlFilePath = helper.SaveXmlFile(xmlData, MailType.Mail);

                var emailForm = new EmailForm
                {
                    ToEmail = "mailaz@prb.by",
                    Attaches = GetAttachFiles(xmlFilePath, doc),
                    Subject = xmlData.Subject
                };

                sendMail.SendEmail(emailForm);
                adapter.AddDocSubject(docId, xmlData.Subject);

                adapter.ChangeDocStatus(docId, (int)DocStatus.Sended);

                return Json(true, JsonRequestBehavior.AllowGet);
            }
        }

        private List<AttachFile> GetAttachFiles(string docXmlPath, GridViewDoc doc)
        {
            List<AttachFile> attachFiles = new List<AttachFile>();

            attachFiles.Add(new AttachFile
            {
                AttachPath = docXmlPath,
                AttachType = AttachType.Xml
            });

            attachFiles.Add(new AttachFile
            {
                AttachPath = attachmentPath + doc.DocFilePath,
                FileName = "attach1"
            });

            return attachFiles;
        }

        [HttpGet]
        public ActionResult GetKvitansiya()
        {
            using (SmdoAdapter adapter = new SmdoAdapter(unitOfWork))
            {
                int docId = SessionHelper.CurrentDocId;

                var doc = adapter.GetCurrentDoc(docId);

                doc.Checks = adapter.GetChecks(docId);

                //doc.DtsStep = adapter.GetDtsSteps(docId);

                doc.SignerSubjects = adapter.GetDvcSubject(docId);

                return View("~/Areas/Smdo/Views/Document/Kvitansiya.cshtml", doc);
            }
        }

        [HttpPost]
        public ActionResult VerifyReceivedDoc()
        {
            using (SmdoAdapter adapter = new SmdoAdapter(unitOfWork))
            {
                int docId = SessionHelper.CurrentDocId;
                var doc = adapter.GetCurrentDoc(docId);
                //doc.DtsStep = adapter.GetDtsSteps(docId);

                var dts = new VerifyDts(Server.MapPath(@"~\App_Data\UploadTemp\"),
                                                                    doc.DocMsgGuid,
                                                                    doc.AttachName);

                //var steps = doc.DtsStep;
                dts.Initialize();
                Thread.Sleep(1000);
                dts.UploadSignedFile();
                Thread.Sleep(1000);
                dts.UploadDataFile();
                Thread.Sleep(4000);
                dts.DownloadDvc();
                DvcParse dvc = dts.ParseDvc();

                if (dvc is null || dvc.statusCode == 2)
                    return Json(false, JsonRequestBehavior.AllowGet);

                adapter.SetDvcBase64(docId, dts.DvcBase64);

                foreach (var check in dvc.dvcValidationResult.checkers)
                    adapter.AddDtsCheck(docId, check);


                foreach (var subj in dvc.dvcValidationResult.dvcSigners)
                    adapter.SetSubject(docId, subj);

                if (dvc.dvcValidationResult.documentSigners != null)
                {
                    var signer = dvc.dvcValidationResult.documentSigners.FirstOrDefault();

                    adapter.AddDvcSigner(docId, signer);
                }

                if (dvc.dvcValidationResult.allValid == 0)
                {
                    adapter.AddDtsStep(docId, (int)DtsStep.ParseDvc);
                    adapter.ChangeDocStatus(docId, (int)DocStatus.ConfirmedDts);
                    return Json(true, JsonRequestBehavior.AllowGet);
                }


                //if (!steps.Any(x => x.StepId == (int)DtsStep.Initialize))
                //{
                //    dts.Initialize();
                //    adapter.AddDtsStep(docId, (int)DtsStep.Initialize);
                //}

                //if (!steps.Any(x => x.StepId == (int)DtsStep.UploadSignedFile))
                //{
                //    dts.UploadSignedFile();
                //    adapter.AddDtsStep(docId, (int)DtsStep.UploadSignedFile);
                //}

                //if (!steps.Any(x => x.StepId == (int)DtsStep.UploadDataFile))
                //{
                //    dts.UploadDataFile();
                //    adapter.AddDtsStep(docId, (int)DtsStep.UploadDataFile);
                //}

                //if (!steps.Any(x => x.StepId == (int)DtsStep.DownloadDvc))
                //{
                //    dts.DownloadDvc();
                //    adapter.AddDtsStep(docId, (int)DtsStep.DownloadDvc);
                //}

                //if (!steps.Any(x => x.StepId == (int)DtsStep.ParseDvc))
                //{
                //    if (steps.Any(x => x.StepId == (int)DtsStep.DownloadDvc))
                //    {
                //        dts.DvcBase64 = doc.DvcBase64;
                //    }

                //    DvcParse dvc = dts.ParseDvc();

                //    if (dvc is null || dvc.statusCode == 2)
                //        return Json(false, JsonRequestBehavior.AllowGet);

                //    adapter.SetDvcBase64(docId, dts.DvcBase64);

                //    foreach (var check in dvc.dvcValidationResult.checkers)
                //        adapter.AddDtsCheck(docId, check);


                //    foreach (var subj in dvc.dvcValidationResult.dvcSigners)
                //        adapter.SetSubject(docId, subj);

                //    if (dvc.dvcValidationResult.allValid == 0)
                //    {
                //        adapter.AddDtsStep(docId, (int)DtsStep.ParseDvc);
                //        adapter.ChangeDocStatus(docId, (int)DocStatus.ConfirmedDts);
                //        return Json(true, JsonRequestBehavior.AllowGet);
                //    }
                //}

                return Json(false, JsonRequestBehavior.AllowGet);
            }



        }





    }
}