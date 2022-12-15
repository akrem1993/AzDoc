using Model.Entity;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DMSModel
{
    public partial class DOC_AGREEMENTTYPE : BaseEntity
    {
        public DOC_AGREEMENTTYPE()
        {
            DOCS_VIZA = new HashSet<DOCS_VIZA>();
        }

        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int AgreementTypeId { get; set; }

        [StringLength(200)]
        public string AgreementTypeName { get; set; }

        public bool? AgreementTypeStatus { get; set; }

        public virtual ICollection<DOCS_VIZA> DOCS_VIZA { get; set; }
    }
}