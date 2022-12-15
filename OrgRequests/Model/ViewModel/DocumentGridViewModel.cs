using OrgRequests.Model.EntityModel;
using System.Collections.Generic;

namespace OrgRequests.Model.ViewModel
{
    public class DocumentGridViewModel
    {
        public int TotalCount { get; set; }
        public IEnumerable<DocumentGridModel> Items { get; set; }
    }
}