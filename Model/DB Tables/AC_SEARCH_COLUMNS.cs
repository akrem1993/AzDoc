namespace DMSModel
{
    using Model.Entity;
    using System.ComponentModel.DataAnnotations;

    public partial class AC_SEARCH_COLUMNS : BaseEntity
    {
        public int Id { get; set; }

        public int SchemaId { get; set; }

        public byte SearchType { get; set; }

        public int DocTypeId { get; set; }

        public int? WorkPlaceId { get; set; }

        [Required]
        [StringLength(100)]
        public string FieldName { get; set; }

        [Required]
        [StringLength(100)]
        public string Caption { get; set; }

        public byte Width { get; set; }

        public byte? OrderNumber { get; set; }

        public bool IsDefault { get; set; }

        public virtual DC_WORKPLACE DC_WORKPLACE { get; set; }

        public virtual DOC_TYPE DOC_TYPE { get; set; }
    }
}