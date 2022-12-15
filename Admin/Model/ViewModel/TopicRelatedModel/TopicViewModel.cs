using Admin.Model.EntityModel;
using System.Collections.Generic;

namespace Admin.Model.ViewModel.TopicRelatedModel
{
    public class TopicViewModel
    {
        public TopicViewModel()
        {
            TopicTypeInfos = new List<TopicTypeInfo>();
        }
        public bool IsEdit { get; set; }
        public TopicInfo TopicInfo { get; set; }
        public List<TopicTypeInfo> TopicTypeInfos { get; set; }

    }
}