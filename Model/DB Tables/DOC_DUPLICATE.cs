using Model.Entity;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using Model.DB_Tables;

namespace DMSModel
{
    public partial class DOC_DUPLICATE : BaseEntity
    {
        public DOC_DUPLICATE()
        {
            DOC = new HashSet<DOC>();
        }

        [Key]
        public int DuplicateId { get; set; }

        [Required]
        [StringLength(200)]
        public string DuplicateName { get; set; }

        public bool DuplicateStatus { get; set; }

        public virtual ICollection<DOC> DOC { get; set; }
    }
}