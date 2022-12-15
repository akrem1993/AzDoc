using CustomHelpers.Attributes;

namespace ColleagueRequests.Model.EntityModel
{
    public class RelatedDocModel
    {
        public int DocId { get; set; }

        [NoUddtColumn]
        public int RelatedId { get; set; }
        public string DocEnterno { get; set; }
        public string DocumentInfo { get; set; }
    }
}