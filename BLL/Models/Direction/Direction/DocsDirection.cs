using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BLL.Models.Direction
{
    public class DocsDirection
    {
        public int DirectionId { get; set; }
        public int DirectionDocId { get; set; }
        public DateTime DirectionDate { get; set; }
        public int DirectionWorkplaceId { get; set; }
        public string DirectionPersonFullName { get; set; }
        public int? DirectionTemplateId { get; set; }
        public int DirectionTypeId { get; set; }
        public bool DirectionControlStatus { get; set; }
        public DateTime? DirectionPlanneddate { get; set; }

        public int? DirectionVizaId { get; set; }
        public byte DirectionConfirmed { get; set; }
        public bool DirectionSendStatus { get; set; }
        public int? DirectionCreatorWorkplaceId { get; set; }
        public DateTime DirectionInsertedDate { get; set; }
        public int? DirectionPersonId { get; set; }
        public System.Int64 DirectionUnixTime { get; set; }
        public int? ChangeType { get; set; }
        public string MainExecutor { get; set; }
        public string CommonExecutors { get; set; }

    }
}
