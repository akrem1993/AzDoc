using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BLL.Models.Document.ViewModel
{
    public class SendForInformationViewModel
    {
        public int FormTypeId { get; set; }
        public int Id { get; set; }
        public string Name { get; set; }
        public int PositionGroupLevel { get; set; }
        public int DirectionConfirmed { get; set; }
    }
}
