using System;
using System.Collections.Generic;

namespace Smdo.Api.ApiModels
{
    public class DvcParse
    {
        public DvcValidationResult dvcValidationResult { get; set; }
        public int statusCode { get; set; }
        public object message { get; set; }
    }


    public class DtsSteps
    {
        public int StepId { get; set; }
        public string StepName { get; set; }

        public bool StepStatus { get; set; }
    }


    public class Checker
    {
        public string name { get; set; }
        public int status { get; set; }
        public string indicator { get; set; }
        public string description { get; set; }
    }

    public class DvcSigner
    {
        public string subject { get; set; }
        public string serialNumber { get; set; }
        public DateTime? validFrom { get; set; }
        public DateTime? validTo { get; set; }
        public string issuer { get; set; }
    }

    public class DocumentSigner
    {
        public string subject { get; set; }
        public string serialNumber { get; set; }
        public DateTime? validFrom { get; set; }
        public DateTime? validTo { get; set; }
        public string issuer { get; set; }
    }

    public class DvcValidationResult
    {
        public List<Checker> checkers { get; set; }
        public int allValid { get; set; }
        public List<DvcSigner> dvcSigners { get; set; }
        public List<DocumentSigner> documentSigners { get; set; }
        public DateTime? ttpVerificationUTCTime { get; set; }
    }

}
