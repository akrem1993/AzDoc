namespace DMSModel
{
    using Model.Entity;
    using System.ComponentModel.DataAnnotations;

    public partial class DOC_FORM_DOCTYPE : BaseEntity
    {
        [Key]
        public int FormDocTypeId { get; set; }

        public int FormId { get; set; }

        public int DocTypeId { get; set; }

        public bool? FormDocTypeStatus { get; set; }

        public int SchemaId { get; set; }

        public int? FormDocTypeOrderIndex { get; set; }

        public virtual DM_SCHEMA DM_SCHEMA { get; set; }

        public virtual DOC_FORM DOC_FORM { get; set; }

        public virtual DOC_TYPE DOC_TYPE { get; set; }
    }
}