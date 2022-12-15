using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BLL.Models.Document.ViewModel
{
    public class DocumentInfoViewModel
    {
        public string OrgName { get; set; }
        public string DocTypeName { get; set; }
        public string Description { get; set; }
        public string DocEnterNo { get; set; }
        public DateTime? DocEnterDate { get; set; }
        public string SignatoryPerson { get; set; }
        public string ConfirmPerson { get; set; }
        public DateTime? DocPlannedDate { get; set; }
        public int DocDocumentStatusId { get; set; }
        public string DocumentStatusName { get; set; }
        public string Signer { get; set; }
        public string SendTo { get; set; }
        public int? DocResultId { get; set; }

        public IEnumerable<AttachmentFile> JsonFileInfo { get; set; }
        public IEnumerable<RelatedDocumentInfo> JsonRelatedDocumentInfo { get; set; }
        public IEnumerable<AnswerDocumentInfo> JsonAnswerDocumentInfo { get; set; }
        public IEnumerable<OperationalHistory> JsonOperationHistory { get; set; }
    }

    public class AttachmentFile
    {
        public int FileInfoId { get; set; }
        public string FileInfoName { get; set; }
        public string FileIsMain { get; set; }
        public int? FileInfoCopiesCount { get; set; }
        public int? FileInfoPageCount { get; set; }
        public DateTime FileInfoDate { get; set; }
    }

    public class RelatedDocumentInfo
    {
        public int DocId { get; set; }
        public string DocEnterno { get; set; }
        public DateTime DocEnterdate { get; set; }
        public string DocumentInfo { get; set; }
        public string DocDescription { get; set; }

    }

    public class AnswerDocumentInfo
    {
        public int DocId { get; set; }
        public string DocEnterno { get; set; }
        public DateTime DocEnterdate { get; set; }
        public string DocumentInfo { get; set; }
        public string DocDescription { get; set; }
        public string ResultName { get; set; }

    }

    public class OperationalHistory
    {
        public int? OrderIndex { get; set; }
        public int DirectionTypeId { get; set; }
        public int? VizaConfirmed { get; set; }
        public DateTime DirectionDate { get; set; }
        public int DirectionId { get; set; }
        public string PersonFrom { get; set; }
        public string PersonTo { get; set; }
        public string ExecutorMain { get; set; }
        public string Status { get; set; }
        public DateTime? StatusDate { get; set; }
        public string ExecutorResolutionNote { get; set; }
    }
}
