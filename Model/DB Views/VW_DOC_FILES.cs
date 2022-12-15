using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Model.DB_Views
{
    public partial class VW_DOC_FILES
    {
        [Key]
        [Column(Order = 0)]
        public int FileId { get; set; }

        public int FileDocId { get; set; }

        public int FileInfoId { get; set; }

        public byte? FileVisaStatus { get; set; }

        public byte SignatureStatusId { get; set; }

        public byte? FileCurrentVisaGroup { get; set; }

        [StringLength(60)]
        public string FileInfoName { get; set; }

        public int? FileInfoParentId { get; set; }

        public DateTime? FileInfoInsertdate { get; set; }

        public byte FileInfoVersion { get; set; }

        [StringLength(250)]
        public string PersonFullName { get; set; }

        //public byte? VizaConfirmed { get; set; }

        public bool FileIsMain { get; set; }

        public int MainExecutorsWorkplaceId { get; set; }

        public int InsertedUserWorkplaceId { get; set; }

        public int DocDoctypeId { get; set; }

        public int? FileInfoAttachmentCount { get; set; }

        public int? FileInfoCopiesCount { get; set; }

        public int? FileInfoPageCount { get; set; }
        //public byte? DirectionConfirmed { get; set; }
        //public int? VizaId { get; set; }
    }
}