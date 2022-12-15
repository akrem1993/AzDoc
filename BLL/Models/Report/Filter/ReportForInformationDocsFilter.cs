using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace BLL.Models.Report.Filter
{
    public class ReportForInformationDocsFilter
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
        public int? docApplyType { get; set; }
        public int? docDocumentStatus { get; set; }
        public int? complainedOfDocStructure { get; set; }
        public int? complainedOfDocSubStructure { get; set; }
        public int? docControlStatus { get; set; }
        public int? docControlStatusStructures { get; set; }
        public int entryFromWhere { get; set; } = -1;
        public string currentPage { get; set; } = System.Web.HttpContext.Current.Request.QueryString["page"];
    }
}