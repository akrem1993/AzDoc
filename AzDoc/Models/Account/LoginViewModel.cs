using AzDoc.App_LocalResources;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Web.Mvc;

namespace AzDoc.Models.Account
{
    public class LoginViewModel
    {
        [Display(Name = "UserName", ResourceType = typeof(RLang))]
        [Required(ErrorMessageResourceType = typeof(RLang), ErrorMessageResourceName = "RequiredCell")]
        public string UserName { get; set; }

        [Display(Name = "Password", ResourceType = typeof(RLang))]
        [Required(ErrorMessageResourceType = typeof(RLang), ErrorMessageResourceName = "RequiredCell")]
        [DataType(DataType.Password)]
        public string Password { get; set; }

        [Display(Name = "Remember", ResourceType = typeof(RLang))]
        public bool Remember { get; set; }

        public string Message { get; set; }

        public int WorkPlaceId { get; set; }

        public string WorkPlaceValue { get; set; }

        public List<SelectListItem> WorkPlaces { get; set; }
    }
}