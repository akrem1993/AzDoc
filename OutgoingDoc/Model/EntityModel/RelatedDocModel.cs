using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CustomHelpers.Attributes;

namespace OutgoingDoc.Model.EntityModel
{
    public class RelatedDocModel
    {
        [NoUddtColumn]
        public int RelatedId { get; set; }
        public int DocId { get; set; }
        public string DocEnterno { get; set; }
        public string DocumentInfo { get; set; }
    }
}
