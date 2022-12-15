using System;

namespace BLL.Models.DocInfo
{
    public class AnswerDoc
    {
        public int DocId { get; set; }
        public string DocNo { get; set; }
        public DateTime DocDate { get; set; }
        public string DocAddress { get; set; }
        public string DocDescription { get; set; }
        public string DocResult { get; set; }
        public string DocStatus { get; set; }
        public byte IsDeleted { get; set; }
    }
}
