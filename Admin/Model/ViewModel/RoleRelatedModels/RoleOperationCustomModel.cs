using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Admin.Model.ViewModel.RoleRelatedModels
{
    public class RoleOperationCustomModel
    {
        public string RoleOperationId { get; set; }
        public int RightId { get; set; }
        public string RightName { get; set; }
        public int RightTypeId { get; set; }
        public string RightTypeName { get; set; }
        public int OperationId { get; set; }
        public string OperationName { get; set; }
    }
}
