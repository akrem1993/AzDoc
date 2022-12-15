using System.Collections.Generic;

namespace Journal.Model.EntityModel
{
    public class GridViewModel
    {
        public int TotalCount { get; set; }
        public IEnumerable<Journal.Model.EntityModel.GridModelDto> Items { get; set; }
    }
}
