using System;

namespace DMSModel
{
    public class DashboardData
    {
        public int DocId { get; set; }
        public string DocNumber { get; set; }
        public DateTime? DocEnterdate { get; set; }
        public DateTime? DocPlannedDate { get; set; }
        public bool DocIsClosed { get; set; }
        public bool DocIsExpired { get; set; }
        public bool DocIsUnderControl { get; set; }
        public int DirectionTypeId { get; set; }
    }
}