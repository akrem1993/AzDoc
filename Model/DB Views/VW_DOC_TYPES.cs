using System.ComponentModel.DataAnnotations;

namespace DMSModel
{
    public class VW_DOC_TYPES
    {
        [Key]
        public int KOD { get; set; }

        public int? NTOPKOD { get; set; }
        public int NORDERINDEX { get; set; }
        public int? TOPKOD { get; set; }
        public string NAME { get; set; }
        public string FILTR { get; set; }
        public int? DOCTYPE { get; set; }
    }
}