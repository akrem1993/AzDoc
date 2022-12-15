using System;
using System.Xml.Serialization;

namespace XmlModels
{
    [XmlRoot(ElementName = "Body")]
    public class Body<T> where T : class, new()
    {
        [XmlElement(ElementName = "Document")]
        public T BodyData { get; set; }

        [XmlElement(ElementName = "Acknowledgement")]
        public T BodyDataAck { get; set; }
    }
}
