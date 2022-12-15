namespace Model.DB_Tables
{
    public partial class AC_MENU
    {
        public int Id { get; set; }
        public int? ParentId { get; set; }
        public string Caption { get; set; }
        public string ControllerName { get; set; }
        public string ActionName { get; set; }
        public int? RequestUrl { get; set; }
        public int? OrderNo { get; set; }
        public bool? Show { get; set; }
        public bool? Add { get; set; }
        public bool? Edit { get; set; }
        public bool? Delete { get; set; }
    }
}