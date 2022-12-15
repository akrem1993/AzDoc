using Model.Entity;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace DMSModel
{
    public partial class DOC_OPERATION : BaseEntity
    {
        public DOC_OPERATION()
        {
            DOC_STEP = new HashSet<DOC_STEP>();
        }

        [Key]
        public int DocOperationId { get; set; }

        [Required]
        [StringLength(100)]
        public string OperationName { get; set; }

        public virtual ICollection<DOC_STEP> DOC_STEP { get; set; }
    }
}