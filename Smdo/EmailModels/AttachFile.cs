using Smdo.Enums;

namespace Smdo.EmailModels
{
    public class AttachFile
    {
        public AttachFile()
        {
            AttachType = AttachType.Other;
        }

        public string AttachPath { get; set; }

        public AttachType AttachType { get; set; }

        public string FileName { get; set; }

        public string Guid { get; set; }

        public string Extension { get; set; }
    }
}
