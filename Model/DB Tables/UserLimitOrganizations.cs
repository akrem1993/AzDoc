using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Model.DB_Tables
{
    [Table("UserLimitOrganizations")]
    public class UserLimitOrganizations
    {
        [Key]
        public int Id { get; set; }
        public int? WorkplaceId { get; set; }
        public int? OrganizationId { get; set; }
        public string OperationNote { get; set; }

        public string UpdatedDate { get; set; }

    }
}
