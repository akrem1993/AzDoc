namespace DMSModel
{
    using Model.Entity;
    using System.ComponentModel.DataAnnotations;

    public partial class DC_SETTING : BaseEntity
    {
        [Key]
        public int SettingId { get; set; }

        [Required]
        [StringLength(50)]
        public string SettingKey { get; set; }

        [Required]
        [StringLength(500)]
        public string SettingValue { get; set; }

        [StringLength(500)]
        public string SettingDescription { get; set; }
    }
}