using Admin.Model.ViewModel;
using System.Collections.Generic;

namespace Admin.Model.EntityModel
{
    public class TopicTypeInfo
    {
        public int TopicTypeId { get; set; }
        public string TopicTypeName { get; set; }
        public int? TopicTypeOrderIndex { get; set; }
        public bool TopicTypeStatus { get; set; }
        public int? OrganizationId { get; set; }
        public string OrganizationShortname { get; set; }
        public string CitizenTopic { get; set; }
        public string OrgTopic { get; set; }
        public string ColleagueTopic { get; set; }
        public IEnumerable<TopicInfo> TopicInfos { get; set; }
    }
}