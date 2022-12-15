using Model.Entity;
using System;
using System.ComponentModel.DataAnnotations.Schema;

namespace DMSModel
{
    [Table("DOCS_ApplicantDOC")]
    public partial class DOCS_APPLICANTDOC : BaseEntity
    {
        public long Id { get; set; }
        public int AppId { get; set; }
        public string DocApplicantPin { get; set; }
        public string DocType { get; set; }
        public string DocSeriaNumber { get; set; }
        public string DocNumber { get; set; }
        public Nullable<System.DateTime> DocIssueDate { get; set; }
        public Nullable<System.DateTime> DocValidTo { get; set; }
        public string DocIssuerOrg { get; set; }

        public virtual DOCS_APPLICATION DOCS_APPLICATION { get; set; }
    }
}