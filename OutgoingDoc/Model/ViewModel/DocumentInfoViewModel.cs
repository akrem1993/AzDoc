using BLL.Models.DocInfo;
using System;

namespace OutgoingDoc.Model.ViewModel
{
    public class DocumentInfoViewModel : BaseDocInfo
    {
        public string OrgName { get; set; }
        public string Description { get; set; }
        public DateTime? DocEnterDate { get; set; }
        public string DocDocNo { get; set; }
        public DateTime? DocDocDate { get; set; }
        public string SignatoryPerson { get; set; }
        public string FormName { get; set; }
        public int DocDocumentStatusId { get; set; }
        public string DocumentStatusName { get; set; }
        public string Signer { get; set; }
        public int? DocResultId { get; set; }
        public string SendForm { get; set; }
        public string DocumentKind { get; set; }
        public string SendTo { get; set; }
        public string ConfirmPerson { get; set; }
        public string WhomAddress { get; set; }
        public string SentAddress { get; set; }

    }

}
