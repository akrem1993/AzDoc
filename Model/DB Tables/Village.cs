using DMSModel;
using Model.Entity;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Model.DB_Tables
{
    public class Village : BaseEntity
    {
        public int VillageId { get; set; }
        public string VillageName { get; set; }
        public int VillageCode { get; set; }
        public int RegionCode { get; set; }
        public bool VillageStatus { get; set; }
    }
}
