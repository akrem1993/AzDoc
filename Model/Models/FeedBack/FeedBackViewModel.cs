using System;
using System.Collections.Generic;

namespace Model.Models.FeedBack
{
    [Serializable]
    public class FeedBackViewModel
    {
        public int RequestId { get; set; }
        public DateTime RequestDate { get; set; }
        public int RequestStatus { get; set; }
        public int WorkPlaceId { get; set; }
        public bool UserIsHelper { get; set; }
        public string AnswerText { get; set; }
        public int LastMessageId { get; set; }
        public IEnumerable<FeedBackMessage> Messages { get; set; }
    }
}