using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;
using BLL.Adapters;
using BLL.Models.Document;

namespace BLL.Models.Report
{
    public class ReportsViewModel
    {
        public ChooseModel Menu { get; set; }
        public ChooseModel DocumentStatus { get; set; }
        public ChooseModel ResultOfExecutionModel { get; set; }
        public ChooseModel WhomAddress { get; set; }
        public IEnumerable<ChooseModel> Menus { get; set; }
        public IEnumerable<ChooseModel> DocumentStatuses { get; set; }
        public IEnumerable<ChooseModel> WhomAddresses { get; set; }

        public IEnumerable<ReportModel> ReportModels { get; set; }
        public IEnumerable<ReportForm1Model> ReportForm1Models { get; set; }
        public IEnumerable<ReportForm2Model> ReportForm2Models { get; set; }
        public IEnumerable<ChooseModel> ResultOfExecutionModels { get; set; }
        //public IEnumerable<ReportInExecutionDocsModel> ReportInExecutionDocsModel { get; set; }

        /// <summary>
        ///
        /// </summary>
        /// <param name="adapter"></param>
        /// <param name="docType"></param>
        /// <param name="workPlaceId"></param>
        public ReportsViewModel(ReportAdapter adapter, int workPlaceId)
        {
            var chooseList = adapter.GetChooseModel(null, null, null);
            Menus = chooseList.Where(l => l.FormTypeId == 1);
            DocumentStatuses = chooseList.Where(l => l.FormTypeId == 2);
            ResultOfExecutionModels = chooseList.Where(l => l.FormTypeId == 4);

            WhomAddresses = chooseList.Where(l => l.FormTypeId == 7);



            //ReportInExecutionDocsModel = adapter.GetReportInExecutionDocsModels(workPlaceId);
        }

        public ReportsViewModel(ReportAdapter adapter, int workPlaceId, DateTime? beginDate, DateTime? endDate, int? docTypeId, int? documentStatus, int? resultOfExecution)
        {
            var chooseList = adapter.GetChooseModel(null, null, null);
            Menus = chooseList.Where(l => l.FormTypeId == 1);
            DocumentStatuses = chooseList.Where(l => l.FormTypeId == 2);
            ResultOfExecutionModels = chooseList.Where(l => l.FormTypeId == 4);
            ReportModels = adapter.GetReportModel(workPlaceId, beginDate, endDate, docTypeId, documentStatus, resultOfExecution);
        }

        public ReportsViewModel(ReportAdapter adapter, int workPlaceId, DateTime? beginDate, DateTime? endDate, int reportId)
        {
            if (reportId == 2)
            {
                ReportForm1Models = adapter.GetReportForm1Model(workPlaceId, beginDate, endDate);
            }
            else
            {
                ReportForm2Models = adapter.GetReportForm2Model(workPlaceId, beginDate, endDate);
            }

        }

        public ReportsViewModel()
        {

        }
    }


}
