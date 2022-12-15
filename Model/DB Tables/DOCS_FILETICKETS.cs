using Model.Entity;
using System;
using System.ComponentModel.DataAnnotations;

namespace DMSModel
{
    public partial class DOCS_FILETICKETS : BaseEntity
    {
        [Key]
        public int TickedId { get; set; }

        public int TickedFileInfoId { get; set; }
        public string EdocPath { get; set; }
        public DateTime? TickedStartDate { get; set; }
        public DateTime? TickedEndDate { get; set; }
        public string TickedMessage { get; set; }
        public virtual DOCS_FILEINFO DOCS_FILEINFO { get; set; }
    }
}