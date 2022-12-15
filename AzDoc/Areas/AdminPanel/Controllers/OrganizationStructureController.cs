using Admin.Adapters;
using Admin.Common.Enums;
using Admin.Model.EntityModel;
using Admin.Model.FormModel;
using Admin.Model.ViewModel;
using Admin.Model.ViewModel.AuthorityRelatedModel;
using Admin.Model.ViewModel.TopicRelatedModel;
using AzDoc.Areas.AdminPanel.Models;
using AzDoc.BaseControllers;
using AzDoc.Helpers;
using BLL.Models.Document;
using DMSModel;
using DocumentFormat.OpenXml.Vml.Spreadsheet;
using Model.DB_Tables;
using Repository.Infrastructure;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using System.Web.Security;
using System.Web.UI;
using Admin.Model.ViewModel.EditDocument;
using Widgets.Helpers;

namespace AzDoc.Areas.AdminPanel.Controllers
{

    public class OrganizationStructureController : BaseController
    {
        public OrganizationStructureController(IUnitOfWork unitOfWork) : base(unitOfWork)
        {
        }

        // GET: AdminPanel/OrganizationalStructure
        public ActionResult Index()
        {
            using (OrganizationStructureAdapter adapter = new OrganizationStructureAdapter(unitOfWork))
            {
                List<Structure> structures = adapter.GetStructures2(SessionHelper.WorkPlaceId).ToList();

                return View(structures);
            }
        }

        public ActionResult GetUserStatistics(int? orgId)
        {
            using (OrganizationStructureAdapter adapter = new OrganizationStructureAdapter(unitOfWork))
            {
                var statistics = adapter.GetUserStatistics(orgId).First();
                UserStatistics modelStatistics = new UserStatistics()
                {
                    TotalUsers = statistics.ActiveUsers + statistics.DeactiveUsers,
                    ActiveUsers = statistics.ActiveUsers,
                    DeactiveUsers = statistics.DeactiveUsers,
                    MaxUserCount = statistics.MaxUserCount
                };
                return PartialView("UserStatisticsPartial", modelStatistics);
            }
        }

        [HttpPost]
        public JsonResult User(int pageIndex = 1, int pageSize = 20, int structId = 1, int structType = 0)
        {
            using (OrganizationStructureAdapter adapter = new OrganizationStructureAdapter(unitOfWork))
            {

                return Json(adapter.GetUserViewModels(SessionHelper.WorkPlaceId, (int)UserOperation.UserGrid, pageIndex, pageSize, structId,
                    structType, Request.ToSqlParams()));
            }
        }

        [HttpGet]
        public ActionResult GetCreateUser()
        {
            ViewBag.IsEdit = false;
            UserInfoWithOtherData model = new UserInfoWithOtherData();
            using (OrganizationStructureAdapter adapter = new OrganizationStructureAdapter(unitOfWork))
            {
                model.UserDetailsWithWorkplaces = new UserDetailsWithWorkplaces
                {
                    UserStatus = true,
                    JsonWorkPlace = new List<UserWorkPlace>
                    {
                        new UserWorkPlace
                        {
                            AllRoles = adapter.GetRoleViewModels(),
                            Departments = new List<DeptViewModel>(),
                            DepartmentPositions = new List<DeptPositionViewModel>(),
                            Roles = new List<RoleViewModel>(),
                            Sectors = new List<DeptViewModel>(),
                            Organisations = adapter.GetOrgViewModels(),
                        }
                    }
                };
                model.Structures = adapter.GetStructures2(SessionHelper.WorkPlaceId).ToList();
            }

            return View("UserPanel", model);
        }

        [HttpPost]
        public JsonResult PostCreateUser(UserDetailsWithWorkplaces model)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return Json(false);
                }
                using (OrganizationStructureAdapter adapter = new OrganizationStructureAdapter(unitOfWork))
                {
                    adapter.CreateUser(model, out int result);
                }
                return Json(new { result = true });
            }
            catch (Exception e)
            {

                throw;
            }

        }

        [HttpGet]
        public ActionResult GetEditUser(int userId)
        {
            if (userId < 1)
                return HttpNotFound();
            using (OrganizationStructureAdapter adapter = new OrganizationStructureAdapter(unitOfWork))
            {
                UserInfoWithOtherData model = adapter.UserInfoWithDetails(userId);
                model.Structures = adapter.GetStructures2(SessionHelper.WorkPlaceId).ToList();

                Session["IsuserActive"] = model.UserDetailsWithWorkplaces.UserStatus;
                ViewBag.IsEdit = true;
                return View("UserPanel", model);
            }
        }

        [HttpPost]
        public JsonResult PostEditUser(UserDetailsWithWorkplaces model)
        {
            bool? prevStatus = Session["IsuserActive"] as bool?;

            using (OrganizationStructureAdapter adapter = new OrganizationStructureAdapter(unitOfWork))
            {
                adapter.UpdateUser(model, prevStatus, out int result);
            }

            return Json(new { result = true });
        }

        [HttpGet]
        public ActionResult GetUserView(int userId)
        {
            if (userId < 1)
                return HttpNotFound();
            using (OrganizationStructureAdapter adapter = new OrganizationStructureAdapter(unitOfWork))
            {
                UserInfoViewModel model = adapter.UserInfo(userId);
                return PartialView("UserInfo", model);
            }
        }

        [HttpPost]
        public PartialViewResult GetPositionPartial(int positionIndex, int userId)
        {
            using (OrganizationStructureAdapter adapter = new OrganizationStructureAdapter(unitOfWork))
            {
                EditPositionPartialViewModel editPositionPartialViewModel = new EditPositionPartialViewModel
                {
                    DeptPositionViewModels = new List<DeptPositionViewModel>(),
                    DeptViewModels = new List<DeptViewModel>(),
                    OrgViewModels = adapter.GetOrgViewModels(),
                    PositionIndex = positionIndex,
                    Roles = adapter.GetRoleViewModels(),
                    UserWorkPlace = new UserWorkPlace
                    {
                        Roles = new List<RoleViewModel>(),
                    },
                    SectosViewModels = new List<DeptViewModel>(),
                    Structures = adapter.GetStructures2(SessionHelper.WorkPlaceId).ToList()
                };

                return PartialView("PositionViewPartial", editPositionPartialViewModel);
            }
        }

        [HttpPost]
        public JsonResult GetDepatmentsByOrganisationId(int orgId)
        {
            using (OrganizationStructureAdapter adapter = new OrganizationStructureAdapter(unitOfWork))
            {
                List<DeptViewModel> departments = adapter.GetDepartmentsByOrgId(orgId);

                return Json(departments.Select(x => new { x.Id, x.Name }));
            }
        }

        [HttpPost]
        public JsonResult GetDepatmentPositionsByDeprtmentId(int deptId)
        {
            using (OrganizationStructureAdapter adapter = new OrganizationStructureAdapter(unitOfWork))
            {
                List<DeptPositionViewModel> departments = adapter.GetPositionsByDeptId(deptId);

                return Json(departments.Select(x => new { x.Id, x.Name }));
            }
        }

        [HttpPost]
        public JsonResult GetSectorsByDeptId(int deptId)
        {
            using (OrganizationStructureAdapter adapter = new OrganizationStructureAdapter(unitOfWork))
            {
                List<DeptPositionViewModel> deptPositionViewModels = adapter.GetPositionsByDeptId(deptId);
                List<DeptViewModel> departments = adapter.GetSectorsByDeptId(deptId);
                return Json(new
                {
                    departments = departments.Select(x => new { x.Id, x.Name }),
                    positions = deptPositionViewModels.Select(x => new { x.Id, x.Name })
                });
            }
        }

        [HttpPost]
        public JsonResult ResetUserPassword(int userId)
        {
            using (OrganizationStructureAdapter adapter = new OrganizationStructureAdapter(unitOfWork))
            {
                bool result = adapter.ResetUserPassword(userId);
                return Json(result);
            }
        }

        public ActionResult OrganisationsIndex()
        {
            using (OrganizationStructureAdapter adapter = new OrganizationStructureAdapter(unitOfWork))
            {
                List<Structure> structures = adapter.GetStructures2(SessionHelper.WorkPlaceId).ToList();
                return View(structures);
            }
        }

        [HttpPost]
        public JsonResult GetOrganisations(int pageIndex = 1, int pageSize = 20)
        {
            using (OrganizationStructureAdapter adapter = new OrganizationStructureAdapter(unitOfWork))
            {
                return Json(adapter.GetOrganisationsViewModels(pageIndex, pageSize, Request.ToSqlParams()));
            }
        }

        [HttpPost]
        public JsonResult CreateOrganisation(CreateOrgModel model)
        {
            using (OrganizationStructureAdapter adapter = new OrganizationStructureAdapter(unitOfWork))
            {
                bool result = adapter.CreateOrganisation(model);
            }

            return Json(true);
        }




        public ActionResult EnterUserLimit(int? orgId)
        {
            using (OrganizationStructureAdapter adapter = new OrganizationStructureAdapter(unitOfWork))
            {
                return AuthorityTransferIndex();
            }
        }



        [HttpPost]
        public JsonResult GetOrganisationById(int orgId)
        {
            DC_ORGANIZATION org = unitOfWork.GetRepository<DC_ORGANIZATION>().GetById(orgId);

            return Json(new { org.OrganizationId, org.OrganizationTopId, org.OrganizationShortname });
        }

        [HttpPost]
        public JsonResult EditOrganisation(CreateOrgModel model)
        {

            try
            {

                UserLimitOrganizations userLimitOrganizations = new UserLimitOrganizations
                {
                    WorkplaceId = SessionHelper.WorkPlaceId,
                    OrganizationId = model.OrgId,
                    OperationNote = model.UserLimitComment,
                    UpdatedDate = DateTime.Now.ToString("G")

                };
                unitOfWork.GetRepository<UserLimitOrganizations>().Add(userLimitOrganizations);
                unitOfWork.SaveChanges();

                DC_ORGANIZATION org = unitOfWork.GetRepository<DC_ORGANIZATION>().GetById(model.OrgId);
                if (org != null)
                {
                    org.OrganizationShortname = model.OrgName;
                    org.OrganizationTopId = model.TopOrgId;
                    org.OrganizationIndex = model.OrgIndex;
                    org.MaxUserCount = model.MaxUserCount;
                    org.UserLimitComment = model.UserLimitComment;
                    unitOfWork.GetRepository<DC_ORGANIZATION>().Update(org);
                    unitOfWork.SaveChanges();
                    return Json(true);
                }

                return Json(false);
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                throw;
            }

        }

        [HttpPost]
        public JsonResult RemoveOrganisationById(int orgId)
        {
            ViewBag.IsEdit = false;

            DC_ORGANIZATION org = unitOfWork.GetRepository<DC_ORGANIZATION>().GetById(orgId);
            if (org != null)
            {
                org.OrganizationStatus = false;
                unitOfWork.GetRepository<DC_ORGANIZATION>().Update(org);
                unitOfWork.SaveChanges();
                return Json(true);
            }

            return Json(false);
        }

        [HttpPost]
        public JsonResult GetDepartments(int pageIndex = 1, int pageSize = 20)
        {
            using (OrganizationStructureAdapter adapter = new OrganizationStructureAdapter(unitOfWork))
            {
                return Json(adapter.GetDepartmentsViewModels(pageIndex, pageSize, Request.ToSqlParams()));
            }
        }

        public ActionResult DepartmentIndex()
        {
            List<DC_DEPARTMENT> departments = unitOfWork.GetRepository<DC_DEPARTMENT>()
                .GetAll(x => x.DepartmentStatus == true).ToList();
            List<DC_ORGANIZATION> organisations = unitOfWork.GetRepository<DC_ORGANIZATION>()
                .GetAll(x => x.OrganizationTopId == null && x.OrganizationStatus == true).ToList();
            List<DC_DEPARTMENTTYPE> deptTypes = unitOfWork.GetRepository<DC_DEPARTMENTTYPE>()
                .GetAll(x => x.TypeStatus == true).ToList();

            PassDepartmentViewModel passDepartmentViewModel = new PassDepartmentViewModel
            {
                Departments = departments,
                Organisations = organisations,
                DeptTypes = deptTypes
            };
            return View(passDepartmentViewModel);
        }

        [HttpPost]
        public JsonResult GetDepartmentPartial(int deptId)
        {
            try
            {
                List<DC_DEPARTMENT> departments = unitOfWork.GetRepository<DC_DEPARTMENT>()
                    .GetAll(x => x.DepartmentStatus == true).ToList();
                List<DC_ORGANIZATION> organisations = unitOfWork.GetRepository<DC_ORGANIZATION>()
                    .GetAll(x => x.OrganizationStatus == true).ToList();
                List<DC_DEPARTMENTTYPE> deptTypes = unitOfWork.GetRepository<DC_DEPARTMENTTYPE>()
                    .GetAll(x => x.TypeStatus == true).ToList();

                PassDepartmentViewModel passDepartmentViewModel = new PassDepartmentViewModel
                {
                    Department = new DC_DEPARTMENT(),
                    Departments = departments,
                    Organisations = organisations,
                    DeptTypes = deptTypes
                };

                DC_DEPARTMENT dept = unitOfWork.GetRepository<DC_DEPARTMENT>()
                    .Get(x => x.DepartmentStatus == true && x.DepartmentId == deptId);

                if (dept != null)
                {
                    passDepartmentViewModel.Department = dept;
                    string partialViewAsString = Utils.RenderViewPaginationToString(ControllerContext,
                        "~/Areas/AdminPanel/Views/OrganizationStructure/GetDepartmentPartial.cshtml",
                        passDepartmentViewModel, null, true);

                    return Json(new { result = true, partialViewAsString });
                }
                else
                {
                    string partialViewAsString = Utils.RenderViewPaginationToString(ControllerContext,
                        "~/Areas/AdminPanel/Views/OrganizationStructure/GetDepartmentPartial.cshtml",
                        passDepartmentViewModel, null, true);
                    return Json(new { result = true, partialViewAsString });
                }
            }
            catch (Exception e)
            {
                return Json(new { result = false });
            }
        }

        [HttpPost]
        public JsonResult CreateDepartment(CreateDeptModel model)
        {
            DC_DEPARTMENT indexesDcDepartmentPosition = unitOfWork.GetRepository<DC_DEPARTMENT>()
                       .Get(l => l.DepartmentName == model.DeptName && l.DepartmentOrganization == model.TopOrgId);
            if (indexesDcDepartmentPosition != null)
            {
                Thrower.Ex("Bu adda departament var");
            }
            if (ModelState.IsValid)
            {
                DC_DEPARTMENT dept = new DC_DEPARTMENT
                {
                    DepartmentName = model.DeptName,
                    DepartmentTypeId = model.DeptTypeId,
                    DepartmentTopId = model.TopDeptId != 0 ? model.TopDeptId : (int?)null,
                    DepartmentOrganization = model.TopOrgId,
                    DepartmentIndex = model.DeptIndex,
                    DepartmentStatus = true
                };
                unitOfWork.GetRepository<DC_DEPARTMENT>().Add(dept);
                unitOfWork.SaveChanges();
                return Json(true);
            }
            else
            {
                return Json(false);
            }
        }

        [HttpPost]
        public JsonResult EditDepartment(CreateDeptModel model)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    DC_DEPARTMENT dept = unitOfWork.GetRepository<DC_DEPARTMENT>()
                        .Get(x => x.DepartmentStatus == true && x.DepartmentId == model.DeptId);

                    if (dept != null)
                    {
                        dept.DepartmentName = model.DeptName;
                        dept.DepartmentTypeId = model.DeptTypeId;
                        dept.DepartmentTopId = model.TopDeptId != 0 ? model.TopDeptId : /*(int?)*/null;
                        dept.DepartmentOrganization = model.TopOrgId;
                        dept.DepartmentIndex = model.DeptIndex;

                        unitOfWork.GetRepository<DC_DEPARTMENT>().Update(dept);
                        unitOfWork.SaveChanges();
                        return Json(true);
                    }
                }
            }
            catch (Exception e)
            {
            }

            return Json(false);
        }

        [HttpPost]
        public JsonResult RemoveDepartmentById(int deptId)
        {
            DC_DEPARTMENT dept = unitOfWork.GetRepository<DC_DEPARTMENT>().GetById(deptId);
            if (dept != null)
            {
                dept.DepartmentStatus = false;
                unitOfWork.GetRepository<DC_DEPARTMENT>().Update(dept);
                unitOfWork.SaveChanges();
                return Json(true);
            }

            return Json(false);
        }

        [HttpPost]
        public JsonResult GetDepartmentById(int orgId)
        {
            ViewBag.IsEdit = false;

            DC_DEPARTMENT dept = unitOfWork.GetRepository<DC_DEPARTMENT>().GetById(orgId);

            return Json(new { dept.DepartmentId, dept.DepartmentTopId, dept.DepartmentOrganization });
        }

        [HttpPost]
        public JsonResult GetOrganisationPartial(int orgId)
        {
            try
            {
                List<DC_ORGANIZATION> organisations = unitOfWork.GetRepository<DC_ORGANIZATION>()
                    .GetAll(x => x.OrganizationStatus == true).ToList();

                PassOrganisationViewModel passOrganisationViewModel = new PassOrganisationViewModel
                {
                    organisation = new DC_ORGANIZATION(),
                    Organisations = organisations,
                };

                DC_ORGANIZATION org = unitOfWork.GetRepository<DC_ORGANIZATION>()
                    .Get(x => x.OrganizationStatus == true && x.OrganizationId == orgId);

                if (org != null)
                {
                    passOrganisationViewModel.organisation = org;
                }

                string partialViewAsString = Utils.RenderViewPaginationToString(ControllerContext,
                    "~/Areas/AdminPanel/Views/OrganizationStructure/GetOrganisationPartial.cshtml",
                    passOrganisationViewModel, null, true);
                return Json(new { result = true, partialViewAsString });
            }
            catch (Exception e)
            {
                return Json(new { result = false });
            }
        }

        [HttpGet]
        public ActionResult RoleIndex()
        {
            return View();
        }

        [HttpPost]
        public JsonResult GetRoles(int pageIndex = 1, int pageSize = 20)
        {
            using (OrganizationStructureAdapter adapter = new OrganizationStructureAdapter(unitOfWork))
            {
                return Json(adapter.GetRoleViewModels(pageIndex, pageSize, Request.ToSqlParams()));
            }
        }

        [HttpGet]
        public ActionResult GetCreateRole()
        {
            using (OrganizationStructureAdapter adapter = new OrganizationStructureAdapter(unitOfWork))
            {
                RoleDetailsViewModel model = adapter.RoleInfoWithDetails(0);
                return View("RolePanel", model);
            }
        }

        [HttpGet]
        public ActionResult GetEditRole(int roleId)
        {
            using (OrganizationStructureAdapter adapter = new OrganizationStructureAdapter(unitOfWork))
            {
                RoleDetailsViewModel model = adapter.RoleInfoWithDetails(roleId);
                model.IsEdit = true;
                return View("RolePanel", model);
            }
        }

        [HttpPost]
        public JsonResult PostEditRole(CreateRoleModel model)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    using (OrganizationStructureAdapter adapter = new OrganizationStructureAdapter(unitOfWork))
                    {
                        adapter.EditRole(model);
                        return Json(true);
                    }
                }
            }
            catch (Exception e)
            {
            }

            IEnumerable<ModelError> allErrors = ModelState.Values.SelectMany(v => v.Errors).ToList();

            return Json(false);
        }

        [HttpPost]
        public JsonResult PostCreateRole(CreateRoleModel model)
        {
            try
            {
                using (OrganizationStructureAdapter adapter = new OrganizationStructureAdapter(unitOfWork))
                {
                    adapter.CreateRole(model);
                    return Json(true);
                }
            }
            catch (Exception e)
            {
            }

            IEnumerable<ModelError> allErrors = ModelState.Values.SelectMany(v => v.Errors).ToList();

            return Json(false);
        }

        //Remove role by id in grid  (Below)
        public JsonResult RemoveRoleById(int roleId)
        {
            DC_ROLE rOLE = unitOfWork.GetRepository<DC_ROLE>().GetById(roleId);
            if (rOLE != null)
            {
                rOLE.RoleStatus = false;
                unitOfWork.GetRepository<DC_ROLE>().Update(rOLE);
                unitOfWork.SaveChanges();
                return Json(true);
            }

            return Json(false);
        }

        [HttpGet]
        public ActionResult PositionIndex()
        {
            return View();
        }

        [HttpPost]
        public JsonResult GetPositions(int pageIndex = 1, int pageSize = 20)
        {
            using (OrganizationStructureAdapter adapter = new OrganizationStructureAdapter(unitOfWork))
            {
                return Json(adapter.GetPositionViewModels(SessionHelper.WorkPlaceId, pageIndex, pageSize, Request.ToSqlParams()));
            }
        }

        [HttpGet]
        public ActionResult GetEditPosition(int posId)
        {
            if (posId < 1)
                return HttpNotFound();
            using (OrganizationStructureAdapter adapter = new OrganizationStructureAdapter(unitOfWork))
            {
                PositionInfo model = adapter.GetPositionInfo(posId, SessionHelper.OrganizationId, SessionHelper.Roles.Any(x => x.RoleId == 230));
                model.IsEdit = true;
                return View("PositionPanel", model);
            }
        }

        [HttpPost]
        public JsonResult EditPosition(PositionInfo model)
        {
            if (ModelState.IsValid)
            {
                var positionRepo = unitOfWork.GetRepository<DC_DEPARTMENT_POSITION>();

                DC_DEPARTMENT_POSITION position = positionRepo.Get(x =>
                    x.DepartmentPositionStatus == true && x.DepartmentPositionId == model.DepartmentPositionId);

                if (position != null)
                {
                    position.DepartmentPositionName = model.DepartmentPositionName;
                    position.DepartmentPositionIndex = model.DepartmentPositionIndex;
                    position.DepartmentId = model.DepartmentId;
                    position.PositionGroupId = model.PositionGroupId;
                    positionRepo.Update(position);
                    unitOfWork.SaveChanges();
                    return Json(true);
                }
            }
            return Json(false);
        }

        [HttpPost]
        public JsonResult CreatePosition(PositionInfo model)
        {
            DC_DEPARTMENT_POSITION position;
            //if (model.DepartmentPositionIndex != null)
            //{
            //    DC_DEPARTMENT_POSITION indexesDcDepartmentPosition = unitOfWork.GetRepository<DC_DEPARTMENT_POSITION>()
            //        .Get(l => l.DepartmentPositionIndex == model.DepartmentPositionIndex);

            //    if (indexesDcDepartmentPosition != null)
            //    {
            //        Thrower.Ex("Bu adda index var");
            //    }
            //}
            if (ModelState.IsValid)
            {
                position = new DC_DEPARTMENT_POSITION
                {
                    DepartmentId = model.DepartmentId,
                    DepartmentPositionIndex = model.DepartmentPositionIndex,
                    DepartmentPositionName = model.DepartmentPositionName,
                    PositionGroupId = model.PositionGroupId,
                    DepartmentPositionStatus = true
                };
                unitOfWork.GetRepository<DC_DEPARTMENT_POSITION>().Add(position);
                unitOfWork.SaveChanges();
                return Json(true);
            }
            return Json(false);
        }

        [HttpGet]
        public ActionResult GetCreatePosition()
        {
            using (OrganizationStructureAdapter adapter = new OrganizationStructureAdapter(unitOfWork))
            {
                var isAdmin = SessionHelper.Roles.Any(x => x.RoleId == 230);
                PositionInfo model = adapter.GetPositionInfo(0, SessionHelper.OrganizationId, isAdmin);
                return View("PositionPanel", model);
            }
        }

        [HttpPost]
        public JsonResult RemovePositionById(int posId)
        {
            DC_DEPARTMENT_POSITION position = unitOfWork.GetRepository<DC_DEPARTMENT_POSITION>().GetById(posId);
            if (position != null)
            {
                position.DepartmentPositionStatus = false;
                unitOfWork.GetRepository<DC_DEPARTMENT_POSITION>().Update(position);
                unitOfWork.SaveChanges();
                return Json(true);
            }
            return Json(false);
        }

        [HttpPost]
        public JsonResult CheckRoleExists(int roleId, string RoleName)
        {
            DC_ROLE role = unitOfWork.GetRepository<DC_ROLE>().Get(x => x.RoleName.ToLower() == RoleName.ToLower());
            if (role != null && role.RoleId == roleId)
                return Json(true);
            else if (role != null && role.RoleId != roleId)
            {
                return Json(false);
            }
            int a = 5;
            return Json(true);
        }

        [HttpPost]
        public JsonResult UpdateWorkplaceStatus(int workplaceId)
        {
            using (OrganizationStructureAdapter adapter = new OrganizationStructureAdapter(unitOfWork))
            {
                return Json(adapter.UpdateWorkplaceStatus(workplaceId));
            }
        }

        [HttpPost]
        public JsonResult ChangeUserStatus(int userId)
        {
            try
            {
                var user = unitOfWork.GetRepository<DC_USER>().Get(dcUser => dcUser.UserId == userId);

                if (user != null)
                {
                    bool status = user.UserStatus;

                    if (status)
                    {
                        user.UserStatus = false;
                    }
                    else
                    {
                        user.UserStatus = true;
                    }
                    unitOfWork.GetRepository<DC_USER>().Update(user);
                    unitOfWork.SaveChanges();

                    return Json(true);
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            return Json(false);
        }

        [HttpGet]
        public ActionResult TopicTypeIndex()
        {
            return View();
        }

        [HttpGet]
        public ActionResult TopicIndex()
        {
            return View();
        }

        public JsonResult RemoveTopicTypeById(int tTypeId)
        {
            DOC_TOPIC_TYPE topicType = unitOfWork.GetRepository<DOC_TOPIC_TYPE>().GetById(tTypeId);
            if (topicType != null)
            {
                topicType.TopicTypeStatus = false;
                unitOfWork.GetRepository<DOC_TOPIC_TYPE>().Update(topicType);
                unitOfWork.SaveChanges();
                return Json(true);
            }

            return Json(false);
        }

        [HttpPost]
        public JsonResult GetTopicType(int pageIndex = 1, int pageSize = 20)
        {
            using (OrganizationStructureAdapter adapter = new OrganizationStructureAdapter(unitOfWork))
            {
                var model = adapter.GetTopicTypeInfos(SessionHelper.WorkPlaceId, pageIndex, pageSize, Request.ToSqlParams());

                return Json(model);
            }
        }

        [HttpPost]
        public JsonResult GetTopic(int pageIndex = 1, int pageSize = 20)
        {
            using (OrganizationStructureAdapter adapter = new OrganizationStructureAdapter(unitOfWork))
            {
                return Json(adapter.GetTopicInfos(SessionHelper.WorkPlaceId, pageIndex, pageSize, Request.ToSqlParams()));
            }
        }

        [HttpGet]
        public ActionResult GetEditTopicTypeById(int topicTypeId)
        {
            if (topicTypeId < 1)
                return HttpNotFound();
            using (OrganizationStructureAdapter adapter = new OrganizationStructureAdapter(unitOfWork))
            {
                var maxTopicTypeIndex = unitOfWork.GetRepository<DOC_TOPIC_TYPE>()
                    .GetAll().Max(x => x.TopicTypeOrderIndex);

                bool isAdmin = SessionHelper.Roles.Any(x => x.RoleId == 230);

                TopicTypeViewModel model = new TopicTypeViewModel
                {
                    IsEdit = true,
                    TopicTypeInfo = adapter.GetTopicTypeInfo(topicTypeId),
                    OrgViewModels = unitOfWork.GetRepository<DC_ORGANIZATION>()
                        .GetAll(o => o.OrganizationStatus && o.OrganizationId == (isAdmin ? o.OrganizationId : SessionHelper.OrganizationId))
                        .ToList()
                        .Select(o => new OrgViewModel
                        {
                            Id = o.OrganizationId,
                            Name = o.OrganizationName
                        }).ToList(),
                    LastInsertedIndex = maxTopicTypeIndex
                };
                return View("TopicTypePanel", model);
            }
        }

        [HttpPost]
        public JsonResult EditTopicType(TopicTypeInfo model)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    DOC_TOPIC_TYPE topicType = unitOfWork.GetRepository<DOC_TOPIC_TYPE>()
                        .Get(x => x.TopicTypeId == model.TopicTypeId);


                    if (topicType != null)
                    {
                        topicType.TopicTypeName = model.TopicTypeName;
                        topicType.TopicTypeOrderIndex = model.TopicTypeOrderIndex;
                        topicType.TopicTypeStatus = true;
                        topicType.OrganizationId = model.OrganizationId;
                        topicType.CitizenTopic = model.CitizenTopic;
                        topicType.OrgTopic = model.OrgTopic;
                        topicType.ColleagueTopic = model.ColleagueTopic;

                        unitOfWork.GetRepository<DOC_TOPIC_TYPE>().Update(topicType);
                        unitOfWork.SaveChanges();
                        return Json(true);
                    }
                }
            }
            catch (Exception e)
            {
            }

            return Json(false);
        }

        public ActionResult GetCreateTopicType()
        {
            bool isAdmin = SessionHelper.Roles.Any(x => x.RoleId == 230);

            List<OrgViewModel> orgs = unitOfWork.GetRepository<DC_ORGANIZATION>()
                .GetAll(o => o.OrganizationStatus && o.OrganizationId == (isAdmin ? o.OrganizationId : SessionHelper.OrganizationId))
                .ToList()
                .Select(o => new OrgViewModel
                {
                    Id = o.OrganizationId,
                    Name = o.OrganizationName
                }).ToList();

            var maxTopicTypeIndex = unitOfWork.GetRepository<DOC_TOPIC_TYPE>()
                .GetAll().Max(x => x.TopicTypeOrderIndex);

            TopicTypeViewModel model = new TopicTypeViewModel
            {
                IsEdit = false,
                TopicTypeInfo = new TopicTypeInfo(),
                OrgViewModels = orgs,
                LastInsertedIndex = maxTopicTypeIndex
            };
            return View("TopicTypePanel", model);
        }

        [HttpPost]
        public JsonResult CreateTopicType(TopicTypeInfo model)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    DOC_TOPIC_TYPE dOC_TOPIC_TYPE = new DOC_TOPIC_TYPE
                    {
                        TopicTypeName = model.TopicTypeName,
                        TopicTypeOrderIndex = model.TopicTypeOrderIndex,
                        OrganizationId = model.OrganizationId,
                        TopicTypeStatus = true,
                        CitizenTopic = model.CitizenTopic,
                        OrgTopic = model.OrgTopic,
                        ColleagueTopic = model.ColleagueTopic
                    };

                    unitOfWork.GetRepository<DOC_TOPIC_TYPE>().Add(dOC_TOPIC_TYPE);
                    unitOfWork.SaveChanges();
                    return Json(true);
                }
            }
            catch (Exception e)
            {
            }

            return Json(false);
        }

        public JsonResult RemoveTopicById(int tTypeId)
        {
            DOC_TOPIC dOC_TOPIC = unitOfWork.GetRepository<DOC_TOPIC>().GetById(tTypeId);
            if (dOC_TOPIC != null)
            {
                dOC_TOPIC.TopicStatus = false;
                unitOfWork.GetRepository<DOC_TOPIC>().Update(dOC_TOPIC);
                unitOfWork.SaveChanges();
                return Json(true);
            }

            return Json(false);
        }

        [HttpGet]
        public ActionResult GetEditTopicById(int topicId)
        {
            if (topicId < 1)
                return HttpNotFound();
            using (OrganizationStructureAdapter adapter = new OrganizationStructureAdapter(unitOfWork))
            {
                bool isAdmin = SessionHelper.Roles.Any(x => x.RoleId == 230);
                TopicViewModel model = new TopicViewModel
                {
                    TopicInfo = adapter.GetTopicInfo(topicId),
                    IsEdit = true,
                    TopicTypeInfos = unitOfWork
                        .GetRepository<DOC_TOPIC_TYPE>()
                        .GetAll(t => t.TopicTypeStatus && t.OrganizationId == (isAdmin ? t.OrganizationId : SessionHelper.OrganizationId)).ToList()
                        .Select(t => new TopicTypeInfo
                        {
                            TopicTypeId = t.TopicTypeId,
                            TopicTypeName = t.TopicTypeName
                        }).ToList()
                };
                return View("TopicPanel", model);
            }
        }

        //--------------------------------------------------//
        [HttpPost]
        public JsonResult EditTopic(TopicInfo model)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    DOC_TOPIC topic = unitOfWork.GetRepository<DOC_TOPIC>().Get(x => x.TopicId == model.TopicId);

                    if (topic != null)
                    {
                        topic.TopicTypeId = model.TopicTypeId;
                        topic.TopicName = model.TopicName;
                        topic.TopicIndex = model.TopicIndex;
                        topic.TopicStatus = true;

                        unitOfWork.GetRepository<DOC_TOPIC>().Update(topic);
                        unitOfWork.SaveChanges();
                        return Json(true);
                    }
                }
            }
            catch (Exception e)
            {
            }

            return Json(false);
        }

        public ActionResult GetCreateTopic()
        {
            var types = unitOfWork
               .GetRepository<DOC_TOPIC_TYPE>();

            var organisations = unitOfWork
                .GetRepository<DC_ORGANIZATION>();

            bool isAdmin = SessionHelper.Roles.Any(x => x.RoleId == 230);

            var selected = (from type in types.GetAll().Where(x => x.TopicTypeStatus)
                            join organ in organisations.GetAll().Where(x => x.OrganizationStatus && x.OrganizationId == (isAdmin ? x.OrganizationId : SessionHelper.OrganizationId)) on type.OrganizationId equals organ.OrganizationId
                            select new TopicTypeInfo
                            {
                                TopicTypeName = type.TopicTypeName + " ( " + organ.OrganizationShortname + " )",
                                TopicTypeId = type.TopicTypeId
                            }).ToList();

            TopicViewModel model = new TopicViewModel
            {
                TopicInfo = new TopicInfo(),
                IsEdit = false,
                TopicTypeInfos = selected
            };
            return View("TopicPanel", model);
        }

        //--------------------------------------------------//

        [HttpPost]
        public JsonResult CreateTopic(TopicInfo model)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    DOC_TOPIC dOC_TOPIC = new DOC_TOPIC
                    {
                        TopicTypeId = model.TopicTypeId,
                        TopicName = model.TopicName,
                        TopicIndex = model.TopicIndex,
                        TopicOrderIndex = model.TopicIndex,
                        TopicStatus = true
                    };
                    unitOfWork.GetRepository<DOC_TOPIC>().Add(dOC_TOPIC);
                    unitOfWork.SaveChanges();
                    return Json(true);
                }
            }
            catch (Exception e)
            {
            }

            return Json(false);
        }

        [HttpGet]
        public ActionResult OrganisationForRenderingIndex()
        {
            return View();
        }

        [HttpPost]
        public JsonResult GetOrganisationsForRendering(int pageIndex = 1, int pageSize = 20)
        {
            using (OrganizationStructureAdapter adapter = new OrganizationStructureAdapter(unitOfWork))
            {
                return Json(adapter.GetRelOrgInfos(pageIndex, pageSize, Request.ToSqlParams()));
            }
        }

        [HttpPost]
        public JsonResult RemoveOrgsForRendering(int orgForRendering)
        {
            DC_ORGANIZATION organisations =
                unitOfWork.GetRepository<DC_ORGANIZATION>().Get(x => x.OrganizationId == orgForRendering);
            if (organisations != null)
            {
                //organisations.IsDeleted = 1;
                organisations.IsAuthorOrganization = false;
                unitOfWork.GetRepository<DC_ORGANIZATION>().Update(organisations);
                unitOfWork.SaveChanges();
                return Json(true);
            }

            return Json(false);
        }

        [HttpGet]
        public ActionResult GetEditOrganisationsForRendering(int orgForRendering)
        {
            if (orgForRendering < 1)
                return HttpNotFound();
            using (OrganizationStructureAdapter adapter = new OrganizationStructureAdapter(unitOfWork))
            {
                ViewBag.PageIndexForEdit = TempData["data"];
                RenderOrganisations model = adapter.GetOrganisationsForRenderingInfo(orgForRendering);
                return PartialView("OrganisationForRenderingPanel", model);
            }
        }

        [HttpPost]
        public JsonResult EditOrganisationsForRendering(RenderOrganisations model)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    DC_ORGANIZATION dcOrganization =
                        unitOfWork.GetRepository<DC_ORGANIZATION>().Get(x => x.OrganizationId == model.Id);

                    if (dcOrganization != null)
                    {
                        dcOrganization.OrganizationId = model.Id;
                        dcOrganization.OrganizationShortname = model.OrganisationShortname;
                        dcOrganization.OrganizationIndex = model.OrderIndex;
                        unitOfWork.GetRepository<DC_ORGANIZATION>().Update(dcOrganization);
                        unitOfWork.SaveChanges();
                        return Json(true);
                    }
                }
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

            return Json(false);
        }

        public ActionResult GetCreateOrganisationsForRendering()
        {
            RenderOrganisations model = new RenderOrganisations()
            {
                IsEdit = 0
            };

            return PartialView("OrganisationForRenderingPanel", model);
        }

        [HttpPost]
        public JsonResult CreateOrganisationsForRendering(OrgForRenderingCreateViewModel model)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    DC_ORGANIZATION dcOrganization = new DC_ORGANIZATION()
                    {
                        OrganizationName = model.OrganisationShortname,
                        OrganizationShortname = model.OrganisationShortname,
                        OrganizationIndex = model.OrderIndex,
                        OrganizationStatus = false,
                        IsDeleted = 0
                    };
                    unitOfWork.GetRepository<DC_ORGANIZATION>().Add(dcOrganization);
                    unitOfWork.SaveChanges();
                    return Json(true);
                }
            }
            catch (Exception e)
            {
            }
            return Json(false);
        }

        [HttpGet]
        public JsonResult GetDepartmentWhileCreate(int orgId)
        {
            using (OrganizationStructureAdapter adapter = new OrganizationStructureAdapter(unitOfWork))
            {
                var model = adapter.GetDepartmentsByOrgId2(orgId);
                return Json(model, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpGet]
        public ActionResult AuthorityTransferIndex()
        {
            return View();
        }

        [HttpPost]
        public JsonResult GetAuthorityTransferInfo(int pageIndex = 1, int pageSize = 20)
        {
            using (OrganizationStructureAdapter adapter = new OrganizationStructureAdapter(unitOfWork))
            {
                return Json(adapter.GetauthorityTransferInfos(SessionHelper.WorkPlaceId, pageIndex, pageSize, Request.ToSqlParams()));
            }
        }

        [HttpGet]
        public ActionResult GetCreateAuthorityTransfer()
        {
            using (OrganizationStructureAdapter adapter = new OrganizationStructureAdapter(unitOfWork))
            {
                IEnumerable<ChooseModel> selectList = adapter.GetChooseModelAuthority(SessionHelper.WorkPlaceId);

                var authorityTransfer = new PassAuthorityTransfer
                {
                    IsEdit = false,
                    TransferredFromPersons = selectList.Where(x => x.FormTypeId == 1).ToList(),
                    TransferredToPersons = selectList.Where(x => x.FormTypeId == 1).ToList(),
                    TransferReasons = selectList.Where(x => x.FormTypeId == 2).ToList(),
                    Statuses = selectList.Where(l => l.FormTypeId == 3).ToList()
                };

                return View("AuthorityTransferPanel", authorityTransfer);
            }
        }

        [HttpPost]
        public JsonResult CreateTransferAutority(PassAuthorityTransfer model)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    AuthorityTransfer transferAuthority = new AuthorityTransfer
                    {
                        TransferredFromPerson = model.TransferredFromPerson,
                        TransferredToPerson = model.TransferredToPerson,
                        TransferredReason = model.TransferReason,
                        BeginDate = model.BeginDate,
                        EndDate = model.EndDate,
                        TransferNote = model.TransferNote,
                        AuthorityStatus = model.AuthorityStatus
                    };
                    unitOfWork.GetRepository<AuthorityTransfer>().Add(transferAuthority);
                    unitOfWork.SaveChanges();

                    if (transferAuthority.AuthorityStatus == 1)
                        AuthorityDocsTransfer(transferAuthority.AuthorityId);

                    return Json(true);
                }
            }
            catch (Exception e)
            {
            }

            return Json(false);
        }

        public JsonResult DisableAuthorityTransferById(int transferAuthorityId)
        {
            try
            {
                AuthorityTransfer authorityTransfer =
                    unitOfWork.GetRepository<AuthorityTransfer>().GetById(transferAuthorityId);
                if (authorityTransfer != null)
                {
                    authorityTransfer.AuthorityStatus = 0;
                    unitOfWork.GetRepository<AuthorityTransfer>().Update(authorityTransfer);
                    unitOfWork.SaveChanges();
                    return Json(true);
                }
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
            }

            return Json(false);
        }

        public JsonResult RemoveAuthorityTransferById(int transferAuthorityId)
        {
            try
            {
                AuthorityTransfer authorityTransfer =
                    unitOfWork.GetRepository<AuthorityTransfer>().GetById(transferAuthorityId);
                if (authorityTransfer != null)
                {
                    authorityTransfer.IsDeleted = 1;
                    authorityTransfer.AuthorityStatus = 0;
                    unitOfWork.GetRepository<AuthorityTransfer>().Update(authorityTransfer);
                    unitOfWork.SaveChanges();
                    AuthorityDocsTransfer(transferAuthorityId);

                    return Json(true);
                }
            }
            catch (Exception e)
            {
                throw;
            }

            return Json(false);
        }

        private void AuthorityDocsTransfer(int authorityId)
        {
            using (var adapter = new OrganizationStructureAdapter(unitOfWork))
                adapter.AuthorityDocsTransfer(authorityId);
        }

        [HttpGet]
        public ActionResult GetEditAuthorityById(int transferAuthorityId)
        {
            if (transferAuthorityId < 1)
                return HttpNotFound();

            using (OrganizationStructureAdapter adapter = new OrganizationStructureAdapter(unitOfWork))
            {
                PassAuthorityTransfer model = adapter.GetAuthorityTransferInfo(transferAuthorityId);
                IEnumerable<ChooseModel> selectList = adapter.GetChooseModelAuthority(SessionHelper.WorkPlaceId);

                model.TransferredFromPersons = selectList.Where(l => l.FormTypeId == 1).ToList();
                model.TransferredToPersons = selectList.Where(l => l.FormTypeId == 1).ToList();
                model.TransferReasons = selectList.Where(l => l.FormTypeId == 2).ToList();
                model.Statuses = selectList.Where(l => l.FormTypeId == 3).ToList();
                model.IsEdit = true;

                return View("AuthorityTransferPanel", model);
            }
        }

        [HttpPost]
        public JsonResult EditAuthorityTransfer(PassAuthorityTransfer model)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    AuthorityTransfer authorityTransfer =
                        unitOfWork.GetRepository<AuthorityTransfer>().Get(x => x.AuthorityId == model.AuthorityId);

                    var authorityStatus = authorityTransfer.AuthorityStatus;

                    if (authorityTransfer != null)
                    {
                        authorityTransfer.AuthorityId = model.AuthorityId;
                        authorityTransfer.TransferredFromPerson = Convert.ToInt32(model.TransferredFromPerson);
                        authorityTransfer.TransferredToPerson = model.TransferredToPerson;
                        authorityTransfer.TransferredReason = model.TransferReason;
                        authorityTransfer.BeginDate = model.BeginDate;
                        authorityTransfer.EndDate = model.EndDate;
                        authorityTransfer.AuthorityStatus = model.AuthorityStatus ?? 1;
                        authorityTransfer.TransferNote = model.TransferNote;

                        unitOfWork.GetRepository<AuthorityTransfer>().Update(authorityTransfer);
                        unitOfWork.SaveChanges();

                        if (authorityStatus != authorityTransfer.AuthorityStatus)
                            AuthorityDocsTransfer(authorityTransfer.AuthorityId);

                        return Json(true);
                    }
                }
            }
            catch (Exception e)
            {
            }

            return Json(false);
        }

        /*Sənədin redaktəyə açılması/bağlanması*/

        [HttpGet]
        public ActionResult EditDocumentIndex()
        {
            using (OrganizationStructureAdapter adapter = new OrganizationStructureAdapter(unitOfWork))
            {

                List<ChooseModel> users = adapter.GetChooseModel(SessionHelper.WorkPlaceId);


                EditDocumentViewModel passDataToIndexView = new EditDocumentViewModel
                {
                    PersonsList = users
                };


                return View(passDataToIndexView);
            }

        }

        [HttpGet]
        public JsonResult GetEditDocumentIndexGrid(string DocEnterNo, string DocDocNo, int pageIndex = 1, int pageSize = 20)
        {
            using (OrganizationStructureAdapter adapter = new OrganizationStructureAdapter(unitOfWork))
            {
                var model = adapter.GetEditDocInfo(DocEnterNo, DocDocNo, pageIndex, pageSize, SessionHelper.WorkPlaceId);
                return Json(model, JsonRequestBehavior.AllowGet);
            }
        }

        [HttpPost]
        public JsonResult OpenCloseDocument(int? executorId, int? docId, int? workplaceId)
        {
            try
            {
                using (OrganizationStructureAdapter adapter = new OrganizationStructureAdapter(unitOfWork))
                {
                    return Json(adapter.EditDocumentOpenClose(executorId, docId, workplaceId));
                }
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        [HttpPost]
        public JsonResult OpenCloseSpecialPersons(string docEnterNo, int? workplaceId)
        {
            try
            {
                using (OrganizationStructureAdapter adapter = new OrganizationStructureAdapter(unitOfWork))
                {
                    return Json(adapter.EditDocumentExceptionCase(docEnterNo, workplaceId));
                }
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
            return Json(false);
        }

        [HttpPost]
        public JsonResult CloseDocumentReadStatus(int executorId, int docId, int workplaceId)
        {
            try
            {
                using (OrganizationStructureAdapter adapter = new OrganizationStructureAdapter(unitOfWork))
                {
                    return Json(adapter.CloseReadStatus(executorId, docId, workplaceId));
                }
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
            return Json(false);
        }



        [HttpPost]
        public JsonResult RedirectToAnyPerson(int? executorId, int? workplaceId, int? redirectedPerson)
        {
            try
            {
                using (OrganizationStructureAdapter adapter = new OrganizationStructureAdapter(unitOfWork))
                {
                    return Json(adapter.RedirectToAnyPerson(executorId, workplaceId, redirectedPerson));
                }
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
            return Json(false);
        }


        [HttpPost]
        public JsonResult PassVizaByDocId(int? docId, int? executorId, int? workplaceId)
        {
            try
            {
                using (OrganizationStructureAdapter adapter = new OrganizationStructureAdapter(unitOfWork))
                {
                    return Json(adapter.PassVizaFromPerson(docId, executorId, workplaceId));
                }
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
            return Json(false);
        }

        public ActionResult TransferUserProfileIndex()
        {
            using (OrganizationStructureAdapter adapter = new OrganizationStructureAdapter(unitOfWork))
            {
                List<ChooseModel> selectList = adapter.GetChooseModelAuthority(SessionHelper.WorkPlaceId);

                TransferUserProfileViewModel modelList = new TransferUserProfileViewModel()
                {
                    Name = selectList.Where(x => x.FormTypeId == 1).ToList()
                };
                return View("TransferUserProfileIndex", modelList);
            }

        }


        public ActionResult UserLimitationLogs()
        {
            using (OrganizationStructureAdapter adapter = new OrganizationStructureAdapter(unitOfWork))
            {
                List<UserLimitationLogs> modelList = adapter.UserLimitationLogs();

                return View(modelList);
            }

        }


        [HttpPost]
        public JsonResult ChangeWorkplaceDocs(int? oldWorkplaceId, int? newWorkplaceId)
        {
            try
            {
                using (OrganizationStructureAdapter adapter = new OrganizationStructureAdapter(unitOfWork))
                {
                    return Json(adapter.ChangeWorkplaceDocs(oldWorkplaceId, newWorkplaceId));
                }
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);

            }
            return Json(false);
        }


    }
}