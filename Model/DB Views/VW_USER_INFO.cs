using System;
using System.ComponentModel.DataAnnotations;

namespace DMSModel
{
    public class VW_USER_INFO
    {
        [Key]
        public int USERID { get; set; }

        public int KOD { get; set; }
        public int ORGANIZATION { get; set; }
        public string ORGANIZATIONNAME { get; set; }
        public string NAME { get; set; }
        public int SEKTOR { get; set; }
        public int DEPARTMENT { get; set; }
        public string DEPARTMENT_NAME { get; set; }
        public string EMAIL { get; set; }
        public DateTime LASTPASSWORDCHANGEDDATE { get; set; }
        public string BPRODOC_TYPE { get; set; }
        public int ISSUPERVISER { get; set; }
    }
}