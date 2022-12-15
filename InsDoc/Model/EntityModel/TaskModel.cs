using System;

namespace InsDoc.Model.EntityModel
{
    public class TaskModel
    {
        public int TaskId { get; set; }
        public string TaskDocNo { get; set; }
        public string TypeOfAssignment { get; set; }
        public string TaskNo { get; set; }
        public string Task { get; set; }
        public int? TaskCycleId { get; set; }
        public string TaskCycleName { get; set; }
        public int? ExecutionPeriod { get; set; }
        public int? PeriodOfPerformance { get; set; }
        public DateTime? OriginalExecutionDate { get; set; }
        public string WhomAddress { get; set; }
        public int TaskRelatedDocId { get; set; }
        public int TaskGroup { get; set; }
        public DateTime? NextPeriodDate { get; set; }

        public string TaskRelatedDocStatus { get; set; }
    }
}