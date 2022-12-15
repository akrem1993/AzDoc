using OutgoingDoc.Adapters;
using OutgoingDoc.Enum;
using OutgoingDoc.Model.EntityModel;
using System.Collections.Generic;
using System.Linq;
using BLL.Models.Document;

namespace OutgoingDoc.Model.ViewModel
{
    public class DocumentViewModel
    {
        public ChooseModel TopicTypeName { get; set; }
        public ChooseModel WhomAddress { get; set; }
        public ChooseModel SendForm { get; set; }
        public ChooseModel TypeOfDocument { get; set; }
        public ChooseModel ExecutionStatus { get; set; }
        public ChooseModel SignatoryPerson { get; set; }
        public ChooseModel Result { get; set; }
        public ChooseModel Department { get; set; }
        public ChooseModel InfoPerson { get; set; }
        public ChooseModel IntWhomAddress { get; set; }

        public IEnumerable<ChooseModel> TopicTypeNames { get; set; }
        public IEnumerable<ChooseModel> WhomAddresses { get; set; }
        public IEnumerable<ChooseModel> SendForms { get; set; }
        public IEnumerable<ChooseModel> TypeOfDocuments { get; set; }
        public IEnumerable<ChooseModel> ExecutionStatuses { get; set; }
        public IEnumerable<ChooseModel> SignatoryPersons { get; set; }
        public IEnumerable<ChooseModel> ResultList { get; set; }
        public IEnumerable<ChooseModel> Departments { get; set; }
        public IEnumerable<ChooseModel> IntWhomAddresses { get; set; }

        public DocumentModel DocumentModel { get; set; }
        public ChiefModel ChiefModel { get; set; }
        public IEnumerable<AuthorModel> AuthorModels { get; set; }
    }

}
