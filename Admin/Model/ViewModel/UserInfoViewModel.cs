using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Admin.Model.EntityModel;

namespace Admin.Model.ViewModel
{
    public class UserInfoViewModel
    {
        private DateTime? personnelBirthdate;
        public string PersonnelName { get; set; }
        public string PersonnelSurname { get; set; }
        public string PersonnelLastname { get; set; }

        public DateTime? PersonnelBirthdate
        {
            get => personnelBirthdate;
            set => personnelBirthdate = value;
        }

        public string SexName { get; set; }
        public string PersonnelPhone { get; set; }
        public string PersonnelEmail { get; set; }
        public string PersonnelMobile { get; set; }

        public IEnumerable<UserWorkPlaceModel> JsonWorkPlace { get; set; }
    }
}
