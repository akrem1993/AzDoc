using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using BLL.Models.Document;

namespace BLL.Models.Account
{
    public class SettingModel
    {
        [Key]
        public int UserId { get; set; }

        public int? UserPersonnelId { get; set; }

        [Required]
        [StringLength(50)]
        public string UserName { get; set; }

        [StringLength(128)]
        public string UserPassword { get; set; }

        public int DefaultPage { get; set; }

        public bool UserStatus { get; set; }

        public bool? Notifications { get; set; }

        public ChangePasswordModel ChangePasswordModel { get; set; }


        public TreeModel TreeModel { get; set; }
        public IEnumerable<TreeModel> JsonTree { get; set; }
    }

    public class TreeModel
    {
        public int TreeDocTypeId { get; set; }
        public string TreeName { get; set; }
    }
    public class ChangePasswordModel
    {
        //    [Display(Name = "UserId", ResourceType = typeof(RLang))]
        //    [ScaffoldColumn(false)]
        public int? UserId { get; set; }

        //[Display(Name = "Password", ResourceType = typeof(RLang))]
        //[Required(ErrorMessageResourceType = typeof(RLang), ErrorMessageResourceName = "PasswordRequired")]
        [DataType(DataType.Password)]
        public string Password { get; set; }

        //[Display(Name = "PasswordNew", ResourceType = typeof(RLang))]
        //[Required(ErrorMessageResourceType = typeof(RLang), ErrorMessageResourceName = "PasswordNewRequired")]
        //[StringLength(50, ErrorMessageResourceType = typeof(RLang), ErrorMessageResourceName = "PasswordLenght", MinimumLength = 3)]
        [DataType(DataType.Password)]
        public string PasswordNew { get; set; }

        //[Display(Name = "PasswordConfirm", ResourceType = typeof(RLang))]
        //[Required(ErrorMessageResourceType = typeof(RLang), ErrorMessageResourceName = "PasswordConfirmRequired")]
        [DataType(DataType.Password)]
        [Compare("PasswordNew", ErrorMessage = "Şifrə uyğun deyil")]
        public string PasswordConfirm { get; set; }

        [Display(Name = "Message")]
        public string Message { get; set; }
    }

}
