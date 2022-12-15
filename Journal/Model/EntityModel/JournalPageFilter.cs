
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace Journal.Model.EntityModel
{
    public class JournalPageFilter
    {

        public string currentPage { get; set; } = HttpContext.Current.Request.QueryString["page"];



    }
}
