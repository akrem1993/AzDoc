using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ReserveDocs.Model.EntityModel
{
    public class ReserveNumbers
    {
        public int ReservedId { get; set; }
        public int ReserveDocdId { get; set; }
        public int? DocType { get; set; }
        public int? SignatoryWorkplaceId { get; set; }
        public int? CreatedByWorkplace { get; set; }
        public string ReserveNumber { get; set; }
        public bool? ReserveDeleted { get; set; }
    }
}
