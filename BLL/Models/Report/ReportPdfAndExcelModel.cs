using BLL.Adapters;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BLL.Models.Report
{
    public class ReportPdfModel
    {
        public ReportPdfHeading ReportPdf { get; set; }
        public ReportPdfModel()
        {

        }
        public ReportPdfModel(ReportAdapter adapter,int organizationId,int executorOrganizationType, int? organizationDepartmentOrOrganizations)
        {
            ReportPdf=adapter.GetReportHeading(organizationId, executorOrganizationType, organizationDepartmentOrOrganizations);
        }
    }
}
