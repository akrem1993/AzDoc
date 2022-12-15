using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace Smdo.EmailModels
{
    public class EmailForm
    {
        public EmailForm()
        {
            Attaches = new List<AttachFile>();
        }

        public string ToEmail { get; set; } = "mailaz@prb.by";

        [Display(Name = "Subject")]
        [Required(ErrorMessage = "Email mövzusunu daxil edin.")]
        public string Subject { get; set; }

        [Display(Name = "Body")]
        [DataType(DataType.MultilineText)]
        [Required(ErrorMessage = "Email mətnini daxil edin.")]
        public string Body { get; set; }

        //[Display(Name = "Attachments")]
        //[Required(ErrorMessage = "Sənəd faylını daxil edin.")]
        //public List<string> AttachmentsPath { get; set; } = null;

        public List<AttachFile> Attaches { get; set; }

    }
}
