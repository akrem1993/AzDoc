using Model.DB_Tables;

namespace DMSModel
{
    using Model.Entity;
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public partial class DOCS_DIRECTIONS : BaseEntity
    {
        public DOCS_DIRECTIONS()
        {
            DOCS_EXECUTOR = new HashSet<DOCS_EXECUTOR>();
            DOCS_DIRECTIONCHANGE = new HashSet<DOCS_DIRECTIONCHANGE>();
        }

        [Key]
        public int DirectionId { get; set; }

        public int DirectionDocId { get; set; }

        public DateTime DirectionDate { get; set; }

        public int? DirectionWorkplaceId { get; set; }

        public int? DirectionPersonId { get; set; }

        [StringLength(500)]
        public string DirectionPersonFullName { get; set; }

        public int? DirectionTemplateId { get; set; }

        public int DirectionTypeId { get; set; }

        public bool DirectionControlStatus { get; set; }

        [Column(TypeName = "date")]
        public DateTime? DirectionPlanneddate { get; set; }

        public byte? DirectionPlannedDay { get; set; }

        public int? DirectionExecutionStatusId { get; set; }

        public int? DirectionVizaId { get; set; }

        public byte DirectionConfirmed { get; set; } = 1;

        public bool DirectionSendStatus { get; set; } = true;

        public int? DirectionCreatorWorkplaceId { get; set; }

        public DateTime? DirectionInsertedDate { get; set; }

        public long? DirectionUnixTime { get; set; }

        public virtual DOCS_VIZA DOCS_VIZA { get; set; }

        public virtual DC_WORKPLACE DC_WORKPLACE_SEND { get; set; }

        public virtual DC_WORKPLACE DC_WORKPLACE_CREATOR { get; set; }

        public virtual DOC_DIRECTION_TEMPLATE DOC_DIRECTION_TEMPLATE { get; set; }

        public virtual DOC DOC { get; set; }

        public virtual VW_DOCUMENTS VW_DOCUMENTS { get; set; }

        public virtual VW_DOCUMENTINFO VW_DOCUMENTINFO { get; set; }

        public virtual ICollection<DOCS_DIRECTIONCHANGE> DOCS_DIRECTIONCHANGE { get; set; }

        public virtual ICollection<DOCS_EXECUTOR> DOCS_EXECUTOR { get; set; }
    }
}