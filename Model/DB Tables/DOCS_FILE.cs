using System;
using System.ComponentModel.DataAnnotations;
using DMSModel;
using Model.Entity;

namespace Model.DB_Tables
{
    public partial class DOCS_FILE : BaseEntity
    {
        [Key]
        public int FileId { get; set; }

        public int FileDocId { get; set; }

        public int FileInfoId { get; set; }

        [StringLength(300)]
        public string FileName { get; set; }

        public byte? FileVisaStatus { get; set; }

        public byte SignatureStatusId { get; set; }

        public byte FileCurrentVisaGroup { get; set; }

        public bool FileIsMain { get; set; }

        public string SignatureNote { get; set; }

        public bool? IsDeleted { get; set; }

        public bool? IsReject { get; set; }

        public int? SignatureWorkplaceId { get; set; }

        public DateTime? SignatureDate { get; set; }
        //public int? FileStatus { get; set; }

        public virtual DOC DOC { get; set; }

        public virtual DOCS_FILEINFO DOCS_FILEINFO { get; set; }

        public virtual DOC_VIZASTATUS DOC_VIZASTATUS { get; set; }
    }
}