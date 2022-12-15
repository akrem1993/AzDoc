namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public partial class DC_SEX : BaseEntity
    {
        public DC_SEX()
        {
            DC_PERSONNEL = new HashSet<DC_PERSONNEL>();
            DOCS_APPLICATION = new HashSet<DOCS_APPLICATION>();
            DOC_AUTHOR = new HashSet<DOC_AUTHOR>();
        }

        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int SexId { get; set; }

        [Required]
        [StringLength(10)]
        public string SexName { get; set; }

        public virtual ICollection<DC_PERSONNEL> DC_PERSONNEL { get; set; }

        public virtual ICollection<DOCS_APPLICATION> DOCS_APPLICATION { get; set; }

        public virtual ICollection<DOC_AUTHOR> DOC_AUTHOR { get; set; }
    }
}