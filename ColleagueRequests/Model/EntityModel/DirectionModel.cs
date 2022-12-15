using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ColleagueRequests.Model.EntityModel
{
    public class DirectionModel
    {
        [Key]
        public int DirectionId { get; set; }

        public int DirectionDocId { get; set; }

        public DateTime DirectionDate { get; set; }

        public int? DirectionWorkplaceId { get; set; }

        public int? DirectionPersonId { get; set; }

        [StringLength(500)]
        public string DirectionPersonFullName { get; set; }

        public int? DirectionTemplateId { get; set; }

        public int DirectionTypeId { get; set; }

        public bool DirectionControlStatus { get; set; }

        [Column(TypeName = "date")]
        public DateTime? DirectionPlanneddate { get; set; }

        public byte? DirectionPlannedDay { get; set; }

        public int? DirectionExecutionStatusId { get; set; }

        public int? DirectionVizaId { get; set; }

        public byte DirectionConfirmed { get; set; } = 1;

        public bool DirectionSendStatus { get; set; } = true;

        public int? DirectionCreatorWorkplaceId { get; set; }

        public DateTime? DirectionInsertedDate { get; set; }

        public long? DirectionUnixTime { get; set; }
    }
}