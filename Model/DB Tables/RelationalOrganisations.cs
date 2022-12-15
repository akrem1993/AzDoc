namespace DMSModel
{
    using Model.Entity;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public partial class RelationalOrganisations : BaseEntity
    {           
        public int Id { get; set; }
        public int? IndividualCode { get; set; }
        public string NameRelOrg { get; set; }
        public bool Status { get; set; }
    }
}