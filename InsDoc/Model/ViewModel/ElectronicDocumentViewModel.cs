using BLL.Models.Document;
using System;

namespace InsDoc.Model.ViewModel
{
    public class ElectronicDocumentViewModel : BaseElectronDoc
    {
        public string DocTypeName { get; set; }
        public DateTime? DocDocDate { get; set; }
        public string Description { get; set; }
        public string Token { get; set; }
    }
}