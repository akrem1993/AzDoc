using Model.Entity;
using System.ComponentModel.DataAnnotations;

namespace DMSModel
{
    public partial class DOC_STEP : BaseEntity
    {
        [Key]
        public int DocStepId { get; set; }

        public int SchemaId { get; set; }

        public int PositionGroupId { get; set; }

        public int? WorkplaceId { get; set; }

        public int DocumentStatusId { get; set; }

        public int OperationId { get; set; }

        public int? NextPositionGroupId { get; set; }

        public virtual DC_POSITION_GROUP DC_POSITION_GROUP { get; set; }

        public virtual DC_POSITION_GROUP DC_POSITION_GROUP_NEXT { get; set; }

        public virtual DM_SCHEMA DM_SCHEMA { get; set; }

        public virtual DOC_DOCUMENTSTATUS DOC_DOCUMENTSTATUS { get; set; }

        public virtual DOC_OPERATION DOC_OPERATION { get; set; }
    }
}