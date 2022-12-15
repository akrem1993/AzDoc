using Model.Entity;
using System.ComponentModel.DataAnnotations;
using Model.DB_Tables;

namespace DMSModel
{
    public partial class DOC_NUMBERS : BaseEntity
    {
        [Key]
        public int DocNumberId { get; set; }

        public int DocNumberPeriodId { get; set; }

        public int DocNumberOrganizationId { get; set; }

        public int DocNumberTypeId { get; set; }

        public string DocNumberIndex { get; set; }

        public int DocNumberPoolId { get; set; }

        public int DocNumberCurrentNumber { get; set; }

        public virtual DOC_PERIOD DOC_PERIOD { get; set; }

        public virtual DC_ORGANIZATION DC_ORGANIZATION { get; set; }

        public virtual DC_NUMBERINGTYPE DC_NUMBERINGTYPE { get; set; }

        public virtual DOC_POOL DOC_POOL { get; set; }
    }
}