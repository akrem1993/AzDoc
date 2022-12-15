using System.Collections.Generic;

namespace DMSModel
{
    using Model.Entity;
    using System.ComponentModel.DataAnnotations;

    public partial class DOC_TOPIC_TYPE : BaseEntity
    {
        [Key]
        public int TopicTypeId { get; set; }

        [Required]
        public string TopicTypeName { get; set; }

        public int? TopicTypeOrderIndex { get; set; }

        public bool TopicTypeStatus { get; set; }

        public int? OrganizationId { get; set; }

        public string CitizenTopic { get; set; }

        public string OrgTopic { get; set; }

        public string ColleagueTopic { get; set; }

    }
}