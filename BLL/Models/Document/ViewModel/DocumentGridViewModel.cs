using BLL.Models.Document.EntityModel;
using System.Collections.Generic;

namespace BLL.Models.Document.ViewModel
{
    public class DocumentGridViewModel
    {
        public int TotalCount { get; set; }
        public IEnumerable<DocumentGridModel> Items { get; set; }
    }
}
