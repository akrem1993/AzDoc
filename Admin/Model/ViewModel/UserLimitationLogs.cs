using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Admin.Model.ViewModel
{
    public class UserLimitationLogs
    {
        public string UserName { get; set; }
        public string OperationNote { get; set; }
        public string OrganizationShortname { get; set; }

        public string UpdatedDate { get; set; }
    }
}
