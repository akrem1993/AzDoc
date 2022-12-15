using System.ComponentModel.DataAnnotations;

namespace BLL.Models.Account
{
    public class UserModel
    {
        [Key]
        public int UserId { get; set; }

        public int? UserPersonnelId { get; set; }

        [Required]
        [StringLength(50)]
        public string UserName { get; set; }

        [StringLength(128)]
        public string UserPassword { get; set; }

        public string PersonFullName { get; set; }

        public string DepartmentPositionName { get; set; }

        public int DefaultPage { get; set; }

        public bool UserStatus { get; set; }

        public bool? Notifications { get; set; }

        public int WorkPlaceId { get; set; }

        public string DefaultLang { get; set; }

        public int WorkPlacesCount { get; set; }

        public int? DepartmentOrganization { get; set; }

        public int? DepartmentTopDepartmentId { get; set; }

        public int? DepartmentId { get; set; }

        public int? DepartmentSectionId { get; set; }

        public int? DepartmentSubSectionId { get; set; }
        public int AdminPermissionCount { get; set; }
        public int SuperAdminPermissionCount { get; set; }
        public string UserFin { get; set; }
        public int? DepartmentCode { get; set; }
        public bool IsPasswordExpire { get; set; }
    }
}