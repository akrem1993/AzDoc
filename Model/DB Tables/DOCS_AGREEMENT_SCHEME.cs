using Model.Entity;
using System.ComponentModel.DataAnnotations;

namespace DMSModel
{
    public partial class DOCS_AGREEMENT_SCHEME : BaseEntity
    {
        [Key]
        public int AgreementSchemeId { get; set; }

        public int DocTypeId { get; set; }
        public int AgreementTypeId { get; set; }
        public int SchemaId { get; set; }
        public int AgreementSchemeOrderIndex { get; set; }
        public bool AgreementSchemeStatus { get; set; }
        public bool AgreementSchemeRequired { get; set; }
        public int? AgreementSchemeMaxWorkplaceCount { get; set; }

        public virtual DOC_TYPE DOC_TYPE { get; set; }
        public virtual DM_SCHEMA DM_SCHEMA { get; set; }
        public virtual DOCS_AGREEMENTTYPE DOCS_AGREEMENTTYPE { get; set; }
    }
}