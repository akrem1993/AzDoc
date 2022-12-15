namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public partial class DC_REQUESTSTATUS : BaseEntity
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public DC_REQUESTSTATUS()
        {
            DC_REQUEST = new HashSet<DC_REQUEST>();
        }

        [Key]
        public int RequestStatusId { get; set; }

        [Required]
        public string RequestStatusName { get; set; }

        public bool RequestStatus { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<DC_REQUEST> DC_REQUEST { get; set; }
    }
}