using Model.DB_Tables;

namespace DMSModel
{
    using Model.Entity;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public partial class DM_ORG_SCHEMA : BaseEntity
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int OrganizationId { get; set; }

        public int? SchemaId { get; set; }

        public virtual DC_ORGANIZATION DC_ORGANIZATION { get; set; }

        public virtual DM_SCHEMA DM_SCHEMA { get; set; }
    }
}