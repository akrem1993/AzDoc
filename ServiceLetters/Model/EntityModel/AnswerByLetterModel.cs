using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CustomHelpers.Attributes;

namespace ServiceLetters.Model.EntityModel
{
    public class AnswerByLetterModel
    {
        public int DocId { get; set; }
        public string DocEnterno { get; set; }
        public string DocumentInfo { get; set; }
        public int DocDoctypeId { get; set; }

        [NoUddtColumn]
        public int RelatedId { get; set; }
        public int? ResultId { get; set; }
    }
}
