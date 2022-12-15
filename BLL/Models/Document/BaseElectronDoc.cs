using BLL.Models.DocInfo;
using BLL.Models.Document.QrDocModel;
using System;
using System.Collections.Generic;

namespace BLL.Models.Document
{
    public class BaseElectronDoc : IQrDocument, IDocument
    {
        public int DocId { get; set; }
        public int FileSignatureStatus { get; set; }
        public int DocDocumentStatusId { get; set; }
        public string SignerPerson { get; set; }
        public string DocOrganization { get; set; }
        public string ConfirmPerson { get; set; }
        public int FileInfoId { get; set; }
        public string Base64QrCode { get; set; }
        public DateTime? SignTime { get; set; }
        public string DocEnterNo { get; set; }
        public string DocDocNo { get; set; }
        public DateTime? DocEnterDate { get; set; }
        public int ExecutorId { get; set; }

        public DocFileInfo MainFileInfo { get; set; } = new DocFileInfo();
        public DocFileInfo SignedFileInfo { get; set; } = new DocFileInfo();

        public IEnumerable<ChooseModel> DocActions { get; set; }
        public IEnumerable<DocFile> DocFiles { get; set; }
        public IEnumerable<DocTask> DocTasks { get; set; }
        public IEnumerable<DocPlan> DocPlan { get; set; }
    }
}
