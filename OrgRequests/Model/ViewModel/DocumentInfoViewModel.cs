using BLL.Models.DocInfo;
using System;

namespace OrgRequests.Model.ViewModel
{
    public class DocumentInfoViewModel : BaseDocInfo, ITaskModel
    {
        public string OrganizationName { get; set; }
        public string ModuleName { get; set; }
        public string RegisterNumber { get; set; }
        public DateTime? RegisterDate { get; set; }
        public string DocumentNumber { get; set; }
        public DateTime? DocumentDate { get; set; }
        public string EntryFromWhere { get; set; }
        public string ExecuteRule { get; set; }
        public DateTime? DocExecutedDate { get; set; }
        public int? ExecutionStatusId { get; set; }
        public string EntryFromWho { get; set; }

        public DateTime? ExecDuration { get; set; }
        public string SendToWhere { get; set; }
        public string DocumentKind { get; set; }
        public string SendToWho { get; set; }
        public string EntryForm { get; set; }
        public string Subject { get; set; }

        public string NewPlannedDateHistory { get; set; }


        public int DocDocumentStatusId { get; set; }
        public int? DocDuplicateId { get; set; }
        public byte? SupervisionId { get; set; }


        public bool IsTask { get; set; }
        public int? TaskBaseDocId { get; set; }
        public string TaskBaseDocFormName { get; set; }
        public string TaskBaseDocEnterNo { get; set; }
        public string TaskBaseDocDescription { get; set; }
        public DateTime? TaskExecutionDate { get; set; }
    }

}