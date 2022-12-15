using System.ComponentModel.DataAnnotations.Schema;

namespace DMSModel
{
    using Model.Entity;
    using System.ComponentModel.DataAnnotations;

    [Table("DOC_TOPIC")]
    public partial class DOC_TOPIC : BaseEntity
    {
        [Key]
        public int TopicId { get; set; }

        public int TopicTypeId { get; set; }

        public int? ParentTopicId { get; set; }

        [Required]
        public string TopicName { get; set; }

        public string TopicIndex { get; set; }

        public string TopicOrderIndex { get; set; }

        public bool TopicStatus { get; set; }
    }
}