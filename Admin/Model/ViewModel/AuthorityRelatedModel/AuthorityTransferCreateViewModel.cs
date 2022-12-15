using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CustomHelpers;

namespace Admin.Model.ViewModel.AuthorityRelatedModel
{
    public class AuthorityTransferCreateViewModel
    {

        public int  AuthorityId { get; set; }
        public int TransferredFromPerson { get; set; }
        public int TransferredToPerson { get; set; }
        public int TransferReason { get; set; }

        public DateTime BeginDate { get; set; }
        public DateTime EndDate { get; set; }
        public string TransferNote { get; set; }
        public int AuthorityStatus { get; set; }
    }
}
