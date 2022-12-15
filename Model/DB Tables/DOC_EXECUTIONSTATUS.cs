namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public partial class DOC_EXECUTIONSTATUS : BaseEntity
    {
        public DOC_EXECUTIONSTATUS()
        {
            DOCS_EXECUTOR = new HashSet<DOCS_EXECUTOR>();
        }

        [Key]
        public int ExecutionstatusId { get; set; }

        [Required]
        [StringLength(200)]
        public string ExecutionstatusName { get; set; }

        public bool ExecutionstatusStatus { get; set; }

        public virtual ICollection<DOCS_EXECUTOR> DOCS_EXECUTOR { get; set; }
    }
}