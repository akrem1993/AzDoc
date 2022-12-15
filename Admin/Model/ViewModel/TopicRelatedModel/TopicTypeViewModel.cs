using Admin.Model.EntityModel;
using System.Collections.Generic;

namespace Admin.Model.ViewModel.TopicRelatedModel
{
    public class TopicTypeViewModel
    {
        public TopicTypeViewModel()
        {
            OrgViewModels = new List<OrgViewModel>();
        }
        public bool IsEdit { get; set; }
        public TopicTypeInfo TopicTypeInfo { get; set; }
        public List<OrgViewModel> OrgViewModels { get; set; }

        public int? LastInsertedIndex { get; set; }
    }
}
