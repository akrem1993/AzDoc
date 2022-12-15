using System;
using System.Collections.Generic;
using BLL.Models.Document;
using ServiceLetters.Model.EntityModel;

namespace ServiceLetters.Model.FormModel
{
    public class DocumentFormModel
    {
        public ChooseModel SignatoryPerson { get; set; }
        public ChooseModel ConfirmingPerson { get; set; }
        public DocumentModel DocumentModel { get; set; }
        public List<WhomAddressModel> WhomAddressModels { get; set; }
        public List<RelatedDocModel> RelatedDocModels { get; set; }
        public List<AnswerByLetterModel> AnswerByLetterModels { get; set; }
        public string VizaDataJson { get; set; }
    }
}