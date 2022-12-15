using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace OutgoingDoc.Model.EntityModel
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

        private int? sendFormId;

        public int? SendFormId
        {
            get => sendFormId ?? -1;
            set => sendFormId = value;
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
        private int? signatoryPersonId;
        public int? SignatoryPersonId
        {
            get => signatoryPersonId ?? -1;
            set => signatoryPersonId = value;
        }
        public int? DepartmentId
        {
            get => DepartmentId ?? -1;
            set => DepartmentId = value;
        }

        public bool DocIsAppealBoard { get; set; }
        public bool DocDuplicateId { get; set; }
        public string ShortContent { get; set; }
        public string VizaDataJson { get; set; }

        public IEnumerable<WhomAddressedModel> JsonWhomAddress { get; set; }
        public IEnumerable<AuthorModel> AuthorModels { get; set; }
        public IEnumerable<RelatedDocModel> RelatedDocModels { get; set; }
        public IEnumerable<RelatedDocumentByOutDocModel> RelatedDocumentByOutDocModels { get; set; }
        public IEnumerable<AnswerByOutDocModel> AnswerByOutDocModels { get; set; }

    }
    public class WhomAddressedModel
    {
        public int WhomAddressId { get; set; }
        public int TypeOfAssignmentId { get; set; }
        public string WhomAddress { get; set; }
        public string TypeOfAssignment { get; set; }
    }

}
