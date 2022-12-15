using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Model.Models.Viza
{
    public class VizaModel
    {
        public int? VizaId { get; set; }
        public int WorkplaceId { get; set; }
        public string VizaPersonName { get; set; }
        public int? OrderIndex { get; set; }
        public bool IsChief { get; set; }
        public int AnswerDocId { get; set; }
        public bool IsDeleted { get; set; }
    }
}
