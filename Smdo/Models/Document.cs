using System;
using System.Xml.Serialization;
using Smdo.Models;

namespace XmlModels
{
    [XmlRoot(ElementName = "Document")]
    public class Document
    {
        [XmlElement(ElementName = "RegNumber")]
        public RegNumber RegNumber { get; set; }


        [XmlElement(ElementName = "Confident")]
        public Confident Confident { get; set; }


        [XmlElement(ElementName = "DocParent")]
        public DocParent DocParent { get; set; }


        [XmlElement(ElementName = "Referred")]
        public Referrer Referred { get; set; }


        [XmlElement(ElementName = "DocTransfer")]
        public DocTransfer DocTransfer { get; set; }


        [XmlElement(ElementName = "DocNumber")]
        public DocNumber DocNumber { get; set; }


        [XmlElement(ElementName = "RegHistory")]
        public RegHistory RegHistory { get; set; }


        [XmlElement(ElementName = "Author")]
        public Author Author { get; set; }




        [XmlAttribute(AttributeName = "idnumber")]
        public string IdNumber { get; set; }


        [XmlAttribute(AttributeName = "type")]
        public string Type { get; set; }


        [XmlAttribute(AttributeName = "kind")]
        public string Kind { get; set; }


        [XmlAttribute(AttributeName = "pages")]
        public string Pages { get; set; }


        [XmlAttribute(AttributeName = "title")]
        public string Title { get; set; }
    }

    [XmlRoot(ElementName = "RegHistory")]
    public class RegHistory
    {
        public RegHistory() => RegNumber = new RegNumber();

        public OrganizationOnly OrganizationOnly { get; set; }

        public RegNumber RegNumber { get; set; }
    }


    [XmlRoot(ElementName = "DocNumber")]
    public class DocNumber
    {
        public DocNumber() => RegNumber = new RegNumber();

        public OrganizationOnly OrganizationOnly { get; set; }

        public RegNumber RegNumber { get; set; }
    }


    [XmlRoot(ElementName = "OrganizationOnly")]
    public class OrganizationOnly
    {
        [XmlAttribute(AttributeName = "Address")]
        public string Address { get; set; }

        [XmlAttribute(AttributeName = "Econtact")]
        public string Econtact { get; set; }
    }

    [XmlRoot(ElementName = "RegNumber")]
    public class RegNumber
    {
        [XmlAttribute(AttributeName = "regdate")]
        public string RegDate { get; set; } = DateTime.Now.ToString("YYYY-MM-DDThh:mm:ssTZD");

        [XmlText]
        public string Text { get; set; }
    }

    [XmlRoot(ElementName = "Confident")]
    public class Confident
    {
        [XmlAttribute(AttributeName = "flag")]
        public string Flag { get; set; }

        [XmlText]
        public string Text { get; set; }
    }

    [XmlRoot(ElementName = "Data")]
    public class Data
    {
        [XmlAttribute(AttributeName = "referenceid")]
        public string ReferenceId { get; set; }
    }

    [XmlRoot(ElementName = "Signature")]
    public class Signature
    {
        [XmlAttribute(AttributeName = "signer")]
        public string Signer { get; set; }


        [XmlAttribute(AttributeName = "signtime")]
        public string SignTime { get; set; } = DateTime.Now.ToString("YYYY-MM-DDThh:mm:ssTZD");

        [XmlText]
        public string Text { get; set; }
    }

    [XmlRoot(ElementName = "DocTransfer")]
    public class DocTransfer
    {
        [XmlElement(ElementName = "Data")]
        public Data Data { get; set; }


        [XmlElement(ElementName = "Signature")]
        public Signature[] Signature { get; set; }


        [XmlAttribute(AttributeName = "name")]
        public string Name { get; set; }
    }

    [XmlRoot(ElementName = "OfficialPersonWithSign")]
    public class OfficialPersonWithSign
    {
        [XmlElement(ElementName = "Name")]
        public string Name { get; set; }
    }

    [XmlRoot(ElementName = "OrganizationWithSign")]
    public class OrganizationWithSign
    {

        [XmlElement(ElementName = "OfficialPersonWithSign")]
        public OfficialPersonWithSign OfficialPersonWithSign { get; set; }

        [XmlAttribute(AttributeName = "organization_string")]
        public string OrganizationString { get; set; }
    }

    [XmlRoot(ElementName = "Author")]
    public class Author
    {
        [XmlElement(ElementName = "OrganizationWithSign")]
        public OrganizationWithSign OrganizationWithSign { get; set; }

    }



}
