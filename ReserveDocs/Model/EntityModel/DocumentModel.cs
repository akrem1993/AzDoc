using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ReserveDocs.Model.EntityModel
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
        private int? typeOfDocumentId;

        public int? TypeOfDocumentId
        {
            get => typeOfDocumentId ?? -1;
            set => typeOfDocumentId = value;
        }
        private int? formOfDocumentId;

        public int? FormOfDocumentId
        {
            get => formOfDocumentId ?? -1;
            set => formOfDocumentId = value;
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

        public string ShortContent { get; set; }
    }
}
