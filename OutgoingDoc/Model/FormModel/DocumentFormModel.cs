using OutgoingDoc.Model.EntityModel;
using System.Collections.Generic;
using BLL.Models.Document;

namespace OutgoingDoc.Model.FormModel
{
    public class DocumentFormModel
    {
        public ChooseModel TypeOfDocument { get; set; }
        public ChooseModel SubtypeOfDocument { get; set; }
        public ChooseModel SignatoryPerson { get; set; }
        public ChooseModel SendForm { get; set; }
        public ChooseModel ConfirmingPerson { get; set; }
        public ChooseModel WhomAddress { get; set; }
        public ChooseModel Department { get; set; }
        public RelatedDocModel RelatedDocument { get; set; }
        public DocumentModel DocumentModel { get; set; }
        public List<WhomAddressModel> WhomAddressModels { get; set; }
        public List<RelatedDocModel> RelatedDocModels { get; set; }
        public List<AuthorModel> AuthorModels { get; set; }
        public List<TaskFormModel> TaskFormModels { get; set; }
        public List<AnswerByOutDocModel> AnswerByOutDocModels { get; set; }
        public string VizaDataJson { get; set; }
    }
}
