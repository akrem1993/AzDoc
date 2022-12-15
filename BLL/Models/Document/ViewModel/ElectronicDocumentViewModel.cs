using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using BLL.Models.Document.EntityModel;

namespace BLL.Models.Document.ViewModel
{
    public class ElectronicDocumentViewModel  : BaseElectronDoc
    {
        public string DocTypeName { get; set; }
        public DateTime? DocDocDate { get; set; }
        public string Description { get; set; }
        public int DirectionTypeId { get; set; }
        public FileInfoModel FileInfoModel { get; set; }
        public IEnumerable<FileInfoModel> JsonFileInfoSelected { get; set; }
        public IEnumerable<FileInfoModel> JsonFileInfos { get; set; }
        public IEnumerable<OperationalHistory> JsonOperationHistory { get; set; }
        public IEnumerable<ChooseModel> JsonActionName { get; set; }

    }
}
