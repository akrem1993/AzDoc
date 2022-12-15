using System.Collections.Generic;
using ServiceLetters.Model.EntityModel;

namespace ServiceLetters.Model.ViewModel
{
    public class DocumentGridViewModel
    {
        public int TotalCount { get; set; }
        public IEnumerable<DocumentGridModel> Items { get; set; }
    }
}