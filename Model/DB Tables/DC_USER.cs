using System.ComponentModel.DataAnnotations;
using DMSModel;
using Model.Entity;

namespace Model.DB_Tables
{
    public partial class DC_USER
    {
        //public DC_USER()
        //{
        //    DC_WORKPLACE = new HashSet<DC_WORKPLACE>();
        //}

        [Key]
        public int UserId { get; set; }

        public int? UserPersonnelId { get; set; }

        [Required]
        [StringLength(50)]
        public string UserName { get; set; }

        [StringLength(128)]
        public string UserPassword { get; set; }

        public int DefaultPage { get; set; }

        public bool UserStatus { get; set; }

        public bool? Notifications { get; set; }

        public virtual DC_PERSONNEL DC_PERSONNEL { get; set; }

        //public virtual ICollection<DC_WORKPLACE> DC_WORKPLACE { get; set; }
    }
}