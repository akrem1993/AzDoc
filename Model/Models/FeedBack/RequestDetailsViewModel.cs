using System;

namespace Model.Models.FeedBack
{
    public class RequestDetailsViewModel
    {
        public int? RequestId { get; set; }
        public string RequestText { get; set; }
        public DateTime RequestDate { get; set; }
        public string RequestStatus { get; set; }
        public string RequestFullName { get; set; }
        public DateTime? RequestAnswerDate { get; set; }
        public string RequestAnswerText { get; set; }
        public string AnswerFullName { get; set; }
        public int WorkPlaceId { get; set; }

        public string RequestDateTimeFormat => RequestDate.ToString("hh:mm | dd.MM.yyyy");

        public string AnsWerDateTimeFormat => RequestDate.ToString("hh:mm | dd.MM.yyyy");
    }
}