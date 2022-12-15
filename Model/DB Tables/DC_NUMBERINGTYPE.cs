using Model.Entity;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace DMSModel
{
    public partial class DC_NUMBERINGTYPE : BaseEntity
    {
        public DC_NUMBERINGTYPE()
        {
            DC_NUMBERING = new HashSet<DC_NUMBERING>();
            DOC_NUMBERS = new HashSet<DOC_NUMBERS>();
        }

        [Key]
        public int NumberingTypeId { get; set; }

        public string NumberingName { get; set; }

        public virtual ICollection<DC_NUMBERING> DC_NUMBERING { get; set; }
        public virtual ICollection<DOC_NUMBERS> DOC_NUMBERS { get; set; }
    }
}