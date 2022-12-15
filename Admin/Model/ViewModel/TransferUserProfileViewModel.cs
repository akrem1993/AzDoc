using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using BLL.Models.Document;

namespace Admin.Model.ViewModel
{
     public class TransferUserProfileViewModel
    
    {
       public List<ChooseModel> Name { get; set; }
        public int? oldWorkplace { get; set; }
        public int? newWorkplace { get; set; }

    }
}
