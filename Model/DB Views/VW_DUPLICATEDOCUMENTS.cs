using Model.Entity;
using System;
using System.ComponentModel.DataAnnotations;

namespace DMSModel
{
    public class VW_DUPLICATEDOCUMENTS : BaseEntity
    {
        [Key]
        public int DocId { get; set; }

        public int DocPeriodId { get; set; }

        public int DocDoctypeId { get; set; }

        public DateTime? DocEnterdate { get; set; }

        public string DocEnterno { get; set; }

        public string DocEnternop1 { get; set; }

        public int DocEnternop2 { get; set; }

        public int DocOrganizationId { get; set; }

        public int? DocDuplicateDocId { get; set; }

        public int? DocDuplicateId { get; set; }

        public int? DocAppliertypeId { get; set; }

        public string AppAddress1 { get; set; }

        public string AppAppAddress1Lower { get; set; }

        public int? AppRegion1Id { get; set; }

        public string AppSurname { get; set; }

        public string AppFirstname { get; set; }

        public string AppSurnameLower { get; set; }

        public string AppFirstnameLower { get; set; }

        public string DocEnternoLower { get; set; }

        public int? DocTopicId { get; set; }

        public int? DocDocumentStatusId { get; set; }
    }
}