using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DMSModel
{
    using Model.Entity;
    using System.ComponentModel.DataAnnotations;

    public partial class DOC_UNDERCONTROLSTATUS : BaseEntity
    {
        public DOC_UNDERCONTROLSTATUS()
        {

        }
        [Key]
        public int Id { get; set; }
        [Required]
        public int UnderControlStatusValue { get; set; }

        [Required]
        [StringLength(50)]
        public string UnderControlStatusName { get; set; }

    }
}
