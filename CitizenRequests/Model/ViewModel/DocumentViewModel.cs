using BLL.Models.Document;
using CitizenRequests.Adapters;
using CitizenRequests.Common.Enums;
using CitizenRequests.Model.EntityModel;
using System.Collections.Generic;
using System.Linq;

namespace CitizenRequests.Model.ViewModel
{
    public class DocumentViewModel
    {
        public ChooseModel TopicTypeName { get; set; }
        public ChooseModel WhomAddress { get; set; }
        public ChooseModel ReceivedForm { get; set; }
        public ChooseModel TypeOfDocument { get; set; }
        public ChooseModel ExecutionStatus { get; set; }
        public ChooseModel TypeOfApplication { get; set; }
        public ChooseModel Organization { get; set; } //Qurum
        public ChooseModel Subtitle { get; set; } //Alt movzu
        public ChooseModel Subordinate { get; set; } //Alt qurum
        public ChooseModel Country { get; set; }
        public ChooseModel Region { get; set; }
        public ChooseModel Village { get; set; }
        public ChooseModel SocialStatus { get; set; }
        public ChooseModel Representer { get; set; }



        public IEnumerable<ChooseModel> TopicTypeNames { get; set; }
        public IEnumerable<ChooseModel> WhomAddresses { get; set; }
        public IEnumerable<ChooseModel> ReceivedForms { get; set; }
        public IEnumerable<ChooseModel> TypeOfDocuments { get; set; }
        public IEnumerable<ChooseModel> ExecutionStatuses { get; set; }
        public IEnumerable<ChooseModel> TypeOfApplications { get; set; }
        public IEnumerable<ChooseModel> Organizations { get; set; }
        public IEnumerable<ChooseModel> Subtitles { get; set; }
        public IEnumerable<ChooseModel> Subordinates { get; set; }
        public IEnumerable<ChooseModel> Countries { get; set; }
        public IEnumerable<ChooseModel> Regions { get; set; }
        public IEnumerable<ChooseModel> Villages { get; set; }
        public IEnumerable<ChooseModel> SocialStatuses { get; set; }
        public IEnumerable<ChooseModel> Representeres { get; set; }

        public DocumentModel DocumentModel { get; set; }
        public SubordinateModel SubordinateModel { get; set; }
        public IEnumerable<AuthorModel> AuthorModels { get; set; }


        private const int topicTypeName = (int)BasicInformation.TopicTypeName;
        private const int whomAddress = (int)BasicInformation.WhomAddress;
        private const int receivedForm = (int)BasicInformation.ReceivedForm;
        private const int typeOfDocument = (int)BasicInformation.TypeOfDocument;
        private const int executionStatus = (int)BasicInformation.ExecutionStatus;
        private const int typeOfApplication = (int)BasicInformation.TypeOfApplication;
        private const int organization = (int)BasicInformation.Organization;
        private const int subtitle = (int)BasicInformation.Subtitle;
        private const int subordinate = (int)BasicInformation.Subordinate;
        private const int country = (int)BasicInformation.Country;
        private const int region = (int)BasicInformation.Region;
        private const int village = (int)BasicInformation.Villages;
        private const int socialStatus = (int)BasicInformation.SocialStatus;
        private const int representer = (int)BasicInformation.Representer;


        public DocumentViewModel(DocumentAdapter adapter, int docType, int workPlaceId)
        {
            var chooseList = adapter.GetChooseModel(docType, workPlaceId);
            TopicTypeNames = chooseList.Where(l => l.FormTypeId == topicTypeName);
            WhomAddresses = chooseList.Where(l => l.FormTypeId == whomAddress);
            ReceivedForms = chooseList.Where(l => l.FormTypeId == receivedForm);
            TypeOfDocuments = chooseList.Where(l => l.FormTypeId == typeOfDocument);
            ExecutionStatuses = chooseList.Where(l => l.FormTypeId == executionStatus);
            TypeOfApplications = chooseList.Where(l => l.FormTypeId == typeOfApplication);
            Organizations = chooseList.Where(l => l.FormTypeId == organization);
            Subtitles = chooseList.Where(l => l.FormTypeId == subtitle);
            Subordinates = chooseList.Where(l => l.FormTypeId == subordinate);
            Countries = chooseList.Where(l => l.FormTypeId == country);
            Regions = chooseList.Where(l => l.FormTypeId == region);
            Villages = chooseList.Where(l => l.FormTypeId == village);
            SocialStatuses = chooseList.Where(l => l.FormTypeId == socialStatus);
            Representeres = chooseList.Where(l => l.FormTypeId == representer);

            DocumentModel = new DocumentModel();
        }

        public DocumentViewModel(DocumentAdapter adapter, int docType, int workPlaceId, int docId) : this(adapter, docType, workPlaceId) => DocumentModel = adapter.GetDocumentModel(docId);

        public DocumentViewModel() { }
    }
}