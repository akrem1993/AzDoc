using System.Collections.Generic;

namespace InsDoc.Model.EntityModel
{
    public class DocumentModel
    {
        public int DocId { get; set; }

        private int? typeOfDocumentId;

        public int? TypeOfDocumentId
        {
            get => typeOfDocumentId ?? -1;
            set => typeOfDocumentId = value;
        }

        private int? subtypeOfDocumentId;

        public int? SubtypeOfDocumentId
        {
            get => subtypeOfDocumentId ?? -1;
            set => subtypeOfDocumentId = value;
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

        public string CurrentRedirectPersonsJson { get; set; }

        public IEnumerable<RedirectPersonsView> CurrentRedirectPersons { get; set; }
        public string VizaDataJson { get; set; }
    }

    public class RedirectPersonsView
    {
        public int RedirectId { get; set; }

        public string PersonName { get; set; }
        public int PersonWorkPlace { get; set; }
        public int ExecutionType { get; set; }
        public string ExecutionTypeName { get; set; }


    }
}