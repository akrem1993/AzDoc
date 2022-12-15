using System;

namespace Admin.Model.ViewModel.AuthorityRelatedModel
{
    public class AuthorityTransferInfo
    {
        public int AuthorityId { get; set; }
        public int TransferredFromPerson { get; set; }
        public int TransferredToPerson { get; set; }
        public int TransferredReason { get; set; }
        public DateTime BeginDate { get; set; }
        public DateTime EndDate { get; set; }
        public string TransferNote { get; set; }
        public int AuthorityStatus { get; set; }
    }
}