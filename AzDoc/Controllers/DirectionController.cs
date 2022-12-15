using AzDoc.Helpers;
using BLL.Adapters;
using BLL.Common.Enums;
using BLL.Models.Direction;
using BLL.Models.Direction.Common;
using BLL.Models.Direction.Direction;
using CustomHelpers;
using Repository.Infrastructure;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using AzDoc.BaseControllers;
using Widgets.Helpers;

namespace AzDoc.Controllers
{
    public class DirectionController : BaseController
    {

        public DirectionController(IUnitOfWork unitOfWork):base(unitOfWork)
        {
        }

        public JsonResult DirectionGrid(int? docId, int? pageIndex, int? executorId, int pageSize = 1000)
        {
            var rows = unitOfWork.GetDirection<DocsDirection>(docId, SessionHelper.WorkPlaceId, (int)DirectionType.Resolution, pageIndex, pageSize, out int totalCount);
            var result = new GridViewModel<DocsDirection>
            { TotalCount = totalCount };
            result.Items = rows;
            return Json(result);
        }

        public ActionResult DirectionModal(int docId, int? executorId)
        {
            try
            {
                var rows = unitOfWork.GetDirection<DocsDirection>(docId, SessionHelper.WorkPlaceId, (int)DirectionType.Resolution, null, 1000, out int totalCount);

                if(rows.Count() == 0)
                {
                    SessionHelper.DirectionId = 0;
                    var result = RedirectToAction("DirectionEditPanel", new { docId, directionId = -SessionHelper.WorkPlaceId, t = @Request["t"], operation = 3 });
                    return result;
                }
                else
                {
                    SessionHelper.DirectionId = rows.FirstOrDefault().DirectionId;
                    var doc = unitOfWork.GetDocsInfo<DocumentModel>(docId).FirstOrDefault();
                    doc.DocEnterdateFormat = doc.DocEnterdate.ToString();
                    return PartialView("~/Views/Direction/_DirectionPanel.cshtml", doc);
                }
            }
            catch(Exception ex)
            {
                throw;
            }
        }

        public JsonResult LeftGrid(string t, int? pageIndex, int? pageSize, int wid, int egid = -1)
        {
            var @params = Request.ToSqlParams();
            int directionWorkplaceId = (wid != 0) ? wid : SessionData.DirectionWorkplaceId;

            int x = SessionData.DirectionTypeId;
            int executionstatus = 0;
            var executormain = unitOfWork.GetInfoExecutors<ExecutorModel>(SessionHelper.ResolutionDocId, SessionHelper.WorkPlaceId).FirstOrDefault();
            if(!string.IsNullOrEmpty(Request.Params["AuthorWorkplaceId"]))
            {
                int.TryParse(Request.Params["AuthorWorkplaceId"], out directionWorkplaceId);
            }
            string ExecutorGroupId = Request.Params["ExecutorGroupId"];

            if(executormain != null)
            {
                if(Permissions.Get(RightType.CreateDirection) && Permissions.GetRightByWorkPlace(RightType.CreateDirection, directionWorkplaceId) && executormain.ExecutorMain == 0)
                {
                    executionstatus = 1;
                    // ViewBag.DirConfirm = 1;
                }
            }
            var result = new GridViewModel<ExecutorModel>
            {
                TotalCount = 0,
                MyProperty = executionstatus
            };
            result.Items = AvailableExecutors(directionWorkplaceId, ExecutorGroupId, SessionHelper.ResolutionDocId, egid);
            return Json(result);
        }

        public JsonResult RightGrid(string t, int? pageIndex, int? pageSize)
        {
            var result = new GridViewModel<ExecutorModel>
            { TotalCount = 0 };
            result.Items = SessionData.Executors;
            return Json(result);
        }

        private List<ExecutorModel> AvailableExecutors(int authorWorkplaceId, string executorGroupId, int docId, int egid = -1)
        {
            try
            {
                var queryParams = Request.ToDictionary();

                //egid = Convert.ToInt32(queryParams.GetValue("DepartmentPositionName"));
                var result = unitOfWork.GetUsers<DirectionPersonViewModel>(authorWorkplaceId,docId, Request.ToSqlParams())
                      .Where(x => x.PositionGroupLevel != 800)
                      .Select(x => new ExecutorModel()
                      {
                          ExecutorWorkplaceId = x.WorkPlaceId,
                          ExecutorPositionGroupId = x.PositionGroupId,
                          DepartmentPositionName = x.DepartmentPositionName,
                          ExecutorFullName = x.FullName,
                          PositionGroupLevel = x.PositionGroupLevel,
                          PositionIndicator = egid
                      }).ToList();
                switch(egid)
                {
                    case -100:
                        result = result.Where(p => new[] { 13, 17, 26 }.Contains(p.ExecutorPositionGroupId)).ToList();
                        break;

                    case -200:
                        result = result.Where(p => new[] { 5, 9, 25 }.Contains(p.ExecutorPositionGroupId)).ToList();
                        break;

                    default:
                        break;
                }

                string name = queryParams.GetValue("ExecutorFullName");
                return result.Where(p => (string.IsNullOrWhiteSpace(name) || p.ExecutorFullName.ToUpper().Contains(name.ToUpper()))
                && ((SessionData?.DirectionTypeId == 11 && SessionHelper.WorkPlaceId != authorWorkplaceId) || SessionData?.DirectionTypeId != 11))
                .OrderBy(e => e.PositionGroupLevel).ThenBy(e => e.ExecutorFullName).ToList();
            }
            catch(Exception ex)
            {
                throw ex;
            }
        }

        public ActionResult DirectionEditPanel(int docId, int directionId, string t, int? operation)
        {
            var data = new DirectionModel()
            {
                Authors = new List<SelectListItem>()
            };

            try
            {
                var doc = unitOfWork.GetDirectionInfo<DocumentModel>(docId, directionId).FirstOrDefault();
                var myDoc = unitOfWork.GetDirectionDocs<DirectionModel>(docId, SessionHelper.DirectionId == 0 ? directionId : SessionHelper.DirectionId, null).FirstOrDefault();
                DirectionModel model = new DirectionModel();
                model.TabId = t;
                model.DirectionDocId = docId;
                model.DirectionId = directionId;
                model.DirectionDate = DateTime.Today.Date;
                model.Executors = unitOfWork.GetDirectionExecutors<ExecutorModel>(SessionHelper.DirectionId, myDoc.DirectionWorkplaceId).ToList();

                model.ExecutorGroupId = "";
                if(directionId <= 0)                                          // yeni dərkanar
                {
                    if(Permissions.Get(RightType.CreateDirection))//umumi wobenin mudirnin rolu olacag
                    {
                        model.Authors = GetAuthors(docId, SessionHelper.DirectionId == 0 ? directionId : SessionHelper.DirectionId, myDoc.DirectionTypeId == 18 ? myDoc.DirectionTypeId : model.DirectionTypeId);
                        model.DirectionWorkplaceId = myDoc.DirectionTypeId == 18 ? SessionHelper.WorkPlaceId : (int)myDoc.DirectionWorkplaceId;
                    }
                    else
                    {
                        model.Authors = GetAuthors(docId, directionId, model.DirectionTypeId);
                        model.DirectionWorkplaceId = SessionHelper.WorkPlaceId;
                    }
                    ViewBag.DocStatus = doc.DocDocumentstatusId;
                    ViewBag.DirConfirm = doc.DocSendStatus == null ? 0 : doc.DocSendStatus;
                    ViewBag.ControlStatus = doc.DocControlStatusId;
                    ViewBag.ExStatus = doc.DocExecutionStatusId;
                    ViewBag.Visible = doc.DocExecutionStatus;
                    model.DirectionDate = DateTime.Now.Date;
                    model.DirectionPlanneddate = doc.DocPlanneddate;
                    model.DirectionControlStatus = false;
                    model.Executors = new List<ExecutorModel>();
                    model.AuthorPositionGroupId = SessionHelper.PositionGroupId;
                    model.DirectionTypeId = doc.DirectionTypeId;//gulten oz iscilerini gore bilmesin , derkenar layihesinin hazirlanmasinda
                }
                else                                                            // derkanarın redaktəsi
                {
                    //model.Authors.Clear();
                    model.Authors = GetAuthors(docId, directionId, model.DirectionTypeId);
                    SessionHelper.DirectionId = myDoc?.DirectionConfirmed == 1 ? SessionHelper.DirectionId : 0;///ikinci derkenarin redaktesi
                    model.DirectionPlanneddate = myDoc.DirectionPlanneddate;
                    ViewBag.DirConfirm = doc.DocSendStatus == null ? 0 : doc.DocSendStatus;
                    ViewBag.ControlStatus = doc.DocControlStatusId;//
                    ViewBag.ExStatus = doc.DocExecutionStatusId;
                    model.DirectionWorkplaceId = (int)model.Authors.FirstOrDefault().Value.ToInt();
                    model.Executors = unitOfWork.GetDirectionExecutors<ExecutorModel>(directionId, myDoc.DirectionWorkplaceId).ToList();
                    model.AvailableExecutors = AvailableExecutors(model.DirectionWorkplaceId, model.ExecutorGroupId, docId, -1);
                }

                SessionData = model;
                CacheDoc();
                return PartialView("~/Views/Direction/_DirectionEditPanel.cshtml", model);
            }
            catch(Exception ex)
            {
                throw;
            }

        }

        private List<SelectListItem> GetAuthors(int docId, int directionId, int directiontype)
        {
            List<SelectListItem> persons = new List<SelectListItem>();
            var myDoc = unitOfWork.GetDirectionDocs<DirectionModel>(docId, directionId, SessionHelper.WorkPlaceId).FirstOrDefault();
            persons.Add(new SelectListItem()
            {
                Text = myDoc.DirectionPersonFullName,
                Value = (directionId < 0) ? SessionHelper.WorkPlaceId.ToString() : myDoc.DirectionWorkplaceId.ToString(),
                Selected = true
            });

            var authors = unitOfWork.GetAuthorForDirection<DirectionModel>(docId, directionId, (int)DirectConfirmed.None, SessionHelper.WorkPlaceId, SessionHelper.WorkPlaceId).Select(x => new SelectListItem() { Text = x.DirectionPersonFullName, Value = x.DirectionWorkplaceId.ToString() }).ToList();
            persons.AddRange(authors);
            return persons;
        }

        public ActionResult DirectionSave(DirectionModel direction)
        {
            if(direction.DirectionWorkplaceId != SessionHelper.WorkPlaceId)
                direction.DirectionSendStatus = false;
            else
                direction.DirectionSendStatus = true;
            direction.DirectionCreatorWorkplaceId = SessionHelper.WorkPlaceId;
            direction.Executors = AddExecutors(direction.Executors).ToList();
            DirectionModel DocDirection;
            if(direction.DirectionId <= 0)
            {
                DocDirection = CreateDirection(direction);
            }
            else
                DocDirection = UpdateDirection(direction);

            SessionData = null;
            
            CacheDoc();
            return RedirectToAction("DirectionModal", new { docId = direction.DirectionDocId, directionId = -@SessionHelper.WorkPlaceId });
        }

        private DirectionModel UpdateDirection(DirectionModel direction)
        {
            try
            {
                if(direction == null)
                    return null;
                if(direction.DirectionConfirmed == (int)DirectConfirmed.Confirmed)
                    return null;

                unitOfWork.AddExecutor<ExecutorModel>(direction.Executors, direction.DirectionId, (int)DirectionType.Resolution, direction);
                CacheDoc();
                return direction;
            }
            catch
            {
                return null;
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult DirectionConfirm(int id)
        {
            int operationtype = 3;
            var row = unitOfWork.GetDirectionDocs<DirectionModel>(null, id, null).FirstOrDefault();

            row.DirectionConfirmed = (int)DirectConfirmed.Confirmed;
            row.DirectionDate = DateTime.Now;
            row.DirectionUnixTime = CustomHelper.GetUnixTimeSeconds(DateTime.Now);
            unitOfWork.AddDirection<DirectionModel>(row, Enumerable.Empty<ExecutorModel>(), operationtype);
            CacheDoc();
            return Json(true, JsonRequestBehavior.AllowGet);
            // return JavaScript("toastr.success('Sənəd təsdiq edildi!');$('#exampleModalCenter').remove(); setTimeout(function(){window.location.reload();},500); ");
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult DirectionUnConfirm(int id)
        {
            var row = unitOfWork.GetDirectionDocs<DirectionModel>(null, id, null).FirstOrDefault();

            row.DirectionConfirmed = 0;
            row.DirectionSendStatus = false;
            row.DirectionDate = DateTime.Now;
            unitOfWork.AddDirection<DirectionModel>(row, Enumerable.Empty<ExecutorModel>(), 4);
            CacheDoc();
            return Json(true, JsonRequestBehavior.AllowGet);
            //return JavaScript("toastr.success('Imtina edildi!');$('#exampleModalCenter').remove(); setTimeout(function(){window.location.reload();},500); ");
        }

        private DirectionModel CreateDirection(DirectionModel direction)
        {
            try
            {
                direction.DirectionTypeId = (int)DirectionType.Resolution;
                direction.DirectionConfirmed = (int)DirectConfirmed.None;
                direction.DirectionInsertedDate = DateTime.Today;
                direction.DirectionUnixTime = CustomHelper.GetUnixTimeSeconds(DateTime.Now);
                var workplace = unitOfWork.GetWorkplaceFullInfo<WorkplaceModel>(direction.DirectionWorkplaceId).FirstOrDefault();
                direction.DirectionPersonFullName = workplace.PersonnelFullname;
                if(direction.DirectionCreatorWorkplaceId != direction.DirectionWorkplaceId)
                    direction.DirectionSendStatus = false;
                unitOfWork.AddDirection<DirectionModel>(direction, direction.Executors, 1);
                CacheDoc();
                return direction;
            }
            catch(Exception ex)
            {
                throw;
            }
        }

        private List<ExecutorModel> AddExecutors(List<ExecutorModel> Executors)
        {
            foreach(ExecutorModel executor in Executors)
            {
                int type = executor.ExecutorMain;
                var Workplace = unitOfWork.GetWorkplaceFullInfo<WorkplaceModel>(executor.ExecutorWorkplaceId).FirstOrDefault();
                if(Workplace == null)
                    continue;

                if((Executors.Count(x => x.SendStatusId == (int)SendStatus.Execution) >= 1) && (executor.ExecutorMain == (int)SendStatus.Execution)
                    )
                    continue;

                executor.ExecutorOrganizationId = Workplace.WorkplaceOrganizationId;
                executor.ExecutorTopDepartment = Workplace.DepartmentTopDepartmentId;
                executor.ExecutorDepartment = Workplace.WorkplaceDepartmentId;
                executor.ExecutorSection = Workplace.DepartmentSectionId;
                executor.ExecutorSubsection = Workplace.DepartmentSubSectionId;
            }

            CacheDoc();
            // SessionData.Executors = Executors;
            return Executors;
        }

        private DirectionModel SessionData
        {
            get => SessionHelper.DirectionController;
            set => SessionHelper.DirectionController = value;
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult DirectionSendAuthor(int id)
        {
            var row = unitOfWork.GetDirectionDocs<DirectionModel>(null, id, null).FirstOrDefault();

            row.DirectionSendStatus = true;
            row.DirectionDate = DateTime.Now.AddMinutes(-2);
            row.DirectionCreatorWorkplaceId = SessionHelper.WorkPlaceId;//Nurlan=>DirectionWorkplaceId
            row.DirectionConfirmed = (int)DirectConfirmed.None;
            unitOfWork.AddDirection<DirectionModel>(row, Enumerable.Empty<ExecutorModel>(), 2);
            CacheDoc();
            return Json(true, JsonRequestBehavior.AllowGet);
            //return JavaScript("toastr.success('Sənəd göndərildi!');$('#exampleModalCenter').remove(); setTimeout(function(){window.location.reload();},500); ");
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public int DirectionDelete(int id)
        {
            int docid = SessionHelper.ResolutionDocId;
            var data = unitOfWork.DeleteDirection<DocsDirection>(id);
            CacheDoc();
            return docid;
        }

        public ActionResult InfoBlock(int DocId)
        {
            var doc = unitOfWork.GetDocsInfo<DocumentModel>(DocId).FirstOrDefault();
            var info = unitOfWork.GetInfo<AddressInfo>(DocId, doc.DocTypeId).FirstOrDefault();
            ViewData["info"] = info;
            return Json(new
            {
                docno = info.DocEnterno,
                doctype = info.DocTypeName,
                where = info.OrganizationName,
                note = info.DocDescription,
                control = info.DocUndercontrolStatusId,
                controlministry = info.DocExecutionStatusId,
                controlorg = info.SendToWhere,
            });
        }

        [HttpPost]
        public ActionResult ChangeMainExecutor(int newWorkplaceId, string resolutionNote, bool? jointExecutor)
        {
            int changeType = 1;
             
            var data = unitOfWork.ChangeExecutor<DirectionModel>(changeType, null, 3, SessionHelper.DocTypeId, newWorkplaceId, resolutionNote, SessionHelper.ResolutionDocId, (int)DirectionType.Resolution, SessionHelper.WorkPlaceId, jointExecutor);
            return Json(data);
        }

        [HttpGet]
        public ActionResult ChangeMainExecutor(int docId)
        {
            var id = unitOfWork.GetAuthorWorkplace(docId, SessionHelper.WorkPlaceId);
            var date = unitOfWork.GetDocsInfo<DocumentModel>(SessionHelper.ResolutionDocId).FirstOrDefault();
            string executorfullName = unitOfWork.GetInfoDirection(docId, SessionHelper.WorkPlaceId);
            DirectionModel model = new DirectionModel();
            model.DirectionPlanneddate = date.DocPlanneddate;
            model.Executors = AvailableExecutors(id, "", docId, -1).Where(s => s.PositionGroupLevel != 1 && s.PositionGroupLevel != 2 && s.PositionGroupLevel != 3).ToList();
            if (executorfullName != "")       
            { return Json( new
            {
                executor = executorfullName
            }, JsonRequestBehavior.AllowGet); }
            else if (date.DocPlanneddate < DateTime.Now)
            {
                return Json("ExecutingTimeLate", JsonRequestBehavior.AllowGet);
            }
            else { return View("_ChangeExecutor", model); }           

            
        }

        [HttpGet]
        public ActionResult ConfirmExecutorChanging(int id)
        {
            var info = unitOfWork.GetOldExecutor<DirectionInfo>(id).FirstOrDefault();
            SessionHelper.DirectionId = id;
            return Json(new
            {
                newExecutor = info.NewExecutor,
                oldExecutor = info.OldExecutor,
                executorNote = info.ExecutorNote,
            }, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public ActionResult ConfirmExecutorChanging(int command, string note)
        {
            int sendid = SessionHelper.SenderWorkplaceId;
            var data = unitOfWork.ChangeExecutor<DirectionModel>(null, SessionHelper.DirectionId, command, SessionHelper.DocTypeId, sendid, note, SessionHelper.ResolutionDocId, (int)DirectionType.Resolution, SessionHelper.WorkPlaceId,null);
            CacheDoc();
            return Json(data);
        }

        [HttpGet]
        public ActionResult ChangeExecutionDate(int docid)
        {
            DocumentModel model = new DocumentModel();
            model.DocPlanneddate = unitOfWork.GetExecutionDate(docid);
            CacheDoc();
            return View("_ChangeExecutionDate", model);
        }

        [HttpPost]
        public ActionResult ChangeExecutionDate(DateTime newDate, string resolutionNote)
        {
            int changeType = 2;
            var data = unitOfWork.ChangeExecutionDate<DirectionModel>(changeType, null, 3, SessionHelper.DocTypeId, SessionHelper.WorkPlaceId, resolutionNote, SessionHelper.ResolutionDocId, (int)DirectionType.Resolution, newDate);
            CacheDoc();
            return Json(data);
        }

        [HttpGet]
        public ActionResult ConfirmDatehanging(int id)
        {
            var info = unitOfWork.GetChangedDate<DirectionInfo>(SessionHelper.ResolutionDocId).FirstOrDefault();
            SessionHelper.DirectionId = id;
            CacheDoc();
            return Json(new
            {
                oldPlannedDate = info.OldPlannedDate,
                newPlannedDate = info.NewPlannedDate,
                executorNote = info.ExecutorNote,
            }, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public ActionResult ConfirmDatehanging(int command, string note)
        {
            int sendid = SessionHelper.SenderWorkplaceId;
            var data = unitOfWork.ChangeExecutionDate<DirectionModel>(null, SessionHelper.DirectionId, command, SessionHelper.DocTypeId, sendid, note, SessionHelper.ResolutionDocId, (int)DirectionType.Resolution, null);
            CacheDoc();
            return Json(null);
        }
    }
}