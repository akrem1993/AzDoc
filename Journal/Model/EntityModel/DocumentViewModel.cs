using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JournalLib.Model.EntityModel
{
    public class DocumentViewModel
    {

        //public IEnumerable<Journal.Model.EntityModel.DocumentModel> Data { get; set; }
        //public BLL.Models.Report.Paging.Pager Pager { get; set; }

        public int TotalCount { get; set; }
        public IEnumerable<Journal.Model.EntityModel.DocumentModelDto> Items { get; set; }

    }
}
