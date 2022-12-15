using Model.Entity;
using System;
using System.ComponentModel.DataAnnotations;

namespace DMSModel
{
    public partial class DMS_APP_VERSION : BaseEntity
    {
        [Key]
        public int ID { get; set; }

        [Required]
        public int MajorVersion { get; set; }

        [Required]
        public int MinorVersion { get; set; }

        [Required]
        public int BuildVersion { get; set; }

        [Required]
        public string ApplicationType { get; set; }

        [Required]
        public string CreatedBy { get; set; }

        [Required]
        public DateTime PublishDate { get; set; }
    }
}