using Model.Entity;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace DMSModel
{
    public class DC_VACATION_TYPE : Entity<byte>
    {
        [MaxLength(50)]
        public string VacationTypeName { get; set; }

        public bool VacationTypeStatus { get; set; }

        public virtual IEnumerable<DC_VACATION> DC_VACATION { get; set; }
    }
}