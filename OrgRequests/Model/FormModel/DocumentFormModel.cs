using OrgRequests.Model.EntityModel;
using System;
using System.Collections.Generic;
using BLL.Models.Document;
using  BLL.Models.Document.EntityModel;

namespace OrgRequests.Model.FormModel
{
    public class DocumentFormModel
    {
        public DateTime DocEnterDate { get; set; }
        public ChooseModel TopicTypeName { get; set; }
        public ChooseModel WhomAddress { get; set; }
        public ChooseModel ReceivedForm { get; set; }
        public ChooseModel TypeOfDocument { get; set; }
        public ChooseModel ExecutionStatus { get; set; }
        public DocumentModel DocumentModel { get; set; }
        public List<RelatedDocModel> RelatedDocModels { get; set; }
        public List<AuthorModel> AuthorModels { get; set; }
        public List<TaskFormModel> TaskFormModels { get; set; }

    }
}