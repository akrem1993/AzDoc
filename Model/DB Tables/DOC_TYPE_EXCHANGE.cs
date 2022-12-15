namespace DMSModel
{
    using Model.Entity;
    using System.ComponentModel.DataAnnotations;

    public partial class DOC_TYPE_EXCHANGE : BaseEntity
    {
        [Key]
        public int DocTypeExchangeId { get; set; }

        public int SchemaId { get; set; }

        public int DocTypeId { get; set; }

        public int FromDocTypeId { get; set; }

        public int ToDocTypeId { get; set; }

        public byte AnswerType { get; set; }

        public int RelatedTypeId { get; set; }

        public virtual DM_SCHEMA DM_SCHEMA { get; set; }

        public virtual DOC_TYPE DOC_TYPE { get; set; }

        public virtual DOC_TYPE DOC_TYPE1 { get; set; }

        public virtual DOC_TYPE DOC_TYPE2 { get; set; }

        public virtual DOCS_RELATEDTYPE DOCS_RELATEDTYPE { get; set; }
    }
}