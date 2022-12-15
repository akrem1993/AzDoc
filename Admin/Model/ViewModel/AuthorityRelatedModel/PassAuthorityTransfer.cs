using System;
using BLL.Models.Document;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace Admin.Model.ViewModel.AuthorityRelatedModel
{
    public class PassAuthorityTransfer
    {
        public PassAuthorityTransfer()
        {
            TransferredFromPersons = new List<ChooseModel>();
            TransferredToPersons = new List<ChooseModel>();
            TransferReasons = new List<ChooseModel>();
            Statuses=new List<ChooseModel>();
        }
       
        public int AuthorityId { get; set; }

        [Required(ErrorMessage = "Bu xana məcburidir")]
        public int TransferredFromPerson { get; set; }

        [Required(ErrorMessage = "Bu xana məcburidir")]
        public int TransferredToPerson { get; set; }

        [Required(ErrorMessage = "Bu xana məcburidir")]
        public int TransferReason { get; set; }

        private DateTime _myField;

        [DataType(DataType.Date)]
        [DisplayFormat(DataFormatString = "{0:yyyy-MM-dd}", ApplyFormatInEditMode = true)]
       
        public DateTime? BeginDate { get; set; }

        [Required(ErrorMessage = "Bu xana məcburidir")]

        [DataType(DataType.Date)]
        [DisplayFormat(DataFormatString = "{0:yyyy-MM-dd}", ApplyFormatInEditMode = true)]
        public DateTime? EndDate { get; set; }

        
        public string TransferNote { get; set; }
        public int? AuthorityStatus { get; set; }
        public bool IsEdit { get; set; }

        public List<ChooseModel> TransferredFromPersons { get; set; }
        public List<ChooseModel> TransferredToPersons { get; set; }
        public List<ChooseModel> TransferReasons { get; set; }
        public List<ChooseModel> Statuses { get; set; }

    }
}