using OutgoingDoc.Model.EntityModel;
using System;
using System.Collections.Generic;
using BLL.Models.Document;

namespace OutgoingDoc.Model.ViewModel
{
    public class ElectronicDocumentViewModel :BaseElectronDoc
    {
        public string DocTypeName { get; set; }
        public DateTime? DocDocDate { get; set; }
        public string ExecuteRule { get; set; }
        public string CreaterPersonnelName { get; set; }
        public string Description { get; set; }
        public string Token { get; set; }
    }
}
