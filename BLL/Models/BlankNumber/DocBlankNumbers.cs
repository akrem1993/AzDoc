using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BLL.Models.BlankNumber
{
    public class DocBlankNumbers
    {
        public int BlankId { get; set; }
        public int BlankDocId { get; set; }
        public int BlanDocType { get; set; }
        public byte BlankDeleted  { get; set; }
        public List<BlankNumberModel> BlankNumbers { get; set; }
    }
}
