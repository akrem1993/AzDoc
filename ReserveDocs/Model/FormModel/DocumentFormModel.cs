using ReserveDocs.Model.EntityModel;
using System.Collections.Generic;
using BLL.Models.Document;

namespace ReserveDocs.Model.FormModel
{
    public class DocumentFormModel
    {
        public ChooseModel DocType { get; set; }      
        public ChooseModel SignatoryPerson { get; set; }
        public ChooseModel DocForm { get; set; }     
        public ChooseModel Department { get; set; }     
        public DocumentModel DocumentModel { get; set; }
    

    }
}
