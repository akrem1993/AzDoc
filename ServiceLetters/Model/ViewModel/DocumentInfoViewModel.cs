using BLL.Models.DocInfo;
using System;

namespace ServiceLetters.Model.ViewModel
{
    public class DocumentInfoViewModel : BaseDocInfo
    {
        public string OrgName { get; set; }
        public string Description { get; set; }
        public DateTime? DocEnterDate { get; set; }
        public string SignatoryPerson { get; set; }
        public string ConfirmPerson { get; set; }
        public string ToWhomAddress { get; set; }
        public DateTime? DocPlannedDate { get; set; }
        public int DocDocumentStatusId { get; set; }
        public DateTime? DocExecutedDate { get; set; }
        public string DocumentStatusName { get; set; }
        public string Signer { get; set; }
        public string SendTo { get; set; }
        public int? DocResultId { get; set; }
        public int? AnswerRowNumber { get; set; }
        public int? CitizenResultCount { get; set; }
    }
}