using System.ComponentModel.DataAnnotations;

namespace DMSModel
{
    public class VW_RESOLUTION_RIGHT
    {
        [Key]
        public long Id { get; set; }

        public int WorkplaceId { get; set; }
        public string FullName { get; set; }
    }
}