using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Admin.Model.ViewModel
{
    public class CountryViewModel
    {
        public int? CountryId { get; set; }

        [Required]
        public string CountryName { get; set; }
        public string CountryName2 { get; set; }
        public int? CountryCode { get; set; }
        public byte CountryStatus { get; set; }
        public string CountryStatusText { get; set; }
    }

}
