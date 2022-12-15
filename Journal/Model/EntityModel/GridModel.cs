using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Journal.Model.EntityModel
{
    public class GridModel
    {
        public string DocumentDate { get; set; }
        public string DocumentNumber { get; set; }
        public string WhomAddress { get; set; }
        public string Sender { get; set; }
        public string DocEnterdate { get; set; }
        public string DocEnterno { get; set; }
        public string DocDescription1 { get; set; }
        public string DocDescription2 { get; set; }
        public string InfoResolution { get; set; }
        public int InfoResolution2 { get; set; }
        public string ExecutorName { get; set; }
        public string InfoDoc { get; set; }
        public string Icra_haqqda_qeyd { get; set; }
        public string Note1 { get; set; }
        public string Note { get; set; }
        public int DocId { get; set; }
        public string UserName { get; set; }

        public string CreateDate { get; set; }
        
    }

    public class GridModelDto
    {
        public string DocumentDateNumber { get; set; }
        public string EntryFromWho { get; set; }
        public string DocEnterInfo { get; set; }
        public string DocDescription { get; set; }
        public string InfoResolution { get; set; }
        public string ExecutorName { get; set; }
        public string InfoDoc { get; set; }
        public string Icra_haqqda_qeydN { get; set; }
        public string NoteInfo { get; set; }
        public int DocId { get; set; }
        public string EditNote { get; set; }

    }
}
