using BLL.Adapters;
using BLL.Common.Enums;
using Model.DB_Views;
using ORM.Context;
using Repository.UnitOfWork;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web.Configuration;

namespace AzDoc.Helpers
{
    public static class Permissions
    {
        private static readonly bool usePermission;

        static Permissions()
        {
            usePermission = false;
            Configuration rootWebConfig1 = WebConfigurationManager.OpenWebConfiguration("/");
            if (rootWebConfig1.AppSettings.Settings.Count > 0)
            {
                KeyValueConfigurationElement permission = rootWebConfig1.AppSettings.Settings["UsePermissions"];
                usePermission = bool.Parse(permission.Value);
            }
        }


        //public static IEnumerable<RightType> GetAll(params RightType[] rights)
        //{
        //    if (rights == null || !rights.Any() || !usePermission) return null;

        //    using (var unitOfWork = new EFUnitOfWork<DMSContext>())
        //    using (var adapter = new PermissionAdapter(unitOfWork))
        //    {
        //        var rightsValues = Array.ConvertAll(rights, value => (int)value);

        //        var rightsId = adapter.GetPermissions(SessionHelper.WorkPlaceId, rightsValues, SessionHelper.DocTypeId);

        //        var rightsEnum = Array.ConvertAll(rightsId.ToArray(), x => (RightType)x);

        //        return rightsEnum;
        //    }
        //}

        //public static IEnumerable<RightType> GetAll(params int[] rights)
        //{
        //    if (rights == null || !rights.Any() || !usePermission) return null;

        //    using (var unitOfWork = new EFUnitOfWork<DMSContext>())
        //    using (var adapter = new PermissionAdapter(unitOfWork))
        //    {
        //        var rightsId = adapter.GetPermissions(SessionHelper.WorkPlaceId, rights, SessionHelper.DocTypeId);

        //        var rightsEnum = Array.ConvertAll(rightsId.ToArray(), x => (RightType)x);

        //        return rightsEnum;
        //    }
        //}

        public static bool Has(this IEnumerable<RightType> rights, RightType right)
        {
            if (!usePermission) return true;

            if (rights != null && rights.Any())
            {
                return rights.Contains(right);
            }

            return false;
        }

        public static IEnumerable<RightType> GetAll(params RightType[] rights)
        {
            if (rights == null || !rights.Any() || !usePermission) return null;

            var rightsValues = Array.ConvertAll(rights, value => (int)value);

            var rightsId = SessionHelper.Roles.Where(x =>
                x.OperationParameter == SessionHelper.DocTypeId.ToString()
                && rightsValues.Contains(x.RightTypeId));

            var rightsEnum = Array.ConvertAll(rightsId.ToArray(), x => (RightType)x.RightTypeId);

            return rightsEnum;
        }

        public static bool Get(RightType right)
        {
            if (!usePermission) return true;

            if (right == RightType.None) return false;

            var rights = SessionHelper.Roles.Where(x => (int)right == x.RightTypeId);

            return rights.Count() > 0;
        }

        public static bool Get(RightType right, DocType docType)
        {
            if (!usePermission) return true;

            if (right == RightType.None) return false;

            var rights = SessionHelper.Roles.Where(x =>
                x.OperationParameter == ((int)docType).ToString()
                && (int)right == x.RightTypeId);

            return rights.Count() > 0;
        }

        public static bool GetRightByWorkPlace(RightType right, int workPlaceId)
        {
            if (!usePermission) return true;

            if (right == RightType.None) return false;

            using (var unitOfWork = new EFUnitOfWork<DMSContext>())
            {
                var rights = unitOfWork.GetRepository<VW_ROLES>()
                    .GetAll(x => x.WorkplaceId == workPlaceId
                                 && x.RightTypeId == (int)right)
                    .ToList();

                return rights.Count > 0;
            }
        }

        public static bool GetRightByWorkPlace(RightType right, DocType docType, int workPlaceId)
        {
            if (!usePermission) return true;

            if (right == RightType.None) return false;

            using (var unitOfWork = new EFUnitOfWork<DMSContext>())
            {
                var rights = unitOfWork.GetRepository<VW_ROLES>()
                    .GetAll(x => x.WorkplaceId == workPlaceId
                                 && x.RightTypeId == (int)right
                                 && x.OperationParameter == ((int)docType).ToString())
                    .ToList();

                return rights.Count > 0;
            }
        }

    }
}