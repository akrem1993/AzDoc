using System.Collections.Generic;

namespace BLL.Models.DocInfo
{
    public abstract class BaseDocInfo
    {
        public int DocId { get; set; }
        public string DocEnterNo { get; set; }
        public string DocTypeName { get; set; }
        public string DocumentStatus { get; set; }
        public string ShortContent { get; set; }
        public IEnumerable<DocFile> DocFiles { get; set; }
        public IEnumerable<AnswerDoc> AnswerDocs { get; set; }
        public IEnumerable<EnteredDoc> EnteredDocs { get; set; }
        public IEnumerable<DocHistory> DocHistory { get; set; }
        public IEnumerable<DeletedFromViza> DeletedFromViza { get; set; }
        public IEnumerable<RelatedDoc> RelatedDocs { get; set; }
        public IEnumerable<DocTask> DocTasks { get; set; }
    }
}
