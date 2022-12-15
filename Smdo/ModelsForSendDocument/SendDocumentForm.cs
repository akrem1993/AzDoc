using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace Smdo.ModelsForSendDocument
{
    public class SendDocumentForm
    {
        [Required]
        public List<HttpPostedFileBase> filesForSend { get; set; } = null;

        [Required]
        public string mailAddress { get; set; }/* = "bigrios19@gmail.com";*/


    }
}
