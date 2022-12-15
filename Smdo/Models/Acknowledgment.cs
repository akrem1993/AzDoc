using System;
using System.Xml.Serialization;

namespace XmlModels
{
    /// <summary>
    /// Notify from SMDO
    /// </summary>
    [XmlRoot(ElementName = "Acknowledgement")]
    public class Acknowledgement
    {
        [XmlElement(ElementName = "RegNumber")]
        public RegNumber RegNumber { get; set; }

        
        [XmlElement(ElementName = "IncNumber")]
        public IncNumber IncNumber { get; set; }


        [XmlElement(ElementName = "AckResult")]
        public AckResult AckResult { get; set; }

        
        [XmlAttribute(AttributeName = "msg_id")]
        public string MsgId { get; set; }

        
        [XmlAttribute(AttributeName = "ack_type")]
        public string AckType { get; set; }
    }

    [XmlRoot(ElementName = "AckResult")]
    public class AckResult
    {
        
        [XmlAttribute(AttributeName = "errorcode")]
        public string ErrorCode { get; set; }
        [XmlText]
        public string Text { get; set; }
    }


    [XmlRoot(ElementName = "IncNumber")]
    public class IncNumber
    {
        [XmlAttribute(AttributeName = "regdate")]
        public string RegDate { get; set; }
        [XmlText]
        public string Text { get; set; }
    }

}
