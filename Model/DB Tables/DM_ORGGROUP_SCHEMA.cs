using Model.Entity;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Model.DB_Tables;

namespace DMSModel
{
    public partial class DM_ORGGROUP_SCHEMA : BaseEntity
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int OrgGroupId { get; set; }

        [Required]
        public int SchemaId { get; set; }

        [Required]
        public int OrganizationId { get; set; }

        [Required]
        public int GroupTypeId { get; set; }

        public virtual DC_ORGANIZATION DC_ORGANIZATION { get; set; }
        public virtual DM_ORGGROUP_TYPE DM_ORGGROUP_TYPE { get; set; }
        public virtual DM_SCHEMA DM_SCHEMA { get; set; }
    }
}