using BLL.Adapters;
using BLL.Models.Document;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BLL.Models.Report
{
    public class ReportDropDownModel
    {
        //public DropDownModel Department { get; set; }
        public IEnumerable<DropDownModel> DropDownModel { get; set; }

        public IEnumerable<AgencyModel> AgencyModel { get; set; }

        public ReportDropDownModel(ReportAdapter adapter, int executorOrganizationId, int workPlaceId, int executorOrganizationType)
        {
            DropDownModel = new List<DropDownModel>();
            AgencyModel = new List<AgencyModel>();
            DropDownModel = adapter.GetReportDropDown(executorOrganizationId, workPlaceId, executorOrganizationType);
            AgencyModel = adapter.GetReportAgencyModel();
        }
        public ReportDropDownModel()
        {

        }

    }
    public class DropDownModel
    {
        public int FormType { get; set; }
        public int Id { get; set; }
        public int? TopId { get; set; }
        public string Name { get; set; }
    }
    public class AgencyModel
    {
        public int AgencyId { get; set; }
        public string AgencyName { get; set; }
        public int? AgencyTopId { get; set; }
        public int? AgencyOrganizationId { get; set; }
        public int? TopicTypeId { get; set; }
    }
}

//da.AgencyId,
//	da.AgencyName,
//	da.AgencyTopId,
//	da.AgencyOrganizationId,
//	dsa.TopicTypeId