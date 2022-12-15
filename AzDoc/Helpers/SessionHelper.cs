using BLL.Models.Account;
using BLL.Models.Direction;
using BLL.Models.Direction.Direction;
using BLL.Models.Document;
using DataCache.Core;
using DMSModel;
using Model.DB_Views;
using System;
using System.Collections.Generic;
using System.Web;

namespace AzDoc.Helpers
{
    public static class SessionHelper
    {
        #region Private Constants

        private const string sessionId = "SessionId";
        private const string userId = "UserId";
        private const string userName = "UserName";
        private const string workPlaceId = "WorkPlaceId";
        private const string personFullName = "PersonFullName";

        private const string isNotifications = "IsNotifications";
        private const string organizationId = "OrganizationId";
        private const string period = "Period";
        private const string defaultPage = "User";
        private const string currentDocId = "CurrentDocId";
        private const string relatedDocId = "RelatedDocId";
        private const string answerDocId = "AnswerDocId";
        private const string docTypeId = "DocTypeId";
        private const string periodId = "PeriodId";
        private const string fileInfoId = "FileInfoId";
        private const string tempFile = "TempFile";
        private const string directionController = "DirectionController";
        private const string positionGroupId = "PositionGroupId";
        private const string positionId = "PositionId";
        private const string departmentId = "DepartmentId";
        private const string departmentPositionName = "DepartmentPositionName";
        private const string departmentTopDepartmentId = "DepartmentTopDepartmentId";
        private const string departmentDepartmentId = "DepartmentDepartmentId";
        private const string departmentSectionId = "DepartmentSectionId";
        private const string departmentSubSectionId = "DepartmentSubSectionId";
        private const string positionGroupLevel = "PositionGroupLevel";
        private const string chiefWorkPlaceId = "ChiefWorkPlaceId";
        private const string defaultLang = "DefaultLang";
        private const string defaultLeftMenu = "DefaultLeftMenu";
        private const string directionId = "DirectionId";
        private const string sendStatusId = "SendStatusId";
        private const string oldExecutorId = "SenderWorkplaceId";
        private const string role = "Roles";
        private const string smdoDocId = "smdoDocId";
        private const string adminPermission = "AdminPermission";
        private const string superAdminPermission = "SuperAdminPermission";
        private const string resolutionDocId = "ResolutionDocId";
        private const string userFIN = "UserFIN";
        private const string departmentCode = "DepartmentCode";

        private const string tempUserName = "TempUserName";
        private const string tempUserPassword = "TempUserPassword";

        #endregion Private Constants

        private static void SetSessions()
        {
        }

        #region Public Method

        public static List<DOC_TYPE_GROUP> GetTreeGroupAll()
        {
            CacheKey key = CacheKey.New(CacheTable.DOC_TYPE_GROUP, "-1");
            return CacheProvider.Instance.Get(key) as List<DOC_TYPE_GROUP>;
        }

        public static List<DC_TREE> GetTreeAll()
        {
            CacheKey key = CacheKey.New(CacheTable.DC_TREE, "-1");

            //if (CacheProvider.Instance.Get(key) == null)
            //{
            //    CacheHelper.FillCache();
            //}

            return CacheProvider.Instance.Get(key) as List<DC_TREE>;
        }

        public static void ClearDocId()
        {
            HttpContext.Current.Session[answerDocId] = null;
            HttpContext.Current.Session[relatedDocId] = null;
            SmdoDocGuid = null;
        }

        public static void ClearHelperSession()
        {
            HttpContext.Current.Session["DirectionType"] = null;
            HttpContext.Current.Session[currentDocId] = null;
            HttpContext.Current.Session[resolutionDocId] = null;
            HttpContext.Current.Session["TempFile"] = null;
            HttpContext.Current.Session["personToGridLookup"] = null;
            HttpContext.Current.Session["personApprove"] = null;
            HttpContext.Current.Session["personFromGridLookup"] = null;
            HttpContext.Current.Session["sendPeronRightGrid"] = null;
            HttpContext.Current.Session["sendPeronLeftGrid"] = null;
            HttpContext.Current.Session["DirectionTemplate"] = null;
            HttpContext.Current.Session["TempFile"] = null;
            //HttpContext.Current.Session["DefaultLeftMenu"] = null;
        }

        public static void SetSessions(UserModel user)
        {
            UserId = user.UserId;
            UserName = user.UserName;
            DefaultPage = user.DefaultPage;
            DefaultLang = user.DefaultLang;
            PersonFullName = user.PersonFullName;
            DepartmentPositionName = user.DepartmentPositionName;
            OrganizationId = user.DepartmentOrganization.Value;
            UserFIN = user.UserFin?.Trim().ToUpper();
        }

        public static void SetTempSessions(UserModel user)
        {
            TempUserName = user.UserName;
            TempUserPassword = user.UserPassword;
        }

        public static string SmdoDocGuid
        {
            get => (string)HttpContext.Current.Session[smdoDocId];

            set => HttpContext.Current.Session[smdoDocId] = value;
        }


        public static int SenderWorkplaceId
        {
            get
            {
                int result = 0;
                try
                {
                    if(HttpContext.Current.Session[oldExecutorId] != null)
                        result = (int)HttpContext.Current.Session[oldExecutorId];
                }
                catch { }
                return result;
            }
            set => HttpContext.Current.Session[oldExecutorId] = value;
        }

        public static int ResolutionDocId
        {
            get
            {
                int result = 0;
                try
                {
                    if(HttpContext.Current.Session[resolutionDocId] != null)
                        result = (int)HttpContext.Current.Session[resolutionDocId];
                }
                catch { }
                return result;
            }
            set => HttpContext.Current.Session[resolutionDocId] = value;
        }

        public static int SendStatusId
        {
            get
            {
                int result = 0;
                try
                {
                    if(HttpContext.Current.Session[sendStatusId] != null)
                        result = (int)HttpContext.Current.Session[sendStatusId];
                }
                catch { }
                return result;
            }
            set => HttpContext.Current.Session[sendStatusId] = value;
        }

        public static List<PeriodModel> Period
        {
            get
            {
                List<PeriodModel> result = null;
                try
                {
                    if(HttpContext.Current.Session[period] != null)
                        result = ((List<PeriodModel>)HttpContext.Current.Session[period]);
                }
                catch { }
                return result;
            }
            set => HttpContext.Current.Session[period] = value;
        }

        public static int UserId
        {
            get
            {
                int result = -1;
                try
                {
                    if(HttpContext.Current.Session[userId] != null)
                        result = (int)HttpContext.Current.Session[userId];
                }
                catch { }
                return result;
            }
            set
            {
                HttpContext.Current.Session[userId] = value;
            }
        }

        public static string SessionId
        {
            get
            {
                string result = null;
                try
                {
                    if(HttpContext.Current.Session[sessionId] != null)
                        result = HttpContext.Current.Session[sessionId].ToString();
                }
                catch { }
                return result;
            }
            set
            {
                HttpContext.Current.Session[sessionId] = value;
            }
        }

        public static int DirectionId
        {
            get
            {
                int result = 0;
                try
                {
                    if(HttpContext.Current.Session[directionId] != null)
                        result = (int)HttpContext.Current.Session[directionId];
                }
                catch { }
                return result;
            }
            set => HttpContext.Current.Session[directionId] = value;
        }

        public static string UserName
        {
            get
            {
                if(HttpContext.Current.Session[userName] == null)
                    return null;
                return HttpContext.Current.Session[userName].ToString();
            }

            set
            {
                HttpContext.Current.Session[userName] = value;
            }
        }

        public static string PersonFullName
        {
            get
            {
                if(HttpContext.Current.Session[personFullName] == null)
                    return null;
                return HttpContext.Current.Session[personFullName].ToString();
            }

            set
            {
                HttpContext.Current.Session[personFullName] = value;
            }
        }

        public static ICollection<VW_ROLES> Roles
        {
            get => (ICollection<VW_ROLES>)HttpContext.Current.Session[role];

            set => HttpContext.Current.Session[role] = value;
        }

        public static string DepartmentPositionName
        {
            get
            {
                if(HttpContext.Current.Session[departmentPositionName] == null)
                    return null;
                return HttpContext.Current.Session[departmentPositionName].ToString();
            }

            set
            {
                HttpContext.Current.Session[departmentPositionName] = value;
            }
        }

        public static int WorkPlaceId
        {
            get
            {
                int result = -1;
                try
                {
                    if(HttpContext.Current.Session[workPlaceId] != null)
                        result = (int)HttpContext.Current.Session[workPlaceId];
                }
                catch { }
                return result;
            }
            set
            {
                HttpContext.Current.Session[workPlaceId] = value;
                SetSessions();
            }
        }

        public static Boolean? IsNotifications
        {
            get
            {
                Boolean result = false;
                try
                {
                    if(HttpContext.Current.Session[isNotifications] != null)
                        result = (Boolean)HttpContext.Current.Session[isNotifications];
                }
                catch { }
                return result;
            }
            set
            {
                HttpContext.Current.Session[isNotifications] = value;
            }
        }

        public static int OrganizationId
        {
            get
            {
                if(HttpContext.Current.Session[organizationId] == null)
                    return -1;
                return (int)HttpContext.Current.Session[organizationId];
            }

            set
            {
                HttpContext.Current.Session[organizationId] = value;
            }

        }

        public static int CurrentDocId
        {
            get
            {
                int result = -1;
                try
                {
                    if(HttpContext.Current.Session[currentDocId] != null)
                        result = (int)HttpContext.Current.Session[currentDocId];
                }
                catch { }
                return result;
            }
            set => HttpContext.Current.Session[currentDocId] = value;
        }

        public static int RelatedDocId
        {
            get
            {
                int result = -1;
                try
                {
                    if(HttpContext.Current.Session[relatedDocId] != null)
                        result = (int)HttpContext.Current.Session[relatedDocId];
                }
                catch
                {
                    // ignored
                }

                return result;
            }
            set => HttpContext.Current.Session[relatedDocId] = value == -1 ? (int?)null : value;
        }

        public static int AnswerDocId
        {
            get
            {
                int result = -1;
                try
                {
                    if(HttpContext.Current.Session[answerDocId] != null)
                        result = (int)HttpContext.Current.Session[answerDocId];
                }
                catch
                {
                    // ignored
                }

                return result;
            }
            set => HttpContext.Current.Session[answerDocId] = value == -1 ? (int?)null : value;
        }

        public static int DocTypeId
        {
            get
            {
                int result = 0;
                try
                {
                    if(HttpContext.Current.Session[docTypeId] != null)
                        result = (int)HttpContext.Current.Session[docTypeId];
                }
                catch { }
                return result;
            }
            set => HttpContext.Current.Session[docTypeId] = value;
        }

        public static int PeriodId
        {
            get
            {
                int result = 0;
                try
                {
                    if(HttpContext.Current.Session[periodId] != null)
                        result = (int)HttpContext.Current.Session[periodId];
                }
                catch { }
                return result;
            }
            set => HttpContext.Current.Session[periodId] = value;
        }

        public static int DefaultPage
        {
            get
            {
                int defaultPages = -1;
                try
                {
                    if(HttpContext.Current.Session[defaultPage] != null)
                        defaultPages = ((int)HttpContext.Current.Session[defaultPage]);
                }
                catch { }
                return defaultPages;
            }
            set => HttpContext.Current.Session[defaultPage] = value;
        }

        public static int FileInfoId
        {
            get
            {
                int result = 0;
                try
                {
                    if(HttpContext.Current.Session[fileInfoId] != null)
                        result = (int)HttpContext.Current.Session[fileInfoId];
                }
                catch
                {
                    // ignored
                }

                return result;
            }
            set => HttpContext.Current.Session[fileInfoId] = value;
        }

        public static int PositionGroupId
        {
            get
            {
                if(HttpContext.Current.Session[positionGroupId] == null)
                    return -1;
                return (int)HttpContext.Current.Session[positionGroupId];
            }
        }

        public static DOCS_FILEINFO TempFile
        {
            get
            {
                DOCS_FILEINFO result = null;
                try
                {
                    if(HttpContext.Current.Session[tempFile] != null)
                        result = (DOCS_FILEINFO)HttpContext.Current.Session[tempFile];
                }
                catch
                {
                    // ignored
                }

                return result;
            }
            set => HttpContext.Current.Session[tempFile] = value;
        }

        public static DirectionModel DirectionController
        {
            get
            {
                DirectionModel result = null;
                try
                {
                    if(HttpContext.Current.Session[directionController] != null)
                        result = ((DirectionModel)HttpContext.Current.Session[directionController]);
                }
                catch
                {
                    // ignored
                }

                return result;
            }
            set => HttpContext.Current.Session[directionController] = value;
        }

        public static string DefaultLang
        {
            get
            {
                string result = null;
                try
                {
                    if(HttpContext.Current.Session[defaultLang] != null)
                        result = HttpContext.Current.Session[defaultLang].ToString();
                }
                catch
                {
                    // ignored
                }

                return result;
            }
            set => HttpContext.Current.Session[defaultLang] = value;
        }

        public static bool DefaultLeftMenu
        {
            get
            {
                bool result = true;
                try
                {
                    if(HttpContext.Current.Session[defaultLeftMenu] != null)
                        result = (bool)HttpContext.Current.Session[defaultLeftMenu];
                }
                catch
                {
                    // ignored
                }

                return result;
            }
            set => HttpContext.Current.Session[defaultLeftMenu] = value;
        }

        public static int DepartmentTopDepartmentId
        {
            get
            {
                if(HttpContext.Current.Session[departmentTopDepartmentId] == null)
                    return -1;
                return (int)HttpContext.Current.Session[departmentTopDepartmentId];
            }
        }

        public static int DepartmentId
        {
            get
            {
                if(HttpContext.Current.Session[departmentDepartmentId] == null)
                    return -1;
                return (int)HttpContext.Current.Session[departmentDepartmentId];
            }
        }

        public static int DepartmentSectionId
        {
            get
            {
                if(HttpContext.Current.Session[departmentSectionId] == null)
                    return -1;
                return (int)HttpContext.Current.Session[departmentSectionId];
            }
        }

        public static int DepartmentCode
        {
            get
            {
                if (HttpContext.Current.Session[departmentCode] == null)
                    return -1;
                return (int)HttpContext.Current.Session[departmentCode];
            }
        }
        public static int DepartmentSubSectionId
        {
            get
            {
                if(HttpContext.Current.Session[departmentSubSectionId] == null)
                    return -1;
                return (int)HttpContext.Current.Session[departmentSubSectionId];
            }
        }

        public static int AdminPermission
        {
            get
            {
                int result = 0;
                try
                {
                    if(HttpContext.Current.Session[adminPermission] != null)
                        result = (int)HttpContext.Current.Session[adminPermission];
                }
                catch
                {
                    // ignored
                }

                return result;
            }
            set => HttpContext.Current.Session[adminPermission] = value;
        }

        public static int SuperAdminPermission
        {
            get
            {
                int result = 0;
                try
                {
                    if(HttpContext.Current.Session[superAdminPermission] != null)
                        result = (int)HttpContext.Current.Session[superAdminPermission];
                }
                catch
                {
                    // ignored
                }

                return result;
            }
            set => HttpContext.Current.Session[superAdminPermission] = value;
        }

        public static string UserFIN
        {
            get
            {
                string result = null;
                try
                {
                    if(HttpContext.Current.Session[userFIN] != null)
                        result = HttpContext.Current.Session[userFIN].ToString();
                }
                catch
                {
                    // ignored
                }

                return result;
            }
            set => HttpContext.Current.Session[userFIN] = value;
        }

        public static void SetOrganizationInfo(UserModel user)
        {
            HttpContext.Current.Session[organizationId] = user.DepartmentOrganization;
            HttpContext.Current.Session[departmentTopDepartmentId] = user.DepartmentTopDepartmentId;
            HttpContext.Current.Session[departmentDepartmentId] = user.DepartmentId;
            HttpContext.Current.Session[departmentSectionId] = user.DepartmentSectionId;
            HttpContext.Current.Session[departmentSubSectionId] = user.DepartmentSubSectionId;
            HttpContext.Current.Session[departmentCode] = user.DepartmentCode;
        }

        public static void SetOrganizationInfo(WorkplaceModel workplace)
        {
            HttpContext.Current.Session[organizationId] = workplace.WorkplaceOrganizationId;
            HttpContext.Current.Session[departmentTopDepartmentId] = workplace.DepartmentTopDepartmentId;
            HttpContext.Current.Session[departmentDepartmentId] = workplace.WorkplaceDepartmentId;
            HttpContext.Current.Session[departmentSectionId] = workplace.DepartmentSectionId;
            HttpContext.Current.Session[departmentSubSectionId] = workplace.DepartmentSubSectionId;
            HttpContext.Current.Session[departmentCode] = workplace.DepartmentCode;
        }

        public static void SetPersonNew(DcWorkplace workPlace)
        {
            HttpContext.Current.Session[positionId] = workPlace.WorkplaceDepartmentPositionId;
            HttpContext.Current.Session[departmentId] = workPlace.DepartmentId;
            HttpContext.Current.Session[organizationId] = workPlace.WorkplaceOrganizationId;
            HttpContext.Current.Session[departmentTopDepartmentId] = workPlace.DepartmentTopDepartmentId;
            HttpContext.Current.Session[departmentDepartmentId] = workPlace.DepartmentDepartmentId;
            HttpContext.Current.Session[departmentSectionId] = workPlace.DepartmentSectionId;
            HttpContext.Current.Session[departmentSubSectionId] = workPlace.DepartmentSubSectionId;
            HttpContext.Current.Session[positionGroupId] = workPlace.PositionGroupId;
            HttpContext.Current.Session[positionGroupLevel] = workPlace.PositionGroupLevel;
            HttpContext.Current.Session[chiefWorkPlaceId] = workPlace.ChiefWorkplaceId;
        }

        public static string TempUserName
        {
            get
            {
                if (HttpContext.Current.Session[tempUserName] == null)
                    return null;
                return HttpContext.Current.Session[tempUserName].ToString();
            }

            set
            {
                HttpContext.Current.Session[tempUserName] = value;
            }
        }

        public static string TempUserPassword
        {
            get
            {
                if (HttpContext.Current.Session[tempUserPassword] == null)
                    return null;
                return HttpContext.Current.Session[tempUserPassword].ToString();
            }

            set
            {
                HttpContext.Current.Session[tempUserPassword] = value;
            }
        }

        #endregion Public Method
    }
}