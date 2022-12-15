namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public partial class DC_REQUESTTYPE : BaseEntity
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public DC_REQUESTTYPE()
        {
            DC_REQUEST = new HashSet<DC_REQUEST>();
        }

        [Key]
        public int RequestTypeId { get; set; }

        [Required]
        public string RequestTypeName { get; set; }

        public bool RequestTypeStatus { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<DC_REQUEST> DC_REQUEST { get; set; }
    }
}