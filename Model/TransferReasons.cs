using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Model
{
   public class TransferReasons
    {
        [Key]
        public int ReasonId { get; set; }
        public string ReasonName { get; set; }
        public int ReasonStatus { get; set; }
    }
}
