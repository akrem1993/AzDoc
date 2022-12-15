using BLL.Models.Document;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Model.DB_Tables;

namespace Admin.Model.ViewModel.EditDocument
{
    public class EditDocumentViewModel
    {

        public int? Id { get; set; }
        public string DocEnterNo { get; set; }
        public string DocDocNo { get; set; }
        public string SendType { get; set; }
        public string ExecutorFullName { get; set; }
        public string ReadStatus { get; set; }
        public int? DocId { get; set; }
        public int? WorkplaceId { get; set; }
        public string DocEditStatus { get; set; }

        public string DocStatusName { get; set; }
        public int Status { get; set; }
        public int DocUndercontrolStatusId { get; set; }
        public List<ChooseModel> SpecialRightsPersons { get; set; }

        public List<ChooseModel> PersonsList { get; set; }

        public List<ChooseModel> StatusList { get; set; }
        public List<ChooseModel> DocUndercontrolStatusList { get; set; }

        public int? ExecutorId { get; set; }
    }
}
