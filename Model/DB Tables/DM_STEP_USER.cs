namespace DMSModel
{
    using Model.Entity;
    using System.ComponentModel.DataAnnotations;

    public partial class DM_STEP_USER : BaseEntity
    {
        [Key]
        public int StepUserId { get; set; }

        public int WorkplaceId { get; set; }

        public int DocTypeId { get; set; }

        public int DirectionTypeId { get; set; }

        public string Sql { get; set; }

        public virtual DC_WORKPLACE DC_WORKPLACE { get; set; }
    }
}