using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using BLL.Adapters;
using BLL.Models.Direction;
using BLL.Models.Document;
using BLL.Models.Document.EntityModel;

namespace BLL.Models.Report
{
    public class DashboardViewModel
    {
        public ChooseModel Menu { get; set; }
        public IEnumerable<ChooseModel> Menus { get; set; }
        public IEnumerable<ChooseModel> MenuNames { get; set; }
        public IEnumerable<ChooseModel> DashboardsBar { get; set; }
        public IEnumerable<ChooseModel> DashboardsPie { get; set; }

        /// <summary>
        ///
        /// </summary>
        /// <param name="adapter"></param>
        /// <param name="docType"></param>
        /// <param name="workPlaceId"></param>
        public DashboardViewModel(ReportAdapter adapter, int? docType, int? workPlaceId)
        {
            var chooseList = adapter.GetChooseModel(docType, workPlaceId);
            MenuNames = chooseList.Where(l => l.FormTypeId == 1);
            Menus = chooseList.Where(l => l.FormTypeId == 2);
            DashboardsBar = chooseList.Where(l => l.FormTypeId == 3);
            DashboardsPie = chooseList.Where(l => l.FormTypeId == 4);
            Menu= new ChooseModel();
        }
    }

    
}
