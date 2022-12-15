using Model.Entity;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DMSModel
{
    [Table("DMSTableRelation")]
    public partial class DMSTableRelation : BaseEntity
    {
        [Key]
        public int Id { get; set; }

        public int IdTable { get; set; }

        public int RelatedIdTable { get; set; }

        public virtual DMSTables DMSTable { get; set; }

        public virtual DMSTables DMSRelatedTable { get; set; }
    }
}