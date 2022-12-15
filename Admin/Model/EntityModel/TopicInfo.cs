namespace Admin.Model.EntityModel
{
    public class TopicInfo
    {
        public int? TopicId { get; set; }
        public int TopicTypeId { get; set; }
        public int? ParentTopicId { get; set; }
        public string TopicTypeName { get; set; }
        public string TopicName { get; set; }
        public string TopicOrderIndex { get; set; }
        public string TopicIndex { get; set; }
        public bool TopicStatus { get; set; }
        public TopicTypeInfo TopicTypeInfo { get; set; }
    }
}