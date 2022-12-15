using Admin.Model.EntityModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Admin.Model.FormModel
{
    public class CreateUserModel
    {

        public string PersonnelName { get; set; }
        public string PersonnelSurname { get; set; }
        public string PersonnelLastname { get; set; }

        public string PersonnelBirthdate { get; set; }

        public string SexName { get; set; }
        public string PersonnelPhone { get; set; }
        public string PersonnelEmail { get; set; }
        public string PersonnelMobile { get; set; }

        public List<UserWorkPlaceModel> Workplace { get; set; }
    }
}
