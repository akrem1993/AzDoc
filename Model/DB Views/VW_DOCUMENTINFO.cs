using Model.Entity;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace DMSModel
{
    public class VW_DOCUMENTINFO : BaseEntity
    {
        public VW_DOCUMENTINFO()
        {
            DOCS_DIRECTIONS = new HashSet<DOCS_DIRECTIONS>();
        }

        [Key]
        public int DocId { get; set; }

        public int DocPeriodId { get; set; }

        public int DocDoctypeId { get; set; }

        public DateTime? DocEnterdate { get; set; }

        public string DocEnterno { get; set; }

        public string DocEnternop1 { get; set; }

        public int? DocEnternop2 { get; set; }

        public int DocOrganizationId { get; set; }

        public int? DocDuplicateDocId { get; set; }

        public int? DocDuplicateId { get; set; }

        public int? DocAppliertypeId { get; set; }

        public int? DocDocumentStatusId { get; set; }

        public string DocumentInfo { get; set; }

        public string DocumentInfoLower { get; set; }

        public virtual ICollection<DOCS_DIRECTIONS> DOCS_DIRECTIONS { get; set; }

        public virtual ICollection<DOCS_EXECUTOR> DOCS_EXECUTOR { get; set; }
    }
}