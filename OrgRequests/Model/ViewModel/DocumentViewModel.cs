using BLL.Common.Enums;
using BLL.Models.Document;
using BLL.Models.Document.EntityModel;
using OrgRequests.Adapters;
using OrgRequests.Common.Enums;
using OrgRequests.Model.EntityModel;
using System;
using System.Collections.Generic;
using System.Linq;

namespace OrgRequests.Model.ViewModel
{
    public class DocumentViewModel
    {
        public ChooseModel TopicTypeName { get; set; }
        public ChooseModel WhomAddress { get; set; }
        public ChooseModel ReceivedForm { get; set; }
        public ChooseModel TypeOfDocument { get; set; }
        public ChooseModel ExecutionStatus { get; set; }

        public decimal? TaskNo { get; set; }
        public string Task { get; set; }
        public ChooseModel TypeOfAssignment { get; set; }
        public ChooseModel TaskCycle { get; set; }
        public int ExecutionPeriod { get; set; }
        public int PeriodOfPerformance { get; set; }
        public DateTime OriginalExecutionDate { get; set; }

        public IEnumerable<ChooseModel> RedirectPersons { get; set; }

        public IEnumerable<ChooseModel> TopicTypeNames { get; set; }
        public IEnumerable<ChooseModel> WhomAddresses { get; set; }
        public IEnumerable<ChooseModel> ReceivedForms { get; set; }
        public IEnumerable<ChooseModel> TypeOfDocuments { get; set; }
        public IEnumerable<ChooseModel> ExecutionStatuses { get; set; }
        public DocumentModel DocumentModel { get; set; }
        public IEnumerable<AuthorModel> AuthorModels { get; set; }
        public IEnumerable<ChooseModel> TypeOfAssignments { get; set; }
        public IEnumerable<ChooseModel> TaskWhomAddresses { get; set; }
        public IEnumerable<TaskModel> TaskModels { get; set; }
        public IEnumerable<ChooseModel> ResultList { get; set; }

        public IEnumerable<ChooseModel> TaskCycles { get; set; }



        private const int topicTypeName = (int)BasicInformation.TopicTypeName;
        private const int whomAddress = (int)BasicInformation.WhomAddress;
        private const int receivedForm = (int)BasicInformation.ReceivedForm;
        private const int typeOfDocument = (int)BasicInformation.TypeOfDocument;
        private const int executionStatus = (int)BasicInformation.ExecutionStatus;
        private const int typeOfAssignment = (int)DocumentInformation.TypeOfAssignment;
        private const int taskWhomAddressed = (int)DocumentInformation.WhomAddressed;
        private const int taskCycle = (int)DocumentInformation.TaskCycle;


        public DocumentViewModel(DocumentAdapter adapter, int docType, int workPlaceId) : this(adapter, workPlaceId)
        {
            DocumentModel = new DocumentModel();
        }

        public DocumentViewModel(DocumentAdapter adapter, int docType, int workPlaceId, int docId) : this(adapter, workPlaceId)
        {
            var chooseList = adapter.GetChooseModel(docType, workPlaceId);
            TaskModels = adapter.GetTaskModel(docId, docType);
            DocumentModel = adapter.GetDocumentModel(docId);
        }

        public DocumentViewModel(DocumentAdapter adapter, int workPlace)
        {
            var chooseList = adapter.GetChooseModel((int)DocType.OrgRequests, workPlace);
            TopicTypeNames = chooseList.Where(l => l.FormTypeId == topicTypeName);
            WhomAddresses = chooseList.Where(l => l.FormTypeId == whomAddress);
            ReceivedForms = chooseList.Where(l => l.FormTypeId == receivedForm);
            TypeOfDocuments = chooseList.Where(l => l.FormTypeId == typeOfDocument);
            ExecutionStatuses = chooseList.Where(l => l.FormTypeId == executionStatus);
            TypeOfAssignments = chooseList.Where(l => l.FormTypeId == typeOfAssignment);
            RedirectPersons = TaskWhomAddresses = chooseList.Where(l => l.FormTypeId == taskWhomAddressed);
            TaskCycles = chooseList.Where(l => l.FormTypeId == taskCycle);
            TaskModels = Enumerable.Empty<TaskModel>();
        }

        public DocumentViewModel()
        {

        }


    }
}