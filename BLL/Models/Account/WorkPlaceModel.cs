using System.ComponentModel.DataAnnotations;

namespace BLL.Models.Account
{
    public class WorkPlaceModel
    {
        [Key]
        public int WorkplaceId { get; set; }

        public int? WorkplaceUserId { get; set; }

        public int WorkplaceOrganizationId { get; set; }

        public int WorkplaceDepartmentId { get; set; }

        public int WorkplaceDepartmentPositionId { get; set; }
        public string WorkPlaceName { get; set; }
    }
}