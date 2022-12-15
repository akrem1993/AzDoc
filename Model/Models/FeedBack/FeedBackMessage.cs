using System;
using System.Collections.Generic;

namespace Model.Models.FeedBack
{
    [Serializable]
    public class FeedBackMessage
    {
        public int MessageId { get; set; }
        public int RequestId { get; set; }
        public string MessageText { get; set; }
        public string PersonName { get; set; }
        public int WorkPlaceId { get; set; }
        public DateTime MessageDate { get; set; }
        public bool IsSeen { get; set; }
        public bool IsOperator { get; set; }
        public IEnumerable<FeedBackFile> MessageFiles { get; set; }
    }
}