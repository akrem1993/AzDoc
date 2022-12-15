using Admin.Common.Enums;
using Admin.Model.EntityModel;
using Admin.Model.FormModel;
using Admin.Model.ViewModel;
using Admin.Model.ViewModel.AuthorityRelatedModel;
using Admin.Model.ViewModel.EditDocument;
using Admin.Model.ViewModel.PositionRelatedModels;
using Admin.Model.ViewModel.RoleRelatedModels;
using BLL.BaseAdapter;
using BLL.Models.Document;
using CustomHelpers;
using DMSModel;
using Model.DB_Tables;
using Newtonsoft.Json;
using Repository.Extensions;
using Repository.Infrastructure;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;


namespace Admin.Adapters
{
    public class OrganizationStructureAdapter : AdapterBase
    {
        public OrganizationStructureAdapter(IUnitOfWork unitOfWork) : base(unitOfWork)
        {
        }

        public GenericGridViewModel<UserGridModel> GetUserViewModels(int workplaceId, int? formType, int? pageIndex, int pageSize,
            int structId, int structType, List<SqlParameter> searchParams)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@workplaceId", workplaceId)
                    .Add("@formType", formType)
                    .Add("@pageIndex", pageIndex)
                    .Add("@pageSize", pageSize)
                    .Add("@structId", structId)
                    .Add("@structType", structType)
                    .Add("@totalCount", 0, ParameterDirection.Output);
                parameters.AddRange(searchParams);
                var data = UnitOfWork.ExecuteProcedure<UserGridModel>("[admin].[GetUser]", parameters).ToList();
                var TotalCount1 = Convert.ToInt32(parameters.First(p => p.ParameterName == "@totalCount").Value);
                return new GenericGridViewModel<UserGridModel>
                {
                    TotalCount = Convert.ToInt32(parameters.First(p => p.ParameterName == "@totalCount").Value),
                    Items = data
                };
            }


            catch
            {
                throw;
            }
        }

        public UserInfoViewModel UserInfo(int userId)
        {
            try
            {
                var parameters = Extension.Init().Add("@userId", userId);
                string jsonData = UnitOfWork.ExecuteProcedure<string>("[admin].[UserInfo]", parameters)
                    .Aggregate((i, j) => i + j);
                return JsonConvert.DeserializeObject<IEnumerable<UserInfoViewModel>>(jsonData).First();
            }
            catch
            {
                throw;
            }
        }

        public UserInfoWithOtherData UserInfoWithDetails(int userId)
        {
            UserInfoWithOtherData userInfoWithOtherData = new UserInfoWithOtherData();

            List<RoleViewModel> roleViewModels = new List<RoleViewModel>();
            List<DeptViewModel> departmentViewModels = new List<DeptViewModel>();
            List<DeptPositionViewModel> deptPostionViewModels = new List<DeptPositionViewModel>();
            List<OrgViewModel> orgViewModels = new List<OrgViewModel>();
            UserDetailsWithWorkplaces model = new UserDetailsWithWorkplaces();
            UserDetailsWithWorkplaces userInfoAllDetailsViewModel = new UserDetailsWithWorkplaces();
            try
            {
                var parameters = Extension.Init().Add("@userId", userId);
                string jsonData = UnitOfWork.ExecuteProcedure<string>("[admin].[UserInfoWithDetails]", parameters)
                    .Aggregate((i, j) => i + j);
                model = JsonConvert.DeserializeObject<IEnumerable<UserDetailsWithWorkplaces>>(jsonData).First();
                model.UserId = userId;
                userInfoWithOtherData.DeptPositionViewModels = deptPostionViewModels;
                userInfoWithOtherData.DeptViewModels = departmentViewModels;
                userInfoWithOtherData.UserDetailsWithWorkplaces = model;
                userInfoWithOtherData.OrgViewModels = orgViewModels;
                userInfoWithOtherData.Roles = roleViewModels;

                return userInfoWithOtherData;
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
                throw;
            }
        }

        public List<OrgViewModel> GetOrgViewModels()
        {
            var parameters = Extension.Init().Add("@orgId", 0);
            string jsonData = UnitOfWork.ExecuteProcedure<string>("[admin].[GetOrganisationsById]", parameters)
                .Aggregate((i, j) => i + j);

            List<OrgViewModel> orgs = JsonConvert.DeserializeObject<IEnumerable<OrgViewModel>>(jsonData).ToList();

            return orgs;
        }

        public List<RoleViewModel> GetRoleViewModels()
        {
            var parameters = Extension.Init().Add("@roleId", 0);
            string jsonData = UnitOfWork.ExecuteProcedure<string>("[admin].[GetRolesById]", parameters)
                .Aggregate((i, j) => i + j);

            List<RoleViewModel> roles = JsonConvert.DeserializeObject<IEnumerable<RoleViewModel>>(jsonData).ToList();

            return roles;
        }

        public int CreateUser(UserDetailsWithWorkplaces model, out int result)
        {
            try
            {
                //DateTime? birthdate = null;
                //DateTime tempDate;
                //var ok = DateTime.TryParse(model.PersonnelBirthdate, out tempDate);
                //if (ok) birthdate = tempDate;

                var parameters = Extension.Init()
                    .Add("@personnelName", model.PersonnelName)
                    .Add("@personnelSurname", model.PersonnelSurname)
                    .Add("@personnelLastname", model.PersonnelLastname)
                    .Add("@personnelBirthdate", model.PersonnelBirthdate)
                    .Add("@sexId", model.PersonnelSexId)
                    .Add("@personnelMobile", model.PersonnelMobile)
                    .Add("@personnelEmail", model.PersonnelEmail)
                    .Add("@personnelPhone", model.PersonnelPhone)
                    .Add("@UserName", model.UserName)
                    .Add("@userStatus ", model.UserStatus)
                    .Add("@userFin", model.UserFin);
                //parameters.Add("@formTypeId", 3);
                List<UserWorkplaceForUpdate> userWorkplaceForUpdate = model.JsonWorkPlace.Select(x =>
                    new UserWorkplaceForUpdate
                    {
                        DepartmentId = x.DepartmentId,
                        DepartmentPositionId = x.DepartmentPositionId,
                        OrganizationId = x.OrganizationId,
                        JsonRoleId = JsonConvert.SerializeObject(x.RoleId),
                        WorkplaceId = x.WorkplaceId,
                        SectorId = x.SectorId
                    }).ToList();

                var workplaces = Extensions.ToDataTable(userWorkplaceForUpdate);

                if (workplaces != null)
                    parameters.Add("@workplaces", workplaces, "[admin].[UdttWorkPlaces]");

                UnitOfWork.ExecuteNonQueryProcedure("[admin].[CreateUser]", parameters);

                //result = Convert.ToInt32(parameters.FirstOrDefault(p => p.ParameterName == "@result")?.Value);
                result = 0;

                return result;
            }
            catch (Exception exception)
            {
                throw;
            }
        }

        public bool ResetUserPassword(int userId)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@userId", userId)
                    .Add("@formTypeId", 3);

                UnitOfWork.ExecuteNonQueryProcedure("[admin].[EditUser]", parameters);

                return true;
            }
            catch (Exception e)
            {
                return false;
            }
        }

        public bool CreateOrganisation(CreateOrgModel model)
        {
            try
            {
                UnitOfWork.GetRepository<DC_ORGANIZATION>().Add(new DC_ORGANIZATION
                {
                    OrganizationName = model.OrgName,
                    OrganizationShortname = model.OrgName,
                    OrganizationTopId = model.TopOrgId,
                    OrganizationIndex = model.OrgIndex,
                    MaxUserCount = model.MaxUserCount,
                    UserLimitComment = model.UserLimitComment,
                    OrganizationStatus = true,

                    IsDeleted = 0
                });

                UnitOfWork.SaveChanges();

                return true;
            }
            catch (Exception exception)
            {
                return false;
            }
        }

        public int UpdateUser(UserDetailsWithWorkplaces model, bool? prevStatus, out int result)
        {
            try
            {
                DateTime birthdate;
                DateTime.TryParse(model.PersonnelBirthdate1, out birthdate);

                var parameters = Extension.Init()
                    .Add("@userId", model.UserId)
                    .Add("@personnelName", model.PersonnelName)
                    .Add("@personnelSurname", model.PersonnelSurname)
                    .Add("@personnelLastname", model.PersonnelLastname)
                    .Add("@personnelBirthdate", model.PersonnelBirthdate)
                    .Add("@sexId", model.PersonnelSexId)
                    .Add("@personnelMobile", model.PersonnelMobile)
                    .Add("@personnelEmail", model.PersonnelEmail)
                    .Add("@personnelPhone", model.PersonnelPhone)
                    .Add("@userName", model.UserName)
                    .Add("@userStatus ", model.UserStatus)
                    .Add("@userFin", model.UserFin);

                List<UserWorkplaceForUpdate> userWorkplaceForUpdate = model.JsonWorkPlace.Select(x =>
                    new UserWorkplaceForUpdate
                    {
                        DepartmentId = x.DepartmentId,
                        DepartmentPositionId = x.DepartmentPositionId,
                        OrganizationId = x.OrganizationId,
                        JsonRoleId = JsonConvert.SerializeObject(x.RoleId),
                        WorkplaceId = x.WorkplaceId,
                        SectorId = x.SectorId
                    }).ToList();

                var workplaces = Extensions.ToDataTable(userWorkplaceForUpdate);

                if (workplaces != null)
                    parameters.Add("@workplaces", workplaces, "[admin].[UdttWorkPlaces]");

                UnitOfWork.ExecuteNonQueryProcedure("[admin].[EditUser]", parameters);

                //result = Convert.ToInt32(parameters.FirstOrDefault(p => p.ParameterName == "@result")?.Value);
                result = 0;

                return result;
            }
            catch (Exception exception)
            {
                throw;
            }
        }

        public List<DeptViewModel> GetDepartmentsByOrgId(int orgId)
        {
            var parameters = Extension.Init().Add("@orgId", orgId);
            var jsonData = UnitOfWork.ExecuteProcedure<string>("[admin].[GetDepartmentsByOrgId]", parameters);

            string result = String.Empty;

            if (jsonData.Count() > 0)
            {
                result = jsonData.Aggregate((i, j) => i + j);
            }

            IEnumerable<DeptViewModel> deptViewModels1 =
                JsonConvert.DeserializeObject<IEnumerable<DeptViewModel>>(result);

            List<DeptViewModel> deptViewModels =
                deptViewModels1 != null ? deptViewModels1.ToList() : new List<DeptViewModel>();

            return deptViewModels;
        }

        public List<DeptPositionViewModel> GetPositionsByDeptId(int deptId)
        {
            List<DeptPositionViewModel> deptPositionViewModels = new List<DeptPositionViewModel>();
            try
            {
                var parameters = Extension.Init().Add("@deptId", deptId);
                string jsonData = UnitOfWork.ExecuteProcedure<string>("[admin].[GetPositionsByDeptId]", parameters)
                    .Aggregate((i, j) => i + j);

                deptPositionViewModels =
                    JsonConvert.DeserializeObject<IEnumerable<DeptPositionViewModel>>(jsonData).ToList();
            }
            catch
            {
            }

            return deptPositionViewModels;
        }

        public List<DeptViewModel> GetSectorsByDeptId(int deptId)
        {
            List<DeptViewModel> deptViewModels = new List<DeptViewModel>();
            try
            {
                var parameters = Extension.Init().Add("@deptId", deptId);
                string jsonData = UnitOfWork.ExecuteProcedure<string>("[admin].[GetSectorsByDeptId]", parameters)
                    ?.Aggregate((i, j) => i + j);
                deptViewModels = JsonConvert.DeserializeObject<IEnumerable<DeptViewModel>>(jsonData).ToList();
            }
            catch (Exception e)
            {
            }

            return deptViewModels;
        }

        public GenericGridViewModel<OrgViewModel> GetOrganisationsViewModels(int? pageIndex, int pageSize,
            List<SqlParameter> searchParams)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@pageIndex", pageIndex)
                    .Add("@pageSize", pageSize)
                    .Add("@totalCount", 0, ParameterDirection.Output);

                parameters.AddRange(searchParams);
                var data = UnitOfWork.ExecuteProcedure<OrgViewModel>("[admin].[GetOrganisations]", parameters).ToList();
                return new GenericGridViewModel<OrgViewModel>
                {
                    TotalCount = Convert.ToInt32(parameters.First(p => p.ParameterName == "@totalCount").Value),
                    Items = data
                };
            }
            catch (Exception e)
            {
                throw;
            }
        }

        public GenericGridViewModel<DeptViewModel> GetDepartmentsViewModels(int? pageIndex, int pageSize,
            List<SqlParameter> searchParams)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@pageIndex", pageIndex)
                    .Add("@pageSize", pageSize)
                    .Add("@totalCount", 0, ParameterDirection.Output);

                parameters.AddRange(searchParams);
                var data = UnitOfWork.ExecuteProcedure<DeptViewModel>("[admin].[GetDepartments]", parameters).ToList();
                return new GenericGridViewModel<DeptViewModel>
                {
                    TotalCount = Convert.ToInt32(parameters.First(p => p.ParameterName == "@totalCount").Value),
                    Items = data
                };
            }
            catch (Exception e)
            {
                throw;
            }
        }

        public GenericGridViewModel<RoleViewModel> GetRoleViewModels(int pageIndex, int pageSize,
            List<SqlParameter> searchParams)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@pageIndex", pageIndex)
                    .Add("@pageSize", pageSize)
                    .Add("@totalCount", 0, ParameterDirection.Output);

                parameters.AddRange(searchParams);
                var data = UnitOfWork.ExecuteProcedure<RoleViewModel>("[admin].[GetRoles]", parameters).ToList();
                return new GenericGridViewModel<RoleViewModel>
                {
                    TotalCount = Convert.ToInt32(parameters.First(p => p.ParameterName == "@totalCount").Value),
                    Items = data
                };
            }
            catch (Exception e)
            {
                throw;
            }
        }

        public RoleDetailsViewModel RoleInfoWithDetails(int roleId)
        {
            var parameters = Extension.Init().Add("@roleId", roleId);
            string jsonData = UnitOfWork.ExecuteProcedure<string>("[admin].[getRoleInfo]", parameters)
                .Aggregate((i, j) => i + j);
            RoleDetailsViewModel roleDetailsViewModel;
            if (roleId != 0)
            {
                roleDetailsViewModel =
                    JsonConvert.DeserializeObject<IEnumerable<RoleDetailsViewModel>>(jsonData).First();
            }
            else
            {
                roleDetailsViewModel = JsonConvert.DeserializeObject<RoleDetailsViewModel>(jsonData);
            }

            return roleDetailsViewModel;
        }

        public void EditRole(CreateRoleModel model)
        {
            DC_ROLE role = UnitOfWork.GetRepository<DC_ROLE>()
                .Get(x => x.RoleStatus == true && x.RoleId == model.RoleId);

            if (role != null)
            {
                role.RoleComment = model.RoleName;
                UnitOfWork.GetRepository<DC_ROLE>().Update(role);

                List<string> roleOperationIds = UnitOfWork.GetRepository<DC_ROLE_OPERATION>()
                    .GetAll(x => x.RoleId == model.RoleId).Select(x => x.RoleOperationId.ToString()).ToList();
                List<string> arrivedRoleOperationIds = model.RoleOperations.Select(x => x.RoleOperationId).ToList();
                List<string> nonArrivedRoleOperationIds = roleOperationIds.Except(arrivedRoleOperationIds).ToList();

                List<RoleOperationCustomModel> existingRoleOperations =
                    model.RoleOperations.Where(x => x.RoleOperationId != null).ToList();
                List<RoleOperationCustomModel> newArrivedRoleOperations =
                    model.RoleOperations.Where(x => x.RoleOperationId == null).ToList();

                foreach (string roleOperationId in nonArrivedRoleOperationIds)
                {
                    int roleOperationId1 = int.Parse(roleOperationId);
                    DC_ROLE_OPERATION roleOperation = UnitOfWork.GetRepository<DC_ROLE_OPERATION>()
                        .Get(x => x.RoleId == model.RoleId && x.RoleOperationId == roleOperationId1);
                    UnitOfWork.GetRepository<DC_ROLE_OPERATION>().Delete(roleOperation);
                }

                foreach (RoleOperationCustomModel roleOperationCustomModel in newArrivedRoleOperations)
                {
                    DC_ROLE_OPERATION roleOperation = new DC_ROLE_OPERATION
                    {
                        OperationId = roleOperationCustomModel.OperationId,
                        RightId = roleOperationCustomModel.RightId,
                        RightTypeId = roleOperationCustomModel.RightTypeId,
                        RoleId = model.RoleId
                    };
                    UnitOfWork.GetRepository<DC_ROLE_OPERATION>().Add(roleOperation);
                }

                foreach (RoleOperationCustomModel roleOperationCustomModel in existingRoleOperations)
                {
                    int roleOperationId1 = int.Parse(roleOperationCustomModel.RoleOperationId);
                    DC_ROLE_OPERATION roleOperation = UnitOfWork.GetRepository<DC_ROLE_OPERATION>()
                        .Get(x => x.RoleId == model.RoleId && x.RoleOperationId == roleOperationId1);

                    roleOperation.OperationId = roleOperationCustomModel.OperationId;
                    roleOperation.RightId = roleOperationCustomModel.RightId;
                    roleOperation.RightTypeId = roleOperationCustomModel.RightTypeId;

                    UnitOfWork.GetRepository<DC_ROLE_OPERATION>().Update(roleOperation);
                }

                UnitOfWork.SaveChanges();
            }
        }

        public void CreateRole(CreateRoleModel model)
        {
            DC_ROLE role = new DC_ROLE
            {
                RoleName = model.RoleName,
                RoleComment = model.RoleName,
                RoleStatus = true,
                RoleApplicationId = 1
            };

            UnitOfWork.GetRepository<DC_ROLE>().Add(role);

            UnitOfWork.SaveChanges();

            foreach (RoleOperationCustomModel roleOperationCustomModel in model.RoleOperations)
            {
                DC_ROLE_OPERATION roleOperation = new DC_ROLE_OPERATION
                {
                    OperationId = roleOperationCustomModel.OperationId,
                    RightId = roleOperationCustomModel.RightId != 0 ? roleOperationCustomModel.RightId : (int?)null,
                    RightTypeId = roleOperationCustomModel.RightTypeId != 0
                        ? roleOperationCustomModel.RightTypeId
                        : (int?)null,
                    RoleId = role.RoleId
                };
                UnitOfWork.GetRepository<DC_ROLE_OPERATION>().Add(roleOperation);
            }

            UnitOfWork.SaveChanges();
        }

        public GenericGridViewModel<PositionViewModel> GetPositionViewModels(int workplaceId, int pageIndex, int pageSize,
            List<SqlParameter> searchParams)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@workplaceId", workplaceId)
                    .Add("@pageIndex", pageIndex)
                    .Add("@pageSize", pageSize)
                    .Add("@totalCount", 0, ParameterDirection.Output);

                parameters.AddRange(searchParams);
                var data = UnitOfWork.ExecuteProcedure<PositionViewModel>("[admin].[GetPositions]", parameters)
                    .ToList();
                return new GenericGridViewModel<PositionViewModel>
                {
                    TotalCount = Convert.ToInt32(parameters.First(p => p.ParameterName == "@totalCount").Value),
                    Items = data
                };
            }
            catch (Exception e)
            {
                throw;
            }
        }

        public PositionInfo GetPositionInfo(int posId, int orgId, bool isAdmin)
        {
            PositionInfo positionInfo;
            List<DepartmentCustomModel> departments = UnitOfWork.GetRepository<DC_DEPARTMENT>()
                .GetAll(x => x.DepartmentStatus == true && x.DepartmentOrganization == (isAdmin ? x.DepartmentOrganization : orgId)).Select(x =>
                        new DepartmentCustomModel
                        {
                            DepartmentId = x.DepartmentId,
                            DepartmentName = x.DepartmentName
                        }).ToList();

            List<PosGroupCustomModel> positionGroups = UnitOfWork.GetRepository<DC_POSITION_GROUP>()
                .GetAll(x => x.PositionGroupStatus == true).Select(x =>
                    new PosGroupCustomModel
                    {
                        PositionGroupId = x.PositionGroupId,
                        PositionGroupName = x.PositionGroupName
                    }).ToList();

            if (posId != 0)
            {
                DC_DEPARTMENT_POSITION position = UnitOfWork.GetRepository<DC_DEPARTMENT_POSITION>()
                    .Get(x => x.DepartmentPositionStatus == true && x.DepartmentPositionId == posId);

                positionInfo = new PositionInfo
                {
                    DepartmentId = position.DepartmentId,
                    DepartmentPositionId = position.DepartmentPositionId,
                    DepartmentPositionName = position.DepartmentPositionName,
                    DepartmentPositionIndex = position.DepartmentPositionIndex,
                    PositionGroupId = position.PositionGroupId,
                    Departments = departments,
                    PositionGroups = positionGroups
                };
            }
            else
            {
                positionInfo = new PositionInfo
                {
                    Departments = departments,
                    PositionGroups = positionGroups
                };
            }

            return positionInfo;
        }

        public bool UpdateWorkplaceStatus(int workplaceId)
        {
            try
            {
                var parameters = Extension.Init().Add("@workplaceId", workplaceId);
                UnitOfWork.ExecuteNonQueryProcedure("[admin].[UpdateWorkplaceStatus]", parameters);

                return true;
            }
            catch (Exception exception)
            {
                return false;
            }
        }

        public IEnumerable<Structure> GetStructures()
        {
            try
            {
                //   var parameters = Extension.Init().Add("@userId", userId);
                string jsonData = UnitOfWork.ExecuteProcedure<string>("[admin].[GetStructures]")
                    .Aggregate((i, j) => i + j);
                return JsonConvert.DeserializeObject<IEnumerable<Structure>>(jsonData);
            }
            catch
            {
                throw;
            }
        }

        public IEnumerable<Structure> GetStructures2(int workplaceId)
        {
            try
            {
                var parameters = Extension.Init().Add("@workplaceId", workplaceId);
                string jsonData = UnitOfWork.ExecuteProcedure<string>("[admin].[GetStructuresForSearch]", parameters)
                    .Aggregate((i, j) => i + j);
                return JsonConvert.DeserializeObject<IEnumerable<Structure>>(jsonData);
            }
            catch
            {
                throw;
            }
        }

        public IEnumerable<Structure> GetAllDepartmentsByOrgId(int orgId)
        {
            try
            {
                var parameters = Extension.Init().Add("@orgId", orgId);
                string jsonData = UnitOfWork.ExecuteProcedure<string>("[admin].[GetAllDepartmentsByOrgId]", parameters)
                    .Aggregate((i, j) => i + j);
                return JsonConvert.DeserializeObject<IEnumerable<Structure>>(jsonData);
            }
            catch (Exception)
            {
                return new List<Structure>();
            }
        }

        public GenericGridViewModel<TopicTypeInfo> GetTopicTypeInfos(int workplaceId, int pageIndex, int pageSize,
            List<SqlParameter> searchParams)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@workplaceId", workplaceId)
                    .Add("@pageIndex", pageIndex)
                    .Add("@pageSize", pageSize)
                    .Add("@totalCount", 0, ParameterDirection.Output);

                parameters.AddRange(searchParams);
                var data = UnitOfWork.ExecuteProcedure<TopicTypeInfo>("[admin].[GetTopicTypes]", parameters).ToList();
                return new GenericGridViewModel<TopicTypeInfo>
                {
                    TotalCount = Convert.ToInt32(parameters.First(p => p.ParameterName == "@totalCount").Value),
                    Items = data
                };
            }
            catch (Exception e)
            {
                throw;
            }
        }

        public GenericGridViewModel<TopicInfo> GetTopicInfos(int workplaceId, int pageIndex, int pageSize,
            List<SqlParameter> searchParams)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@workplaceId", workplaceId)
                    .Add("@pageIndex", pageIndex)
                    .Add("@pageSize", pageSize)
                    .Add("@totalCount", 0, ParameterDirection.Output);

                parameters.AddRange(searchParams);
                var data = UnitOfWork.ExecuteProcedure<TopicInfo>("[admin].[GetTopics]", parameters).ToList();
                return new GenericGridViewModel<TopicInfo>
                {
                    TotalCount = Convert.ToInt32(parameters.First(p => p.ParameterName == "@totalCount").Value),
                    Items = data
                };
            }
            catch (Exception e)
            {
                throw;
            }
        }

        public TopicTypeInfo GetTopicTypeInfo(int topicTypeId)
        {
            TopicTypeInfo info = null;
            DOC_TOPIC_TYPE dOC_TOPIC_TYPE = UnitOfWork.GetRepository<DOC_TOPIC_TYPE>()
                .Get(x => x.TopicTypeId == topicTypeId);
            if (dOC_TOPIC_TYPE != null)
            {
                info = new TopicTypeInfo
                {
                    TopicTypeId = dOC_TOPIC_TYPE.TopicTypeId,
                    TopicTypeName = dOC_TOPIC_TYPE.TopicTypeName,
                    TopicTypeOrderIndex = dOC_TOPIC_TYPE.TopicTypeOrderIndex,
                    TopicTypeStatus = dOC_TOPIC_TYPE.TopicTypeStatus,
                    OrganizationId = dOC_TOPIC_TYPE.OrganizationId,
                    CitizenTopic = dOC_TOPIC_TYPE.CitizenTopic,
                    OrgTopic = dOC_TOPIC_TYPE.OrgTopic
                };
            }

            return info;
        }

        public TopicInfo GetTopicInfo(int topicId)
        {
            TopicInfo info = null;
            DOC_TOPIC dOC_TOPIC = UnitOfWork.GetRepository<DOC_TOPIC>()
                .Get(x => x.TopicId == topicId);
            if (dOC_TOPIC != null)
            {
                info = new TopicInfo
                {
                    TopicId = dOC_TOPIC.TopicId,
                    TopicName = dOC_TOPIC.TopicName,
                    TopicIndex = dOC_TOPIC.TopicIndex,
                    TopicTypeId = dOC_TOPIC.TopicTypeId
                };
            }

            return info;
        }

        public GenericGridViewModel<RenderOrganisations> GetRelOrgInfos(int pageIndex, int pageSize,
            List<SqlParameter> searchParams)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@pageIndex", pageIndex)
                    .Add("@pageSize", pageSize)
                    .Add("@totalCount", 0, ParameterDirection.Output);

                parameters.AddRange(searchParams);
                var data = UnitOfWork.ExecuteProcedure<RenderOrganisations>("[admin].[OrganisationsForRendering]", parameters)
                    .ToList();
                return new GenericGridViewModel<RenderOrganisations>
                {
                    TotalCount = Convert.ToInt32(parameters.First(p => p.ParameterName == "@totalCount").Value),
                    Items = data
                };
            }
            catch (Exception e)
            {
                throw e;
            }
        }

        public RenderOrganisations GetOrganisationsForRenderingInfo(int OrgsId)
        {
            RenderOrganisations info = null;
            DC_ORGANIZATION dcOrganization = UnitOfWork.GetRepository<DC_ORGANIZATION>()
                .Get(x => x.OrganizationId == OrgsId);
            if (dcOrganization != null)
            {
                info = new RenderOrganisations()
                {
                    IsEdit = 1,
                    IsDeleted = 0,
                    Id = dcOrganization.OrganizationId,
                    OrganisationShortname = dcOrganization.OrganizationShortname,
                    OrderIndex = dcOrganization.OrganizationIndex
                };
            }

            return info;
        }

        public List<ChooseModel> GetDepartmentsByOrgId2(int id)
        {
            var parameters = Extension.Init()
                .Add("@id", id);

            return UnitOfWork
                .ExecuteProcedure<ChooseModel>("[admin].[GetDepartmentsWhileCreate]", parameters).ToList();
        }

        public GenericGridViewModel<AuthorityViewModel> GetauthorityTransferInfos(int workplaceId, int pageIndex, int pageSize,
            List<SqlParameter> searchParams)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@workplaceId", workplaceId)
                    .Add("@pageIndex", pageIndex)
                    .Add("@pageSize", pageSize)
                    .Add("@totalCount", 0, ParameterDirection.Output);

                parameters.AddRange(searchParams);
                var data = UnitOfWork.ExecuteProcedure<AuthorityViewModel>("[admin].[GetTransferAuthority]", parameters).ToList();
                return new GenericGridViewModel<AuthorityViewModel>
                {
                    TotalCount = Convert.ToInt32(parameters.First(p => p.ParameterName == "@totalCount").Value),
                    Items = data
                };
            }
            catch (Exception e)
            {
                throw;
            }
        }

        public List<ChooseModel> GetChooseModelAuthority(int workplaceId)
        {
            var parameters = Extension.Init()
                                            .Add("@workplaceId", workplaceId);

            return UnitOfWork.ExecuteProcedure<ChooseModel>("[admin].[spGetAuthorityTransferPersonel]", parameters).ToList();
        }

        public PassAuthorityTransfer GetAuthorityTransferInfo(int transferInfo)
        {
            PassAuthorityTransfer info = null;

            AuthorityTransfer authorityTransfer = UnitOfWork.GetRepository<AuthorityTransfer>()
                .Get(x => x.AuthorityId == transferInfo);

            if (authorityTransfer != null)
            {
                info = new PassAuthorityTransfer
                {
                    AuthorityId = authorityTransfer.AuthorityId,
                    TransferredFromPerson = authorityTransfer.TransferredFromPerson,

                    TransferredToPerson = authorityTransfer.TransferredToPerson,

                    TransferReason = authorityTransfer.TransferredReason,

                    BeginDate = authorityTransfer.BeginDate,

                    EndDate = authorityTransfer.EndDate,

                    TransferNote = authorityTransfer.TransferNote,

                    AuthorityStatus = authorityTransfer.AuthorityStatus
                };
            }

            return info;
        }

        public GenericGridViewModel<EditDocumentViewModel> GetEditDocInfo(string docEnterNo, string docDocNo, int pageIndex, int pageSize, int workplaceId
           )
        {
            try
            {
                var parameters = Extension.Init()

                    .Add("@pageIndex", pageIndex)
                    .Add("@pageSize", pageSize)
                    .Add("@docEnterNo", docEnterNo.ToString())
                    .Add("@docDocNo", docDocNo.ToString())
                    .Add("@workplaceId", workplaceId)
                    .Add("@totalCount", 0, ParameterDirection.Output);

                var data = UnitOfWork.ExecuteProcedure<EditDocumentViewModel>("[admin].[GetEditDocument]", parameters).ToList();
                return new GenericGridViewModel<EditDocumentViewModel>
                {
                    TotalCount = Convert.ToInt32(parameters.First(p => p.ParameterName == "@totalCount").Value),
                    Items = data
                };
            }
            catch (Exception e)
            {
                throw;
            }
        }

        public int EditDocumentOpenClose(int? executorId, int? docId, int? workplaceId)
        {
            int result = 0;
            try
            {
                var parameters = Extension.Init()
                    .Add("@formType", (int)formTypes.EditDocument)
                    .Add("@executorId", executorId)
                    .Add("@docId", docId)
                    .Add("@workplaceId", workplaceId);
                UnitOfWork.ExecuteNonQueryProcedure("[admin].[EditDocument]", parameters);
                result = 1;
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                throw;
            }

            return result;
        }

        public int EditDocumentExceptionCase(string docEnterNo, int? workplaceId)
        {
            int result = 0;
            try
            {
                var parameters = Extension.Init()
                    .Add("@formType", (int)formTypes.SpecialPersons)
                    .Add("@docEnterNo", docEnterNo)
                    .Add("@workplaceId", workplaceId);
                UnitOfWork.ExecuteNonQueryProcedure("[admin].[EditDocument]", parameters);
                result = 1;
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                throw;
            }

            return result;
        }

        public int CloseReadStatus(int executorId, int docId, int workplaceId)
        {
            int result = 0;
            try
            {
                var parameters = Extension.Init()
                    .Add("@formType", (int)formTypes.CloseReadStatus)
                    .Add("@executorId", executorId)
                    .Add("@docId", docId)
                    .Add("@workplaceId", workplaceId);
                UnitOfWork.ExecuteNonQueryProcedure("[admin].[EditDocument]", parameters);
                result = 1;
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                throw;
            }

            return result;
        }

        public int GetSpecialRightsPerssons()
        {
            int result = 0;
            try
            {
                var parameters = Extension.Init()
                    .Add("@formType", (int)formTypes.FetchPersons);
                UnitOfWork.ExecuteNonQueryProcedure("[admin].[EditDocument]", parameters);
                result = 1;
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                throw;
            }

            return result;
        }

        public List<ChooseModel> GetSpecialRightsPersons()
        {
            var parameters = Extension.Init().Add("@formType", (int)formTypes.FetchPersons);
            return UnitOfWork.ExecuteProcedure<ChooseModel>("[admin].[EditDocument]", parameters).ToList();
        }

        public void AuthorityDocsTransfer(int authorityId)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@authorityId", authorityId);

                UnitOfWork.ExecuteNonQueryProcedure("[dbo].[DocsTransfer]", parameters);
            }
            catch (Exception e)
            {
                throw e;
            }
        }

        public List<ChooseModel> GetChooseModel(int workplaceId)
        {
            var parameters = Extension.Init()
                    .Add("@workplaceId", workplaceId);

            return UnitOfWork.ExecuteProcedure<ChooseModel>("[admin].[GetRedirectionPersons]", parameters).ToList();
        }

        public int RedirectToAnyPerson(int? executorId, int? workplaceId, int? redirectedPerson)
        {
            int result = 0;
            try
            {
                var parameters = Extension.Init()
                    .Add("@formType", (int)formTypes.RedirectToPerson)
                    .Add("@executorId", executorId)
                    .Add("@workplaceId", workplaceId)
                    .Add("@redirectedPerson", redirectedPerson);
                UnitOfWork.ExecuteNonQueryProcedure("[admin].[EditDocument]", parameters);
                result = 1;
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                throw;
            }

            return result;
        }

        public int PassVizaFromPerson(int? docId, int? executorId, int? workplaceId)
        {
            int result = 0;
            try
            {
                var parameters = Extension.Init()
                    .Add("@formType", (int)formTypes.PassVizaFromPerson)
                    .Add("@docId", docId)
                    .Add("@executorId", executorId)
                    .Add("@workplaceId", workplaceId);
                UnitOfWork.ExecuteNonQueryProcedure("[admin].[EditDocument]", parameters);
                result = 1;
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                throw;
            }

            return result;
        }

        public List<UserStatistics> GetUserStatistics(int? orgId)
        {
            var parameters = Extension.Init()
                .Add("@orgId", orgId);

            return UnitOfWork.ExecuteProcedure<UserStatistics>("[admin].[GetUserStatistics]", parameters).ToList();
        }


        public List<UserLimitationLogs> UserLimitationLogs()
        {
            var parameters = Extension.Init()
                .Add("@formTypeId", 1);

            return UnitOfWork.ExecuteProcedure<UserLimitationLogs>("[admin].[GetUserStatistics]", parameters).ToList();
        }

        public int ChangeWorkplaceDocs(int? oldWorkPlace, int? newWorkPlace)
        {
            int result = 0;
            try
            {
                var parameters = Extension.Init()

                    .Add("@oldWorkPlace", oldWorkPlace)
                    .Add("@newWorkPlace", newWorkPlace);
                UnitOfWork.ExecuteNonQueryProcedure("[admin].[ChangeWorkPlaceDocs]", parameters);
                result = 1;
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                throw;
            }
            return result;
        }


    }
}