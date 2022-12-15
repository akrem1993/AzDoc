using System;
using System.Collections.Generic;

namespace Smdo.Api.ApiModels
{
    public class File : Error
    {
        public string type { get; set; }
        public string name { get; set; }
        public string size { get; set; }
        public string hash { get; set; }
        public DateTime creationDate { get; set; }
    }

    public class DvcsModel : Error
    {
        public string id { get; set; }
        public string type { get; set; }
        public string status { get; set; }
        public DateTime creationDate { get; set; }
        public List<File> files { get; set; }
    }

    public class Error
    {
        public string error { get; set; }
        public string error_desscription { get; set; }
    }
}
