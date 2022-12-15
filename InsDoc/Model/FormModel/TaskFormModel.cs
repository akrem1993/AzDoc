using System;

namespace InsDoc.Model.FormModel
{
    public class TaskFormModel
    {
        public int TypeOfAssignment { get; set; }
        public decimal TaskNo { get; set; }
        public string Task { get; set; }
        public int? TaskCycle { get; set; }
        public int? ExecutionPeriod { get; set; }
        public int? PeriodOfPerformance { get; set; }
        public DateTime? OriginalExecutionDate { get; set; }
        public int WhomAddressId { get; set; }
    }
}