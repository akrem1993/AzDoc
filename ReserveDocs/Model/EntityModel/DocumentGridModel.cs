using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ReserveDocs.Model.EntityModel
{
    public class DocumentGridModel
    {
        public int DocId { get; set; }

        [StringLength(50)]
        public string DocEnterno { get; set; }

        [Column(TypeName = "date")]
        [DisplayFormat(DataFormatString = "d")]
        public DateTime? DocEnterdate { get; set; }

        [StringLength(50)]
        public string DocDocno { get; set; }

        public string Signer { get; set; }
        public string SendTo { get; set; }

        [StringLength(2000)]
        public string DocDescription { get; set; }

        public string DocumentstatusName { get; set; }
        public string DocType { get; set; }
        public string DocOrganization { get; set; }
        public string WhomAdressedCompany { get; set; }

        public DateTime? DocDate { get; set; }
        public int? DocFormId { get; set; }
        public string CreaterPersonnelName { get; set; }

        public bool? ExecutorControlStatus { get; set; }


    }
}
