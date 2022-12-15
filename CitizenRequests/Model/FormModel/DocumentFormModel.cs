using System;
using System.Collections.Generic;
using BLL.Models.Document;
using CitizenRequests.Model.EntityModel;

namespace CitizenRequests.Model.FormModel
{
    public class DocumentFormModel
    {
        public DateTime DocEnterDate { get; set; }
        public ChooseModel TypeOfApplication { get; set; } 
        public ChooseModel WhomAddress { get; set; }
        public ChooseModel TopicTypeName { get; set; }
        public ChooseModel Subtitle { get; set; } //Alt movzu
        public ChooseModel ExecutionStatus { get; set; }
        public ChooseModel ReceivedForm { get; set; }
        public ChooseModel Organization { get; set; } //Qurum
        public ChooseModel Subordinate { get; set; } //Alt qurum
        public ChooseModel TypeOfDocument { get; set; }
        public DocumentModel DocumentModel { get; set; }
        public List<RelatedDocModel> RelatedDocModels { get; set; }
        public List<AuthorModel> AuthorModels { get; set; }
        public  List<ApplicationModel> ApplicationModels { get; set; }

    }
}