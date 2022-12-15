using System.ComponentModel.DataAnnotations;

namespace ColleagueRequests.Model.EntityModel
{
    public class ExecutorModel
    {
        [Key]
        public int ExecutorId { get; set; }

        public int ExecutorDirectionId { get; set; }

        public int ExecutorDocId { get; set; }

        public int ExecutorWorkplaceId { get; set; }

        public string ExecutorFullName { get; set; }

        public byte ExecutorMain { get; set; }

        public int? DirectionTypeId { get; set; }

        public int? ExecutorOrganizationId { get; set; }

        public int? ExecutorTopDepartment { get; set; }

        public int? ExecutorDepartment { get; set; }

        public int? ExecutorSection { get; set; }

        public int? ExecutorSubsection { get; set; }

        public int? ExecutorStepId { get; set; }

        public int? ExecutionstatusId { get; set; }

        public string ExecutorNote { get; set; }

        public bool ExecutorReadStatus { get; set; }

        public string ExecutorResolutionNote { get; set; }

        public int? SendStatusId { get; set; }
    }
}