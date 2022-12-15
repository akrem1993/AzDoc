using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BLL.Models.Document
{
    public class ChooseModel
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int FormTypeId { get; set; }
        public string Token { get; set; }

    }
}
