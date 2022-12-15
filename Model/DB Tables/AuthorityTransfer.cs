using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Model.Entity;

namespace Model.DB_Tables
{
    public class AuthorityTransfer
    {
        [Key]
        public int AuthorityId { get; set; }
        public int TransferredFromPerson { get; set; }
        public int TransferredToPerson { get; set; }
        public int TransferredReason { get; set; }
        public DateTime? BeginDate { get; set; }
        public DateTime? EndDate { get; set; }
        public string TransferNote { get; set; }
        public int? AuthorityStatus { get; set; }
        public int IsDeleted { get; set; }
       
    }
}
