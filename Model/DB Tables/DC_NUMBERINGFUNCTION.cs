using Model.Entity;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace DMSModel
{
    public partial class DC_NUMBERINGFUNCTION : BaseEntity
    {
        public DC_NUMBERINGFUNCTION()
        {
            DC_NUMBERING = new HashSet<DC_NUMBERING>();
        }

        [Key]
        public int FunctionId { get; set; }

        public string FunctionName { get; set; }

        public virtual ICollection<DC_NUMBERING> DC_NUMBERING { get; set; }
    }
}