using System;

namespace BLL.Models.DocInfo
{
    public class DocFile
    {
        public int FileInfoId { get; set; }
        public string FileName { get; set; }
        public string FileNote { get; set; }
        public int FileCopy { get; set; }
        public int FilePage { get; set; }
        public bool FileIsMain { get; set; }
        public DateTime FileDate { get; set; }
        public int DocStatus { get; set; }
    }
}
