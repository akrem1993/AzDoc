using System;

namespace BLL.Models.DocInfo
{
    public class DocHistory
    {
        public string PersonFrom { get; set; }
        public string PersonTo { get; set; }


        public string OperationTypeName { get; set; }
        public DateTime OperationDate { get; set; }

        public string OperationStatusName { get; set; }
        public DateTime? OperationStatusDate { get; set; }

        public string OperationNote { get; set; }

        public int SendStatusId { get; set; }

        public string DirectionChangeStatus { get; set; }
        public DateTime? NewDirectionPlannedDate { get; set; }
    }
}
