using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BLL.Models.Report
{
    public class JsonDocIds
    {
        [JsonProperty("DocId")]
        public int DocId { get; set; }
    }
}
