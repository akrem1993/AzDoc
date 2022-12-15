using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BLL.Models.Report.Filter
{
    public class ReportCitizenFilter
    {
        public int docTypeId { get; set; } = 2;
        public int executorOrganizationType { get; set; } = 1;
        public int? organizationDepartmentOrOrganizations { get; set; }
        public DateTime? beginDate { get; set; }
        public DateTime? endDate { get; set; }
        public int? topicType { get; set; }
        public int? topic { get; set; }
        public int? socialStatusId { get; set; }
        public int? docFormId { get; set; }
        public int? docResult { get; set; }
        public int? docDocumentStatus { get; set; }

        //     public int remaningDay { get; set; }
        //     public int? executor { get; set; }
        //     public int docControlStatus { get; set; } = -1;
        //     public int docControlStatusStructures { get; set; } = -1;

        public string currentPage { get; set; } = System.Web.HttpContext.Current.Request.QueryString["page"];
    }
}
