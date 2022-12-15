using System;

namespace Model.Models.FeedBack
{
    public class RequestModel
    {
        public int RequestId { get; set; }
        public DateTime RequestDate { get; set; }
        public string Person { get; set; }
        public string RequestHeader { get; set; }
        public string RequestTypeName { get; set; }
        public string RequestStatusName { get; set; }
    }
}