using BLL.Models.Document;
using ReserveDocs.Model.EntityModel;
using System.Collections.Generic;

namespace ReserveDocs.Model.ViewModel
{
    public class DocumentViewModel
    {
        public ChooseModel SignatoryPerson { get; set; }
        public ChooseModel Department { get; set; }
        public ChooseModel DocType { get; set; }
        public ChooseModel DocForm { get; set; }
        public IEnumerable<ChooseModel> SignatoryPersons { get; set; }
        public IEnumerable<ChooseModel> Departments { get; set; }
        public IEnumerable<ChooseModel> DocTypes { get; set; }
        public IEnumerable<ChooseModel> DocForms { get; set; }
        public DocumentModel DocumentModel { get; set; }
     
    }
}
