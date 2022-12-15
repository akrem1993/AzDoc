using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BLL.Models.Report.Filter
{
    public class ReportInExecutionDocsFilter
    {

        public int? docTypeId { get; set; }

        public int executorOrganizationType { get; set; } = 1;

        public int? organizationDepartmentOrOrganizations { get; set; }

        public int remaningDay { get; set; }
         
        public DateTime? beginDate { get; set; }
        public DateTime? endDate { get; set; }

        public int? topicType { get; set; }
        public int? topicTypeEmployee { get; set; }
        public int? topic { get; set; }
        public int? regions { get; set; }
        public int? villages { get; set; }
        public int? socialStatusId { get; set; } 
        public int? docFormId { get; set; }
        public string entryFromWhere { get; set; }
        public string entryFromWhoCitizenName { get; set; }
        public string entryFromWho { get; set; }  
        public int? executor { get; set; }
        public int? docStatus { get; set; }
        public int? docResult { get; set; } //Leyla


        public int docControlStatus { get; set; } = -1;
        public int docControlStatusStructures { get; set; } = -1;

        public int? docApplyType { get; set; }

        public int? complainedOfDocStructure { get; set; }
        public int? complainedOfDocSubStructure { get; set; }

        public string currentPage { get; set; } = System.Web.HttpContext.Current.Request.QueryString["page"];
    }
}
