using Model.Entity;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace DMSModel
{
    public partial class DC_REQUEST : BaseEntity
    {
        public DC_REQUEST()
        {
            DC_REQUESTFILES = new HashSet<DC_REQUESTFILES>();
            DC_REQUESTANSWER = new HashSet<DC_REQUESTANSWER>();
        }

        [Key]
        public int RequestId { get; set; }

        [Required]
        public string RequestText { get; set; }

        public DateTime RequestDate { get; set; }

        public int RequestStatusId { get; set; }

        public int WorkPlaceId { get; set; }

        public int RequestTypeId { get; set; }

        public DateTime InsertDate { get; set; }

        public bool RequestStatus { get; set; }

        public virtual DC_REQUESTSTATUS DC_REQUESTSTATUS { get; set; }

        public virtual DC_REQUESTTYPE DC_REQUESTTYPE { get; set; }

        public virtual DC_WORKPLACE DC_WORKPLACE { get; set; }

        public virtual ICollection<DC_REQUESTFILES> DC_REQUESTFILES { get; set; }
        public virtual ICollection<DC_REQUESTANSWER> DC_REQUESTANSWER { get; set; }
    }
}