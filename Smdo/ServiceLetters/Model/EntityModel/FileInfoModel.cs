using System;
using System.ComponentModel.DataAnnotations;

namespace ServiceLetters.Model.EntityModel
{
    public class FileInfoModel
    {
        [Key]
        public int FileInfoId { get; set; }

        public int FileInfoWorkplaceId { get; set; }

        public int? FileInfoParentId { get; set; }

        public byte FileInfoVersion { get; set; }

        [StringLength(100)]
        public string FileInfoType { get; set; }

        public long? FileInfoCapacity { get; set; }

        [StringLength(5)]
        public string FileInfoExtention { get; set; }

        public DateTime? FileInfoInsertDate { get; set; }

        [StringLength(200)]
        public string FileInfoPath { get; set; }

        [StringLength(300)]
        public string FileInfoName { get; set; }

        [StringLength(60)]
        public string FileInfoGuId { get; set; }

        public int? FileInfoStatus { get; set; }

        public int? FileInfoAttachmentCount { get; set; }

        public int? FileInfoCopiesCount { get; set; }

        public int? FileInfoPageCount { get; set; }

        [MaxLength(1)]
        public byte[] FileInfoBinary { get; set; }

        public string FileInfoContent { get; set; }
    }
}