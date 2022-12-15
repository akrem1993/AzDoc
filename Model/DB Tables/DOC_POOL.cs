using Model.Entity;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace DMSModel
{
    public partial class DOC_POOL : BaseEntity
    {
        public DOC_POOL()
        {
            DC_NUMBERING = new HashSet<DC_NUMBERING>();
            DOC_NUMBERS = new HashSet<DOC_NUMBERS>();
        }

        [Key]
        public int PoolId { get; set; }

        [Required]
        [StringLength(50)]
        public string PoolName { get; set; }

        public int PoolCurrentNumber { get; set; }

        public virtual ICollection<DC_NUMBERING> DC_NUMBERING { get; set; }

        public virtual ICollection<DOC_NUMBERS> DOC_NUMBERS { get; set; }
    }
}