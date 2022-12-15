using Model.DB_Tables;

namespace DMSModel
{
    using Model.Entity;
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public partial class DOCS_FILEINFO : BaseEntity
    {
        public DOCS_FILEINFO()
        {
            //Files = new HashSet<DOCS_FILEINFO>();
            //DOCS_FILETICKETS = new HashSet<DOCS_FILETICKETS>();
           // DC_REQUESTFILES = new HashSet<DC_REQUESTFILES>();
        }

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

        public DateTime? FileInfoInsertdate { get; set; }

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
        public string FileExtractedText { get; set; }

        public virtual ICollection<DOCS_FILE> DOCS_FILE { get; set; }

        //public virtual ICollection<DOCS_FILETICKETS> DOCS_FILETICKETS { get; set; }

        //public virtual ICollection<DOCS_FILEINFO> Files { get; set; }

        //public virtual ICollection<DC_REQUESTFILES> DC_REQUESTFILES { get; set; }

        //public virtual DOCS_FILEINFO ParentFile { get; set; }
    }
}