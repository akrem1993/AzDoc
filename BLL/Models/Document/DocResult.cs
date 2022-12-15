using System;

namespace BLL.Models.Document
{
    public class DocResult
    {
        public int DocId { get; set; }

        public DateTime DirectionInsertedDate { get; set; }

        public bool ExecutorReadStatus { get; set; }
    }
}
