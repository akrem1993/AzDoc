using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Model.ModelInterfaces
{
    public interface IRoleFilter : IExecutorInfo
    {

    }

    public interface IExecutorInfo : IDirectionInfo, IDocInfo
    {
        int? ExecutorOrganizationId { get; set; }

        int? ExecutorTopDepartment { get; set; }

        int? ExecutorDepartment { get; set; }

        int? ExecutorSection { get; set; }

        int? ExecutorSubsection { get; set; }

        int ExecutorWorkplaceId { get; set; }

        bool? ExecutorReadStatus { get; set; }

        bool? ExecutorControlStatus { get; set; }
    }

    public interface IDirectionInfo
    {
        int? DirectionCreatorWorkplaceId { get; set; }

        int DirectionTypeId { get; set; }

        DateTime? DirectionInsertedDate { get; set; }
    }

    public interface IDocInfo
    {
        int DocId { get; set; }
        int? DocInsertedById { get; set; }
        int DocOrganizationId { get; set; }
        int? DocPeriodId { get; set; }
    }

}
