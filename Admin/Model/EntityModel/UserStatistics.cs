using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Admin.Model.EntityModel
{
   public class UserStatistics
    {

        public int? TotalUsers { get; set; }
        public int? ActiveUsers { get; set; }
        public int? DeactiveUsers { get; set; }
        public string MaxUserCount { get; set; }

    }
}
