using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OutgoingDoc.Model.EntityModel
{
    public class TaskModel
    {
        public int TaskId { get; set; }
        public string TaskDocNo { get; set; }
        public string TypeOfAssignment { get; set; }
        public decimal TaskNo { get; set; }
        public string Task { get; set; }
        public int? TaskCycle { get; set; }
        public string TaskCycleName { get; set; }
        public int? ExecutionPeriod { get; set; }
        public int? PeriodOfPerformance { get; set; }
        public DateTime? OriginalExecutionDate { get; set; }
        public string WhomAddress { get; set; }
    }
}
