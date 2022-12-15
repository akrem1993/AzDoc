namespace DMSModel
{
    using Model.Entity;
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public partial class DOCS_VIZA : BaseEntity
    {
        public DOCS_VIZA()
        {
            DOCS_DIRECTIONS = new HashSet<DOCS_DIRECTIONS>();
        }

        [Key]
        public int VizaId { get; set; }

        public int VizaDocId { get; set; }

        public int VizaFileId { get; set; }

        public int VizaWorkPlaceId { get; set; }

        //public int VizaReplyPersonId { get; set; }

        public DateTime? VizaReplyDate { get; set; }

        public string VizaNotes { get; set; }

        public int? VizaOrderindex { get; set; }

        public int VizaSenderWorkPlaceId { get; set; }

        //public int VizaSenderPersonId { get; set; }

        public DateTime? VizaSenddate { get; set; }

        public byte VizaConfirmed { get; set; }

        public bool? IsDeleted { get; set; }

        public int? VizaAgreementTypeId { get; set; }

        public int? VizaFromWorkflow { get; set; }

        public virtual ICollection<DOCS_DIRECTIONS> DOCS_DIRECTIONS { get; set; }

        public virtual DOC_AGREEMENTTYPE DOC_AGREEMENTTYPE { get; set; }
    }
}