using System.Xml.Serialization;

namespace XmlModels
{
    [XmlRoot(ElementName = "Receiver")]
    public class Receiver
    {
        [XmlElement(ElementName = "Organization")]
        public Organization Organization { get; set; }

        [XmlAttribute(AttributeName = "id")]
        public string Id { get; set; }

        [XmlAttribute(AttributeName = "name")]
        public string Name { get; set; }



        //[XmlAttribute(AttributeName = "system")]
        //public string System { get; set; }

        //[XmlElement(ElementName = "Referrer")]
        //public Referrer Referrer { get; set; }
    }

    //[XmlRoot(ElementName = "PrivatePerson")]
    //public class PrivatePerson
    //{
    //    [XmlAttribute(AttributeName = "Name")]
    //    public string Name { get; set; }

    //    [XmlAttribute(AttributeName = "Rank")]
    //    public string Rank { get; set; }

    //    [XmlAttribute(AttributeName = "Address")]
    //    public string Address { get; set; }

    //    [XmlAttribute(AttributeName = "Econtact")]
    //    public string Econtact { get; set; }
    //}

    [XmlRoot(ElementName = "Referrer")]
    public class Referrer
    {
        [XmlAttribute(AttributeName = "RegNumber")]
        public string RegNumber { get; set; }

        [XmlAttribute(AttributeName = "TaskNumber")]
        public string TaskNumber { get; set; }
    }


    [XmlRoot(ElementName = "Organization")]
    public class Organization
    {
        [XmlElement(ElementName = "Address")]
        public string Address { get; set; }

        [XmlAttribute(AttributeName = "organization_string")]
        public string OrganizationString { get; set; }

        [XmlAttribute(AttributeName = "fullname")]
        public string FullName { get; set; }

        [XmlAttribute(AttributeName = "shortname")]
        public string ShortName { get; set; }
    }
}
