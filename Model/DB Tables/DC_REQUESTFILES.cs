namespace DMSModel
{
    using Model.Entity;
    using System;
    using System.ComponentModel.DataAnnotations;

    public partial class DC_REQUESTFILES : BaseEntity
    {
        [Key]
        public int RuquestFilesId { get; set; }

        public int FileInfoId { get; set; }

        public int RequestId { get; set; }

        public int Type { get; set; }

        public DateTime InsertDate { get; set; }

        public bool Status { get; set; }

        public virtual DC_REQUEST DC_REQUEST { get; set; }

        public virtual DOCS_FILEINFO DOCS_FILEINFO { get; set; }
    }
}