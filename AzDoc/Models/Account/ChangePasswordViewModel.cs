using AzDoc.App_LocalResources;
using System.ComponentModel.DataAnnotations;

namespace AzDoc.Models.Account
{
    public class ChangePasswordViewModel
    {
        [Display(Name = "UserId", ResourceType = typeof(RLang))]
        [ScaffoldColumn(false)]
        public int? UserId { get; set; }

        [Display(Name = "Password", ResourceType = typeof(RLang))]
        [Required(ErrorMessageResourceType = typeof(RLang), ErrorMessageResourceName = "PasswordRequired")]
        [DataType(DataType.Password)]
        public string Password { get; set; }

        [Display(Name = "PasswordNew", ResourceType = typeof(RLang))]
        [Required(ErrorMessageResourceType = typeof(RLang), ErrorMessageResourceName = "PasswordNewRequired")]
        [StringLength(50, ErrorMessageResourceType = typeof(RLang), ErrorMessageResourceName = "PasswordLenght", MinimumLength = 3)]
        [DataType(DataType.Password)]
        public string PasswordNew { get; set; }

        [Display(Name = "PasswordConfirm", ResourceType = typeof(RLang))]
        [Required(ErrorMessageResourceType = typeof(RLang), ErrorMessageResourceName = "PasswordConfirmRequired")]
        [DataType(DataType.Password)]
        [Compare("PasswordNew", ErrorMessage = "Şifrə uyğun deyil")]
        public string PasswordConfirm { get; set; }

        [Display(Name = "Message")]
        public string Message { get; set; }
    }
}