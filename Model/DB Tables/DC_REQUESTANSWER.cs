namespace DMSModel
{
    using Model.Entity;
    using System;
    using System.ComponentModel.DataAnnotations;

    public partial class DC_REQUESTANSWER : BaseEntity
    {
        [Key]
        public int RequestAnswerId { get; set; }

        public int RequestId { get; set; }

        public string RequestAnswerText { get; set; }

        public int WorkPlaceId { get; set; }

        public DateTime? RequestAnswerDate { get; set; }

        public bool RequestAnswerStatus { get; set; }

        public bool IsSeen { get; set; }

        public virtual DC_REQUEST DC_REQUEST { get; set; }

        public virtual DC_WORKPLACE DC_WORKPLACE { get; set; }
    }
}