using AzDoc.App_LocalResources;
using System.ComponentModel.DataAnnotations;

namespace AzDoc.Models.Account
{
    public class ForgotPasswordViewModel
    {
        [Display(Name = "UserName", ResourceType = typeof(RLang))]
        [Required(ErrorMessageResourceType = typeof(RLang), ErrorMessageResourceName = "RequiredCell")]
        public string UserName { get; set; }

        [Display(Name = "ResetCode", ResourceType = typeof(RLang))]
        [Required(ErrorMessageResourceType = typeof(RLang), ErrorMessageResourceName = "RequiredCell")]
        [DataType(DataType.Password)]
        public string ResetCode { get; set; }

        [Display(Name = "Password", ResourceType = typeof(RLang))]
        [Required(ErrorMessageResourceType = typeof(RLang), ErrorMessageResourceName = "RequiredCell")]
        [StringLength(15, MinimumLength = 6)]
        [DataType(DataType.Password)]
        public string Password { get; set; }

        [Display(Name = "PasswordConfirm", ResourceType = typeof(RLang))]
        [System.ComponentModel.DataAnnotations.Compare("Password", ErrorMessageResourceType = typeof(RLang), ErrorMessageResourceName = "ConfirmPasswordCompare")]
        [DataType(DataType.Password)]
        public string PasswordConfirm { get; set; }
    }
}