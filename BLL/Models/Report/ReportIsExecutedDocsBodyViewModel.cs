using BLL.Adapters;
using BLL.Models.Report.Filter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BLL.Models.Report
{
    public class ReportIsExecutedDocsBodyViewModel
    {
        public IEnumerable<ReportIsExecutedDocsModel> IsExecutedDocs { get; set; }
        public Paging.Pager Pager { get; set; }

        public ReportIsExecutedDocsBodyViewModel(ReportAdapter adapter, int executorOrganizationId, int workPlaceId, ReportIsExecutedDocsFilter reportIsExecutedDocsFilter, int _CurrentPage)
        {
            int pageSize = 30;
            int totalItems = 0;
            int totalPages = 0;

            IsExecutedDocs = adapter.GetReportIsExecutedDocs(executorOrganizationId, workPlaceId, reportIsExecutedDocsFilter, out totalItems, out totalPages, pageSize, _CurrentPage);

            Pager = new Paging.Pager(totalItems, _CurrentPage, pageSize);
        }

        #region Excell
        public ReportIsExecutedDocsBodyViewModel(ReportAdapter adapter, int executorOrganizationId, int workPlaceId, ReportIsExecutedDocsFilter reportIsExecutedDocsFilter)
        {
            IsExecutedDocs = adapter.GetReportIsExecutedDocsForExcell(executorOrganizationId, workPlaceId, reportIsExecutedDocsFilter);
        }
        #endregion

        public ReportIsExecutedDocsBodyViewModel()
        {
            IsExecutedDocs = new List<ReportIsExecutedDocsModel>();
        }
    }
}
