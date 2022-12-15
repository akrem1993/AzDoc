using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BLL.Models.Document.EntityModel
{
    public class SendForInformationModel
    {
        public List<Person> Persons { get; set; }
    }

    public class Person
    {
        public int PersonId { get; set; }
    }
}
