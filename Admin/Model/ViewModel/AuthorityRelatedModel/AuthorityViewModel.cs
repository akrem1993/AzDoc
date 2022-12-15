using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Admin.Model.ViewModel.AuthorityRelatedModel
{
    public class AuthorityViewModel
    {
        public int AuthorityId { get; set; }
        public string TransferredFromPerson { get; set; }
        public string TransferredToPerson { get; set; }
        public  string TransferReason { get; set; }
        public string BeginDate { get; set; }
        public string EndDate { get; set; }
        public string TransferNote { get; set; }
        public string AuthorityStatus { get; set; }
    }
}
