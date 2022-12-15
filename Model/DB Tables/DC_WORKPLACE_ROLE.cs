using Model.Entity;

namespace DMSModel
{
    public partial class DC_WORKPLACE_ROLE : BaseEntity
    {
        public int Id { get; set; }

        public int WorkplaceId { get; set; }

        public int RoleId { get; set; }

        public bool Status { get; set; }

        public virtual DC_ROLE DC_ROLE { get; set; }

        public virtual DC_WORKPLACE DC_WORKPLACE { get; set; }
    }
}