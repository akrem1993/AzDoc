namespace DMSModel
{
    using Model.Entity;
    using System.ComponentModel.DataAnnotations;

    public partial class DM_STEP : BaseEntity
    {
        [Key]
        public int StepId { get; set; }

        public int DocTypeId { get; set; }

        public int PositionGroupId { get; set; }

        public int NextPositionGroupId { get; set; }

        public int DirectionTypeId { get; set; }

        public int? ActionId { get; set; }

        public int? StepOrderIndex { get; set; }

        public virtual DOC_TYPE DOC_TYPE { get; set; }

        public virtual DM_ACTION DM_ACTION { get; set; }

        public virtual DC_POSITION_GROUP DC_POSITION_GROUP { get; set; }

        public virtual DC_POSITION_GROUP DC_NEXT_POSITION_GROUP { get; set; }
    }
}