using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using BLL.Models.Document.EntityModel;

namespace OrgRequests.Model.EntityModel
{
    public class DocumentModel
    {
        public int DocId { get; set; }

        private DateTime? docEnterDate;

        [DataType(DataType.Date)]
        [DisplayFormat(DataFormatString = "{0:yyyy-MM-dd}", ApplyFormatInEditMode = true)]
        public DateTime? DocEnterDate
        {
            get { return docEnterDate; }
            set { docEnterDate = value ?? DateTime.Now; }
        }

        public string DocNo { get; set; }

        private DateTime? docDate;

        [DataType(DataType.Date)]
        [DisplayFormat(DataFormatString = "{0:yyyy-MM-dd}", ApplyFormatInEditMode = true)]
        public DateTime? DocDate
        {
            get { return docDate; }
            set { docDate = value ?? DateTime.Now; }
        }

        private DateTime? plannedDate;

        [DataType(DataType.Date)]
        [DisplayFormat(DataFormatString = "{0:yyyy-MM-dd}", ApplyFormatInEditMode = true)]
        public DateTime? PlannedDate
        {
            get { return plannedDate; }
            set
            {
                plannedDate = (value == DateTime.MinValue ? null : value);
            }
        }

        private int? topicTypeId;

        public int? TopicTypeId
        {
            get => topicTypeId ?? -1;
            set => topicTypeId = value;
        }

        private int? whomAddressId;

        public int? WhomAddressId
        {
            get => whomAddressId ?? -1;
            set => whomAddressId = value;
        }

        private int? receivedFormId;

        public int? ReceivedFormId
        {
            get => receivedFormId ?? -1;
            set => receivedFormId = value;
        }

        private int? typeOfDocumentId;

        public int? TypeOfDocumentId
        {
            get => typeOfDocumentId ?? -1;
            set => typeOfDocumentId = value;
        }

        private int? executionStatusId;

        public int? ExecutionStatusId
        {
            get => executionStatusId ?? -1;
            set => executionStatusId = value;
        }

        public bool DocIsAppealBoard { get; set; }
        public bool DocDuplicateId { get; set; }
        public bool Supervision { get; set; }
        public string ShortContent { get; set; }

        public IEnumerable<AuthorModel> AuthorModels { get; set; }
        public IEnumerable<RelatedDocModel> RelatedDocModels { get; set; }
        public IEnumerable<TaskModel> TaskModels { get; set; }
    

    }
}