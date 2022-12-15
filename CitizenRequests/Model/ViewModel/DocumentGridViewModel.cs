using CitizenRequests.Model.EntityModel;
using System.Collections.Generic;

namespace CitizenRequests.Model.ViewModel
{
    public class DocumentGridViewModel
    {
        public int TotalCount { get; set; }
        public IEnumerable<DocumentGridModel> Items { get; set; }
    }
}