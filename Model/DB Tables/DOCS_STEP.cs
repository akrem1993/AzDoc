namespace DMSModel
{
    using Model.Entity;
    using System.ComponentModel.DataAnnotations;

    public partial class DOCS_STEP : BaseEntity
    {
        [Key]
        public int StepId { get; set; }

        public int StepDocId { get; set; }

        public int StepFrom { get; set; }

        public int? StepTo { get; set; }

        public int? StepExecutorId { get; set; }

        public int? StepSendedtoId { get; set; }
    }
}