using AzDoc.Helpers;
using BLL.Common.Enums;
using LinqKit;
using Model.DB_Views;
using Model.ModelInterfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;

namespace AzDoc.ModelFilters
{
    public static class RoleFilter
    {
        private static int OrganizationId => SessionHelper.OrganizationId;
        private static int WorkPlaceId => SessionHelper.WorkPlaceId;
        private static int DepartmentTopDepartmentId => SessionHelper.DepartmentTopDepartmentId == -1 ? -2 : SessionHelper.DepartmentTopDepartmentId;
        private static int DepartmentId => SessionHelper.DepartmentId == -1 ? -2 : SessionHelper.DepartmentId;
        private static int DepartmentSectionId => SessionHelper.DepartmentSectionId == -1 ? -2 : SessionHelper.DepartmentSectionId;
        private static int DepartmentSubSectionId => SessionHelper.DepartmentSubSectionId == -1 ? -2 : SessionHelper.DepartmentSubSectionId;

        public static Expression<Func<T, bool>> FilterFor<T>() where T : class, IRoleFilter
        {
            string docTypeId = GetDocTypeId<T>();

            var roles = SessionHelper.Roles.Where(x => x.OperationParameter == docTypeId && x.RightTypeId == (int)RightType.View);

            if (roles.Count() == 0) return x => false;

            if (roles.Any(x => x.RightId == (int)Right.AllDocument))
            {
                return x => x.DocOrganizationId == OrganizationId
                            || x.ExecutorWorkplaceId == WorkPlaceId
                            || x.ExecutorOrganizationId == OrganizationId;
            }

            var filter = FilterDocsByCreating<T>(roles);

            filter = filter.Or(FilterDocsBySending<T>(roles));

            if (roles.Any(x => x.RightId == (int)Right.CreatePersonelDocument))
            {
                filter = filter.Or(x => x.DocInsertedById == WorkPlaceId);
            }

            return filter.And(x => x.DocOrganizationId == OrganizationId);
        }

        private static Expression<Func<T, bool>> FilterDocsByCreating<T>(this IEnumerable<VW_ROLES> roles) where T : class, IRoleFilter
        {
            var predicate = PredicateBuilder.New<T>();

            if (roles.Any(x => x.RightId == (int)Right.CreateTopDepartament))
            {
                predicate = predicate.Or(x =>
                    x.ExecutorTopDepartment == DepartmentTopDepartmentId && x.DirectionTypeId == 4);
            }
            else
            {
                if (roles.Any(x => x.RightId == (int)Right.CreateDepartament))
                {
                    predicate = predicate.Or(x => x.ExecutorDepartment == DepartmentId && x.DirectionTypeId == 4);
                }
                else
                {
                    if (roles.Any(x => x.RightId == (int)Right.CreateSection))
                    {
                        predicate = predicate.Or(x => x.ExecutorSection == DepartmentSectionId && x.DirectionTypeId == 4);
                    }
                    else
                    {
                        if (roles.Any(x => x.RightId == (int)Right.CreateSector))
                        {
                            predicate = predicate.Or(x => x.ExecutorSubsection == DepartmentSubSectionId && x.DirectionTypeId == 4);
                        }
                    }
                }
            }

            return predicate;
        }

        private static Expression<Func<T, bool>> FilterDocsBySending<T>(this IEnumerable<VW_ROLES> roles) where T : class, IRoleFilter
        {
            var predicate = PredicateBuilder.New<T>();

            if (roles.Any(x => x.RightId == (int)Right.SendTopDepartament))
            {
                predicate = predicate.Or(x => x.ExecutorTopDepartment == DepartmentTopDepartmentId && x.DirectionTypeId != 4);
            }
            else
            {
                if (roles.Any(x => x.RightId == (int)Right.SendToPerson))
                {
                    predicate = predicate.Or(x => x.ExecutorDepartment == DepartmentId && x.DirectionTypeId != 4);
                }

                if (roles.Any(x => x.RightId == (int)Right.SendDepartament))
                {
                    predicate = predicate.Or(x => x.ExecutorDepartment == DepartmentId && x.DirectionTypeId != 4);
                }
                else
                {
                    if (roles.Any(x => x.RightId == (int)Right.SendSection))
                    {
                        predicate = predicate.Or(x => x.ExecutorSection == DepartmentSectionId && x.DirectionTypeId != 4);
                    }
                    else
                    {
                        if (roles.Any(x => x.RightId == (int)Right.SendSector))
                        {
                            predicate = predicate.Or(x => x.ExecutorSubsection == DepartmentSubSectionId && x.DirectionTypeId != 4);
                        }
                    }
                }
            }

            return predicate;
        }

        private static string GetDocTypeId<T>() where T : class, IRoleFilter
        {
            var type = typeof(T).GetInterfaces();

            if (type.Contains(typeof(IServiceLetter)))
            {
                return ((int)DocType.ServiceLetters).ToString();
            }

            if (type.Contains(typeof(IOrgRequests)))
            {
                return ((int)DocType.OrgRequests).ToString();
            }

            if (type.Contains(typeof(ICitizenRequests)))
            {
                return ((int)DocType.CitizenRequests).ToString();
            }

            if (type.Contains(typeof(IOutGoing)))
            {
                return ((int)DocType.OutGoing).ToString();
            }

            return string.Empty;
        }
    }
}