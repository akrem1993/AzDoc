using Model.DB_Tables;

namespace DMSModel
{
    using Model.Entity;
    using System.ComponentModel.DataAnnotations;

    public partial class DOCS_ADDRESSINFO : BaseEntity
    {
        [Key]
        public int AdrId { get; set; }

        public int AdrDocId { get; set; }

        public int AdrTypeId { get; set; }

        public int? AdrOrganizationId { get; set; }

        public int? AdrAuthorId { get; set; }

        [StringLength(250)]
        public string AdrAuthorDepartmentName { get; set; }

        public int? AdrPersonId { get; set; }

        public int? AdrPositionId { get; set; }

        public int AdrUndercontrol { get; set; }

        public int AdrUndercontrolDays { get; set; }

        public int? AdrSendStatusId { get; set; }

        [StringLength(1000)]
        public string FullName { get; set; }

        public virtual DOC_AUTHOR DOC_AUTHOR { get; set; }

        public virtual DOC_ADRTYPE DOC_ADRTYPE { get; set; }

        public virtual DOC DOC { get; set; }

        public virtual DC_ORGANIZATION DC_ORGANIZATION { get; set; }

        public virtual DC_POSITION DC_POSITION { get; set; }

        public virtual DC_WORKPLACE DC_WORKPLACE { get; set; }

        public virtual VW_DOCUMENTS VW_DOCUMENTS { get; set; }

        public virtual DOC_SENDSTATUS DOC_SENDSTATUS { get; set; }
    }
}