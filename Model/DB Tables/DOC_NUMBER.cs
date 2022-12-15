using Model.Entity;
using System.ComponentModel.DataAnnotations;

namespace DMSModel
{
    public partial class DOC_NUMBER : BaseEntity
    {
        public DOC_NUMBER()
        {
        }

        [Key]
        public int DocNumberId { get; set; }

        public int DocNumberPeriodId { get; set; }

        public int DocNumberOrganizationId { get; set; }

        public string DocNumberIndex { get; set; }

        public int DocNumberDocTypeId { get; set; }

        public int DocNumberPoolId { get; set; }
    }
}