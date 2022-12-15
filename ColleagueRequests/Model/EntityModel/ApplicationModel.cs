using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ColleagueRequests.Model.EntityModel
{
    public class ApplicationModel
    {
        public int? AppId { get; set; }
        public string DocEnterno { get; set; }
        public string AppFirstname { get; set; }
        public string AppSurname { get; set; }
        public string AppLastName { get; set; }
        public int AppCountryId { get; set; }
        public int AppRegionId { get; set; }
        public int? AppVillageId { get; set; }
        public string AppSosialStatusId { get; set; }
        public int AppRepresenterId { get; set; }
        public string AppAddress { get; set; }
        public string AppPhone { get; set; }
        public string AppEmail { get; set; }
        public int? AppFormType { get; set; }
    }
}
