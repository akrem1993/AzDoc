using BLL.Models.Document;
using Smdo.AzDoc.Adapters;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Smdo.AzDoc.Models
{
    public class SmdoDocumentModel : InterfaceDocData
    {
        public SmdoDocumentModel()
        {

        }

        public SmdoDocumentModel(DocumentAdapter adapter, int workPlace)
        {
            ReceiverCountry = new List<ChooseModel> { new ChooseModel { Id = 1, Name = "Беларусь" } };
            ReceiverMinistry = new List<ChooseModel> { new ChooseModel { Id = 1, Name = "Министертсво связи и информатизации" } };
            ReceiverMinister = new List<ChooseModel> { new ChooseModel { Id = 1, Name = "Шульган Константин Константинович" } };
            var chList = adapter.GetChooseModel(12, workPlace);
            SignPersons = chList.Where(x => x.FormTypeId == 2);
            DocForms = chList.Where(x => x.FormTypeId == 1);
            SendForms = chList.Where(x => x.FormTypeId == 3);
        }

        [DataType(DataType.Date)]
        [DisplayFormat(DataFormatString = "{0:yyyy-MM-dd}", ApplyFormatInEditMode = true)]
        public DateTime DocEnterDate { get; set; }

        public int DocFormId { get; set; }
        public int SignPersonId { get; set; }
        public int SendFormId { get; set; }
        public string Guid { get; set; }

        public int ReceiverCountryId { get; set; }

        public int ReceiverMinistryId { get; set; }

        public int ReceiverMinisterId { get; set; }

        public string FileName { get; set; }

        public string Note { get; set; }



        public IEnumerable<ChooseModel> DocForms { get; set; }
        public IEnumerable<ChooseModel> SignPersons { get; set; }
        public IEnumerable<ChooseModel> SendForms { get; set; }



        public List<ChooseModel> ReceiverCountry { get; set; }

        public List<ChooseModel> ReceiverMinistry { get; set; }

        public List<ChooseModel> ReceiverMinister { get; set; }
    }
}
