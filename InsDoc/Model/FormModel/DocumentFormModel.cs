using InsDoc.Model.EntityModel;
using System.Collections.Generic;
using BLL.Models.Document;

namespace InsDoc.Model.FormModel
{
    public class DocumentFormModel
    {
        public ChooseModel TypeOfDocument { get; set; }
        public ChooseModel SubtypeOfDocument { get; set; }
        public ChooseModel SignatoryPerson { get; set; }
        public ChooseModel ConfirmingPerson { get; set; }
        public RelatedDocModel RelatedDocument { get; set; }
        public DocumentModel DocumentModel { get; set; }
        public List<RelatedDocModel> RelatedDocModels { get; set; }
        public List<TaskFormModel> TaskFormModels { get; set; }
        public List<RedirectPersonsInput> RedirectPersonInput { get; set; }
        public string VizaDataJson { get; set; }
    }
}