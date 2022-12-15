namespace BLL.Models.Document.EntityModel
{
    public class AuthorModel
    {
        public int AuthorId { get; set; }
        public int? AuthorOrganizationId { get; set; }
        public string OrganizationName { get; set; }
        public string FullName { get; set; }
        public string AuthorDepartmentName { get; set; }
        public string PositionName { get; set; }
        public string PrevOrganization { get; set; }


        public string Token { get; set; }
    }
}
