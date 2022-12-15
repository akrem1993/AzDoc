using Smdo.Api.ApiModels;
using System;
using System.Collections.Generic;

namespace Smdo.AzDoc.Models
{
    public class GridViewDoc : SmdoDoc
    {
        public int DocId { get; set; }
        public string DocEnterNo { get; set; }
        public DateTime DocEnterDate { get; set; }
        public string Creator { get; set; }
        public string DocMsgGuid { get; set; }
        public string StatusName { get; set; }
        public string RelatedDocName { get; set; }

        public string DocFilePath { get; set; }
        public string Signer { get; set; }
        public string Note { get; set; }
        public string Kind { get; set; }
    }


    public class SmdoDoc : DocDetails
    {
        public int DocStatus { get; set; }
        public byte DocAckStatus { get; set; }

        public bool IsReceived { get; set; }
    }

    public class DocDetails : DocumentSigner
    {
        public string SignP7S { get; set; }

        public string AttachName { get; set; }

        public string AttachGuid { get; set; }

        public string  DocSubject { get; set; }

        public string DvcBase64 { get; set; }

        public IEnumerable<Checker> Checks { get; set; }

        public IEnumerable<DtsSteps> DtsStep { get; set; }

        public IEnumerable<DvcSigner> SignerSubjects { get; set; }
    }
}
