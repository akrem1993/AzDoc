using System.Collections.Generic;
using System.Web.Mvc;

namespace DMSWeb.ViewModel
{
    public class ChangePageViewModel
    {
        public int SelectedId { get; set; }
        public List<SelectListItem> Pages { get; set; }
    }
}