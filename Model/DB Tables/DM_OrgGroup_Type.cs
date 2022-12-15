using Model.Entity;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DMSModel
{
    public partial class DM_ORGGROUP_TYPE : BaseEntity
    {
        public DM_ORGGROUP_TYPE()
        {
            this.DM_ORGGROUP_SCHEMA = new HashSet<DM_ORGGROUP_SCHEMA>();
        }

        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int GroupTypeId { get; set; }

        [Required]
        [StringLength(250)]
        public string GroupName { get; set; }

        public virtual ICollection<DM_ORGGROUP_SCHEMA> DM_ORGGROUP_SCHEMA { get; set; }
    }
}