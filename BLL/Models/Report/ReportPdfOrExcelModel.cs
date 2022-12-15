using BLL.Adapters;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BLL.Models.Report
{
    public class ReportPdfOrExcelModel
    {
        public ReportPdfHeading ReportPdf { get; set; }
        public ReportPdfOrExcelModel()
        {

        }
        public ReportPdfOrExcelModel(ReportAdapter adapter,int organizationId,int executorOrganizationType, int? organizationDepartmentOrOrganizations)
        {
            ReportPdf=adapter.GetReportHeading(organizationId, executorOrganizationType, organizationDepartmentOrOrganizations);
        }
    }
}
