namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public partial class DOC_TEMPLATE : BaseEntity
    {
        public DOC_TEMPLATE()
        {
            DOC_SELECTED_TEMPLATELABEL = new HashSet<DOC_SELECTED_TEMPLATELABEL>();
        }

        [Key]
        public int TemplateId { get; set; }

        public int TemplateSchemaId { get; set; }

        public int? TemplateDoctypeId { get; set; }

        public int? TemplateTypeId { get; set; }

        [Required]
        [StringLength(250)]
        public string TemplateName { get; set; }

        public string TemplateText { get; set; }

        [StringLength(4000)]
        public string TemplateSQL { get; set; }

        public int? TemplateSQLId { get; set; }

        public int? TemplateOrderindex { get; set; }

        public bool? TemplateStatus { get; set; }

        public virtual AC_SQL_QUERY AC_SQL_QUERY { get; set; }
        public virtual ICollection<DOC_SELECTED_TEMPLATELABEL> DOC_SELECTED_TEMPLATELABEL { get; set; }
    }
}