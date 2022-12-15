using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DMSModel;
using Model.DB_Tables;

namespace Admin.Model.ViewModel
{
   public class PassOrganisationViewModel
    {
        public List<DC_ORGANIZATION> Organisations { get; set; }
        public DC_ORGANIZATION organisation { get; set; }
    }
}
