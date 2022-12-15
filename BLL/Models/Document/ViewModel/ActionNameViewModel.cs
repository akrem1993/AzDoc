using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BLL.Models.Document.ViewModel
{
    public class ActionNameViewModel
    {
        public IEnumerable<ChooseModel> ActionNameModels { get; set; }
        public int DocId { get; set; }
        public string Token { get; set; }

        public int ExecutorId { get; set; }
    }
}
