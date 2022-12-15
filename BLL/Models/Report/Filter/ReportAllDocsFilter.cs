using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BLL.Models.Report.Filter
{
    public class ReportAllDocsFilter
    {
        public int docTypeId { get; set; } = 2;
        public int executorOrganizationType { get; set; } = 1;
        public int? organizationDepartmentOrOrganizations { get; set; }
        public DateTime? beginDate { get; set; }
        public DateTime? endDate { get; set; }
        public int? topicType { get; set; }
        public int? topicTypeEmployee { get; set; }
        public int? topic { get; set; }
        public int? regions { get; set; }
        public int? villages { get; set; }
        public int? socialStatusId { get; set; }
        public int? docFormId { get; set; }
        public int? docFormIdOutgoing { get; set; }
        public int? docResult { get; set; }
        public int? docApplyType { get; set; }
        public int? docDocumentStatus { get; set; }
        public int? complainedOfDocStructure { get; set; }
        public int? complainedOfDocSubStructure { get; set; }
        public int? docControlStatus { get; set; }
        public int? docControlStatusStructures { get; set; }
        public int entryFromWhere { get; set; } = -1;
        public string currentPage { get; set; } = System.Web.HttpContext.Current.Request.QueryString["page"];
        public int? outgoingSigner { get; set; }
        public int? outgoingWhomAddressed { get; set; }
        public int? outgoingOrganization { get; set; }
        public string outgoingPerson { get; set; }

    }
}
