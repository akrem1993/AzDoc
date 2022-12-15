using BLL.Models.DocInfo;
using System;
using System.Collections.Generic;

namespace ColleagueRequests.Model.ViewModel
{
    public class DocumentInfoViewModel : BaseDocInfo
    {
        public string OrgName { get; set; }
        public string RegisterNumber { get; set; }
        public DateTime? RegisterDate { get; set; }
        public string DocumentNumber { get; set; }
        public DateTime? DocumentDate { get; set; }

        public string EntryFromWhere { get; set; }

        public string ExecuteRule { get; set; }
        public DateTime? DocExecutedDate { get; set; }
        public int ExecutionStatusId { get; set; }
        public string EntryFromWho { get; set; }

        public DateTime? ExecDuration { get; set; }
        public string NewPlanedDateHistory { get; set; }
        public string SendToWhere { get; set; }

        public string DocumentKind { get; set; }

        public string SendToWho { get; set; }
        public double NumberOfApplicants { get; set; }
        public string EntryForm { get; set; }

        public int? PreviosRequestsCount { get; set; }

        public string Subject { get; set; }

        public string Corruption { get; set; }
        public string Organization { get; set; }
        public int DocDocumentStatusId { get; set; }
        public int? DocDuplicateId { get; set; }
        public byte? SupervisionId { get; set; }

        public IEnumerable<Applicant> Applicants { get; set; }
        public IEnumerable<PreviosRequests> PreviosRequests { get; set; }
    }

    public class Applicant
    {
        public string AppFirstname { get; set; }
        public string AppSurname { get; set; }
        public string AppLastName { get; set; }
        public string SocialName { get; set; }
        public string CountryName { get; set; }
        public string RegionName { get; set; }
        public string VillageName { get; set; }
        public string AppAddress { get; set; }
        public string RepresenterName { get; set; }
        public string AppPhone { get; set; }
        public string AppEmail { get; set; }

    }

    public class PreviosRequests
    {
        public int DocId { get; set; }
        public string DocEnterno { get; set; }
    }

    //public class AttachmentFile
    //{
    //    public int FileInfoId { get; set; }
    //    public string FileInfoName { get; set; }
    //    public string FileIsMain { get; set; }
    //    public int? FileInfoCopiesCount { get; set; }
    //    public int? FileInfoPageCount { get; set; }
    //    public DateTime FileInfoDate { get; set; }
    //}

    //public class RelatedDocumentInfo
    //{
    //    public int DocId { get; set; }
    //    public string DocEnterno { get; set; }
    //    public DateTime? DocEnterdate { get; set; }
    //    public string DocDocNo { get; set; }
    //    public DateTime? DocDocDate { get; set; }
    //    public int DocDoctypeId { get; set; }
    //    public string DocumentInfo { get; set; }
    //    public string DocDescription { get; set; }

    //}

    //public class AnswerDocumentInfo
    //{
    //    public int DocId { get; set; }
    //    public string DocEnterno { get; set; }
    //    public DateTime? DocEnterdate { get; set; }
    //    public string DocDocNo { get; set; }
    //    public DateTime? DocDocDate { get; set; }
    //    public int DocDoctypeId { get; set; }
    //    public string DocumentInfo { get; set; }
    //    public string DocDescription { get; set; }
    //    public string DocumentstatusName { get; set; }

    //}
    //public class OperationalHistory
    //{
    //    public int? OrderIndex { get; set; }
    //    public int DirectionTypeId { get; set; }
    //    public int? VizaConfirmed { get; set; }
    //    public DateTime DirectionDate { get; set; }
    //    public int DirectionId { get; set; }
    //    public string PersonFrom { get; set; }
    //    public string PersonTo { get; set; }
    //    public string ExecutorMain { get; set; }
    //    public string Status { get; set; }
    //    public DateTime? StatusDate { get; set; }
    //    public string ExecutorResolutionNote { get; set; }
    //    public int SendStatusId { get; set; }
    //    public string DirectionChangeStatus { get; set; }

    //}





}