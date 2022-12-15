using BLL.Adapters;
using BLL.Models.Report.Filter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BLL.Models.Report
{
    public class ReportForInformationDocsBodyViewModel
    {
        public IEnumerable<ReportForInformationDocsModel> ForInformationDocs { get; set; }
        public Paging.Pager Pager { get; set; }

        public ReportForInformationDocsBodyViewModel(ReportAdapter adapter, int executorOrganizationId, int workPlaceId,
            ReportForInformationDocsFilter reportForInformationDocsFilter, int _CurrentPage)
        {
            int pageSize = 30;
            int totalItems = 0;
            int totalPages = 0;

            ForInformationDocs = adapter.GetReportForInformationDocsModelsDocs(executorOrganizationId, workPlaceId,
                reportForInformationDocsFilter, out totalItems,
                out totalPages, pageSize, _CurrentPage);

            Pager = new Paging.Pager(totalItems, _CurrentPage, pageSize);
        }

        #region Excell

        public ReportForInformationDocsBodyViewModel(ReportAdapter adapter, int executorOrganizationId, int workPlaceId,
            ReportForInformationDocsFilter reportForInformationDocsFilter)
        {
            ForInformationDocs = adapter.GetReportForInformationDocsForExcell(executorOrganizationId, workPlaceId,
                reportForInformationDocsFilter);
        }

        #endregion

        public ReportForInformationDocsBodyViewModel()
        {
        }
    }
}