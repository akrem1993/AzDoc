using System;
using System.Collections.Generic;
using System.Linq;
using BLL.Models.Document;
using CustomHelpers;
using ServiceLetters.Adapters;
using ServiceLetters.Common.Enums;
using ServiceLetters.Model.EntityModel;

namespace ServiceLetters.Model.ViewModel
{
    public class DocumentViewModel
    {
        public ChooseModel SignatoryPerson { get; set; }
        public ChooseModel ConfirmingPerson { get; set; }
        public ChooseModel WhomAddress { get; set; }
        public ChooseModel ExecutionStatus { get; set; }
        public ChooseModel Result { get; set; }

        public IEnumerable<ChooseModel> SignatoryPersons { get; set; }
        public IEnumerable<ChooseModel> ConfirmingPersons { get; set; }
        public IEnumerable<ChooseModel> WhomAddresses { get; set; }
        public IEnumerable<ChooseModel> ExecutionStatuses { get; set; }
        public IEnumerable<ChooseModel> ResultList { get; set; }
        public DocumentModel DocumentModel { get; set; }
        public ChiefModel ChiefModel { get; set; }




        private const int signatoryPerson = (int)BasicInformation.SignatoryPerson;
        private const int confirmingPerson = (int)BasicInformation.ConfirmingPerson;
        private const int whomAddress = (int)BasicInformation.WhomAddress;
        private const int executionStatus = (int)BasicInformation.ExecutionStatus;
        private const int result = (int)BasicInformation.Result;

        /// <summary>
        ///
        /// </summary>
        /// <param name="adapter"></param>
        /// <param name="docType"></param>
        /// <param name="workPlaceId"></param>
        ///
        public DocumentViewModel(DocumentAdapter adapter, int docType, int workPlaceId)
        {
            var chooseList = adapter.GetChooseModel(docType, workPlaceId);
            SignatoryPersons = chooseList.Where(l => l.FormTypeId == signatoryPerson);//.DistinctBy(l=>l.Id)
            ConfirmingPersons = chooseList.Where(l => l.FormTypeId == confirmingPerson);
            WhomAddresses = chooseList.Where(l => l.FormTypeId == whomAddress);
            ExecutionStatuses = chooseList.Where(l => l.FormTypeId == executionStatus);
            DocumentModel = new DocumentModel();
            ChiefModel = adapter.GetChiefModel(workPlaceId);
        }

        public DocumentViewModel(DocumentAdapter adapter, int docType, int workPlaceId, int docId)
        {
            var chooseList = adapter.GetChooseModel(docType, workPlaceId);
            SignatoryPersons = chooseList.Where(l => l.FormTypeId == signatoryPerson);
            ConfirmingPersons = chooseList.Where(l => l.FormTypeId == confirmingPerson);
            WhomAddresses = chooseList.Where(l => l.FormTypeId == whomAddress);
            ExecutionStatuses = chooseList.Where(l => l.FormTypeId == executionStatus);
            ResultList = chooseList.Where(l => l.FormTypeId == result);
            DocumentModel = adapter.GetDocumentModel(docId);
        }

        public DocumentViewModel(DocumentAdapter adapter, int docType, int workPlaceId, int docId, int actionId)
        {
            var chooseList = adapter.GetChooseModel(docType, workPlaceId);
            SignatoryPersons = chooseList.Where(l => l.FormTypeId == signatoryPerson);
            ConfirmingPersons = chooseList.Where(l => l.FormTypeId == confirmingPerson);
            WhomAddresses = chooseList.Where(l => l.FormTypeId == whomAddress);
            ExecutionStatuses = chooseList.Where(l => l.FormTypeId == executionStatus);
            ResultList = chooseList.Where(l => l.FormTypeId == result);
            ChiefModel = adapter.GetChiefModel(workPlaceId);
            if (actionId == 11)
            {
                DocumentModel = adapter.GetAnswerByLetterModel(docId);
            }
            else if (actionId == 12)
            {
                DocumentModel = adapter.GetRelateDocumentByServiceLetterModel(docId);
            }
        }

        public DocumentViewModel()
        {
        }
    }
}