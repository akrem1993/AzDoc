using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CustomHelpers.Attributes;

namespace ServiceLetters.Model.EntityModel
{
    public class RelateDocumentByServiceLetterModel
    {
        public int DocId { get; set; }

        [NoUddtColumn]
        public int RelatedId { get; set; }
        public string DocEnterno { get; set; }
        public string DocumentInfo { get; set; }
    }
}
