namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public partial class DOC_DIRECTION_TEMPLATE : BaseEntity
    {
        public DOC_DIRECTION_TEMPLATE()
        {
            DOCS_DIRECTIONS = new HashSet<DOCS_DIRECTIONS>();
        }

        [Key]
        public int DirTemplateId { get; set; }

        public int DirTemplateTreeeId { get; set; }

        public int DirTemplateDirectionType { get; set; }

        public int DirTemplateWorkplaceId { get; set; }

        public bool DirTemplateStatus { get; set; }

        [Required]
        public string Template { get; set; }

        public virtual DC_TREE DC_TREE { get; set; }

        //public virtual DC_WORKPLACE DC_WORKPLACE { get; set; }

        public virtual DOC_DIRECTIONTYPE DOC_DIRECTIONTYPE { get; set; }

        public virtual ICollection<DOCS_DIRECTIONS> DOCS_DIRECTIONS { get; set; }
    }
}