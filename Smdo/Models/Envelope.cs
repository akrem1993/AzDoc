using System;
using System.Collections.Generic;
using System.Xml.Serialization;

namespace XmlModels
{
    [Serializable]
    [XmlRoot(ElementName = "Envelop")]
    public class Envelope<T> where T : class, new()
    {
        [XmlElement(ElementName = "Header")]
        public Header Header { get; set; }


        [XmlElement(ElementName = "Body")]
        public Body<T> Body { get; set; }


        [XmlAttribute(AttributeName = "dtstamp")]
        public string DtsTamp { get; set; }


        [XmlAttribute(AttributeName = "type")]
        public string Type { get; set; }


        [XmlAttribute(AttributeName = "msg_id")]
        public string MsgId { get; set; }

        [XmlAttribute(AttributeName = "subject")]
        public string Subject { get; set; }
    }

    [Serializable]
    [XmlRoot(ElementName = "Header")]
    public class Header
    {
        public Header()
        {
            Sender = new Sender();
            Receiver = new List<Receiver>();
        }

        [XmlElement(ElementName = "Sender")]
        public Sender Sender { get; set; }

        [XmlElement(ElementName = "Receiver")]
        public List<Receiver> Receiver { get; set; }


        [XmlAttribute(AttributeName = "msg_type")]
        public string MsgType { get; set; }


        [XmlAttribute(AttributeName = "msg_acknow")]
        public string MsgAcknow { get; set; }


        //[XmlElement(ElementName = "Integrity")]
        //public string Integrity { get; set; }
    }

    [XmlRoot(ElementName = "Sender")]
    public class Sender
    {
        public Sender() => Id = "AZ";


        [XmlAttribute(AttributeName = "id")]
        public string Id { get; set; }


        [XmlAttribute(AttributeName = "name")]
        public string Name { get; set; }


        [XmlAttribute(AttributeName = "sys_id")]
        public string SysId { get; set; }


        [XmlAttribute(AttributeName = "system")]
        public string System { get; set; }


        [XmlAttribute(AttributeName = "system_details")]
        public string SystemDetails { get; set; }
    }



}
