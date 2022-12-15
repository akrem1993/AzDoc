namespace DMSModel
{
    using Model.Entity;
    using System.ComponentModel.DataAnnotations;

    public partial class DOCS_EXECUTOR : BaseEntity
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

        public virtual VW_DOCUMENTINFO VW_DOCUMENTINFO { get; set; }

        public virtual DOCS_DIRECTIONS DOCS_DIRECTIONS { get; set; }

        public virtual DOC_EXECUTIONSTATUS DOC_EXECUTIONSTATUS { get; set; }

        public virtual DC_WORKPLACE DC_WORKPLACE { get; set; }

        public virtual DOC_SENDSTATUS DOC_SENDSTATUS { get; set; }

        public override int GetHashCode()
        {
            return ExecutorId;
        }

        public override bool Equals(object obj)
        {
            return obj is DOCS_EXECUTOR && Equals((DOCS_EXECUTOR)obj);
        }

        public bool Equals(DOCS_EXECUTOR p)
        {
            return ExecutorId == p.ExecutorId;
        }
    }
}