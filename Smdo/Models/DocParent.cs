using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;
using XmlModels;

namespace Smdo.Models
{
    [XmlRoot(ElementName = "DocParent")]
    public class DocParent
    {
        [XmlElement(ElementName = "RegNumber")]
        public RegNumber RegNumber { get; set; }

        [XmlAttribute(AttributeName = "idnumber")]
        public string Idnumber { get; set; }

        [XmlAttribute(AttributeName = "lastmsg_id")]
        public string Lastmsg_id { get; set; }

        [XmlAttribute(AttributeName = "parmsg_id")]
        public string Parmsg_id { get; set; }

        [XmlAttribute(AttributeName = "delivery_type")]
        public string Delivery_type { get; set; }

        [XmlAttribute(AttributeName = "parorg_id")]
        public string Parorg_id { get; set; }
    }
}
