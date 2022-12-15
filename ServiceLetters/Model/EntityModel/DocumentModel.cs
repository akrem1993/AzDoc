using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace ServiceLetters.Model.EntityModel
{
    public class DocumentModel
    {
        public int DocId { get; set; }

        private DateTime? docEnterDate;

        [DataType(DataType.Date)]
        [DisplayFormat(DataFormatString = "{0:yyyy-MM-dd}", ApplyFormatInEditMode = true)]
        public DateTime? DocEnterDate
        {
            get => docEnterDate;
            set => docEnterDate = value ?? DateTime.Now;
        }

        private DateTime? plannedDate;

        [DataType(DataType.Date)]
        [DisplayFormat(DataFormatString = "{0:yyyy-MM-dd}", ApplyFormatInEditMode = true)]
        public DateTime? PlannedDate
        {
            get => plannedDate;
            set => plannedDate = (value == DateTime.MinValue ? null : value);
        }


        private int? signatoryPersonId;

        public int? SignatoryPersonId
        {
            get => signatoryPersonId ?? -1;
            set => signatoryPersonId = value;
        }

        private int? confirmingPersonId;

        public int? ConfirmingPersonId
        {
            get => confirmingPersonId ?? -1;
            set => confirmingPersonId = value;
        }
        public string ShortContent { get; set; }

        public IEnumerable<WhomAddressedModel> JsonWhomAddress { get; set; }
        public IEnumerable<RelatedDocModel> RelatedDocModels { get; set; }

        public IEnumerable<RelateDocumentByServiceLetterModel> RelateDocumentByServiceLetterModels { get; set; }
        public IEnumerable<AnswerByLetterModel> AnswerByLetterModels { get; set; }
        public string VizaDataJson { get; set; }
    }

    public class WhomAddressedModel
    {
        public int TaskId { get; set; }
        public int WhomAddressId { get; set; }
        public int TypeOfAssignmentId { get; set; }
        public string WhomAddress { get; set; }
        public string TypeOfAssignment { get; set; }
    }
}