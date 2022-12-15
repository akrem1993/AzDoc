namespace DMSModel
{
    using Model.Entity;
    using System.ComponentModel.DataAnnotations;

    public partial class DOC_DOCUMENTSTATUS_DOCTYPE : BaseEntity
    {
        [Key]
        public int DocumentStatusDocTypeId { get; set; }

        public int DocTypeId { get; set; }
        public int DocumentStatusId { get; set; }
        public int SchemaId { get; set; }
        public int DocumentStatusDocTypeOrderIndex { get; set; }
        public bool DocumentStatusDocTypeStatus { get; set; }
        public virtual DM_SCHEMA DM_SCHEMA { get; set; }
        public virtual DOC_DOCUMENTSTATUS DOC_DOCUMENTSTATUS { get; set; }
        public virtual DOC_TYPE DOC_TYPE { get; set; }
    }
}