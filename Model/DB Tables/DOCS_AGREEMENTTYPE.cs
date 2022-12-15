using Model.Entity;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace DMSModel
{
    public partial class DOCS_AGREEMENTTYPE : BaseEntity
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public DOCS_AGREEMENTTYPE()
        {
            this.DOCS_AGREEMENT_SCHEME = new HashSet<DOCS_AGREEMENT_SCHEME>();
            this.DOCS_VIZA = new HashSet<DOCS_VIZA>();
        }

        [Key]
        public int AgreementTypeId { get; set; }

        public string AgreementTypeName { get; set; }
        public bool AgreementTypeStatus { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<DOCS_AGREEMENT_SCHEME> DOCS_AGREEMENT_SCHEME { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<DOCS_VIZA> DOCS_VIZA { get; set; }
    }
}