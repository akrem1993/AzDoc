namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public partial class DC_RANK : BaseEntity
    {
        public DC_RANK()
        {
            DC_PERSONNEL = new HashSet<DC_PERSONNEL>();
        }

        [Key]
        public int RankId { get; set; }

        [StringLength(250)]
        public string RankName { get; set; }

        public bool RankStatus { get; set; }

        public virtual ICollection<DC_PERSONNEL> DC_PERSONNEL { get; set; }
    }
}