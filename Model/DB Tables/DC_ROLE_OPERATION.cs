namespace DMSModel
{
    using Model.Entity;
    using System.ComponentModel.DataAnnotations;

    public partial class DC_ROLE_OPERATION : BaseEntity
    {
        [Key]
        public int RoleOperationId { get; set; }

        public int RoleId { get; set; }

        public int OperationId { get; set; }

        public int? RightId { get; set; }

        public int? RightTypeId { get; set; }

        //public virtual DC_OPERATION DC_OPERATION { get; set; }

        //public virtual DC_RIGHT DC_RIGHT { get; set; }

        //public virtual DC_RIGHT_TYPE DC_RIGHT_TYPE { get; set; }

        //public virtual DC_ROLE DC_ROLE { get; set; }
    }
}