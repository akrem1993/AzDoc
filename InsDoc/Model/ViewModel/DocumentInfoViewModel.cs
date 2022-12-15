using BLL.Models.DocInfo;
using System;

namespace InsDoc.Model.ViewModel
{
    public class DocumentInfoViewModel : BaseDocInfo, ITaskModel
    {
        public string OrgName { get; set; }
        public string Description { get; set; }
        public DateTime? DocEnterDate { get; set; }
        public string DocDocNo { get; set; }
        public DateTime? DocDocDate { get; set; }
        public string SignatoryPerson { get; set; }
        public string ConfirmPerson { get; set; }
        public string FormName { get; set; }
        public int DocDocumentStatusId { get; set; }
        public string DocumentStatusName { get; set; }
        public string Signer { get; set; }
        public string SendTo { get; set; }
        public string RedirectedPersons { get; set; }

        public bool IsTask { get; set; }
        public int? TaskBaseDocId { get; set; }
        public string TaskBaseDocFormName { get; set; }
        public string TaskBaseDocEnterNo { get; set; }
        public string TaskBaseDocDescription { get; set; }
        public DateTime? TaskExecutionDate { get; set; }
    }

}