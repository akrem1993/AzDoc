namespace DMSModel
{
    using Model.Entity;
    using System.ComponentModel.DataAnnotations;

    public partial class DOC_QUESTION : AuditableEntity<int>
    {
        public int? QuestionTopId { get; set; }

        [StringLength(2000)]
        public string QuestionTitle { get; set; }

        [StringLength(2000)]
        public string QuestionBody { get; set; }

        public int QuestionOrderindex { get; set; }

        public bool QuestionStatus { get; set; }
    }
}