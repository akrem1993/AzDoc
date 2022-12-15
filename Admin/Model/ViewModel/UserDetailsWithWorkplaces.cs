using Admin.Model.EntityModel;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Admin.Model.ViewModel
{
    public class UserDetailsWithWorkplaces
    {
        public int UserId { get; set; }        
        public string PersonnelName { get; set; }

        public string UserName { get; set; }
        public string Password { get; set; }
        public bool UserStatus { get; set; }
        public string PersonnelSurname { get; set; }
        public string PersonnelLastname { get; set; }


        public DateTime? PersonnelBirthdate { get; set; }
        public string PersonnelBirthdate1 { get; set; }
        public int PersonnelSexId { get; set; }
        public string PersonnelPhone { get; set; }
        public string PersonnelEmail { get; set; }
        public string PersonnelMobile { get; set; }
        public string UserFin { get; set; }

        public List<UserWorkPlace> JsonWorkPlace { get; set; }

    }
}
