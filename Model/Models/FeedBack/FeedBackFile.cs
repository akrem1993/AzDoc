using System;

namespace Model.Models.FeedBack
{
    public class FeedBackFile
    {
        public int FileId { get; set; }

        public int MessageId { get; set; }
        public string FileInfoName { get; set; }

        public int Type { get; set; }

        public DateTime InsertDate { get; set; }

        public bool Status { get; set; }
    }
}