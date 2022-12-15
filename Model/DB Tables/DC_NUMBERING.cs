using Model.Entity;
using System.ComponentModel.DataAnnotations;

namespace DMSModel
{
    public partial class DC_NUMBERING : BaseEntity
    {
        public DC_NUMBERING()
        {
        }

        [Key]
        public int NumberingId { get; set; }

        public int NumberingSchemaId { get; set; }

        public int NumberingDoctypeId { get; set; }

        public int NumberingTypeId { get; set; }

        public int NumberingFunctionId { get; set; }

        public string NumberingFormat { get; set; }

        public string NumberingIndex { get; set; }

        public int NumberingPoolId { get; set; }

        public virtual DM_SCHEMA DM_SCHEMA { get; set; }

        public virtual DOC_TYPE DOC_TYPE { get; set; }

        public virtual DC_NUMBERINGTYPE DC_NUMBERINGTYPE { get; set; }

        public virtual DC_NUMBERINGFUNCTION DC_NUMBERINGFUNCTION { get; set; }

        public virtual DOC_POOL DOC_POOL { get; set; }
    }
}