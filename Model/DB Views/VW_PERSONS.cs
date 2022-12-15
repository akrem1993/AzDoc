using System.ComponentModel.DataAnnotations;

namespace DMSModel
{
    public partial class VW_PERSONS
    {
        [Key]
        public int WorkplaceId { get; set; }

        [StringLength(250)]
        public string FullName { get; set; }
    }
}