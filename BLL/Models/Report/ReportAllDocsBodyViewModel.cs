using BLL.Adapters;
using BLL.Models.Report.Filter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BLL.Models.Report
{
    public class ReportAllDocsBodyViewModel
    {
        public IEnumerable<ReportAllDocsModel> AllDocs { get; set; }
        public Paging.Pager Pager { get; set; }

        public ReportAllDocsBodyViewModel(ReportAdapter adapter, int executorOrganizationId, int workPlaceId, ReportAllDocsFilter reportAllDocsFilter, int _CurrentPage)
        {
            int pageSize = 30;
            int totalItems = 0;
            int totalPages = 0;

            AllDocs = adapter.GetReportAllDocs(executorOrganizationId, workPlaceId, reportAllDocsFilter, out totalItems, out totalPages, pageSize, _CurrentPage);

            Pager = new Paging.Pager(totalItems, _CurrentPage, pageSize);
        }
        #region Excell
        public ReportAllDocsBodyViewModel(ReportAdapter adapter, int executorOrganizationId, int workPlaceId, ReportAllDocsFilter reportAllDocsFilter)
        {
            AllDocs = adapter.GetReportAllDocsForExcell(executorOrganizationId, workPlaceId, reportAllDocsFilter);
        }
        #endregion

        public ReportAllDocsBodyViewModel()
        {

        }



        //public ReportInExecutionDocsBodyViewModel(ReportAdapter adapter, int executorOrganizationId, int workPlaceId, ReportInExecutionDocsFilter reportInExecutionDocsFilter, int _CurrentPage)
        //{
        //    int pageSize = 30;
        //    int totalItems = 0;
        //    int totalPages = 0;


        //    ReportInExecutionDocsModel = adapter.GetReportInExecutionDocsModels(executorOrganizationId, workPlaceId, reportInExecutionDocsFilter, out totalItems, out totalPages, pageSize, _CurrentPage);

        //    Pager = new Paging.Pager(totalItems, _CurrentPage, pageSize);
        //}

        //#region Excell or pdf
        //public ReportInExecutionDocsBodyViewModel(ReportAdapter adapter, int executorOrganizationId, int workPlaceId, ReportInExecutionDocsFilter reportInExecutionDocsFilter)
        //{
        //    ReportInExecutionDocsModel = adapter.GetReportInExecutionDocsModelsForExcellOrPdf(executorOrganizationId, workPlaceId, reportInExecutionDocsFilter);
        //}
        //#endregion

        //public ReportInExecutionDocsBodyViewModel()
        //{
        //    ReportInExecutionDocsModel = new List<ReportInExecutionDocsModel>();
        //}
    }
}
