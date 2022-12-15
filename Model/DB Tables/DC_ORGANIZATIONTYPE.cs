using Model.DB_Tables;

namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public partial class DC_ORGANIZATIONTYPE : BaseEntity
    {
        public DC_ORGANIZATIONTYPE()
        {
            DC_ORGANIZATION = new HashSet<DC_ORGANIZATION>();
        }

        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int TypeId { get; set; }

        [Required]
        [StringLength(250)]
        public string TypeName { get; set; }

        [StringLength(250)]
        public string TypeTopId { get; set; }

        [StringLength(250)]
        public string TypeOrderindex { get; set; }

        public bool? TypeStatus { get; set; }

        public virtual ICollection<DC_ORGANIZATION> DC_ORGANIZATION { get; set; }
    }
}