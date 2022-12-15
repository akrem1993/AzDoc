using System.Collections.Generic;
using System.Xml.Serialization;

namespace AzDoc.Models.Common
{
    /// <remarks/>
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [XmlType(AnonymousType = true)]
    [XmlRoot(Namespace = "", IsNullable = false)]
    public partial class Menu
    {
        private List<Group> groupField;

        /// <remarks/>
        [XmlElement("group")]
        public List<Group> group
        {
            get
            {
                return this.groupField;
            }
            set
            {
                this.groupField = value;
            }
        }
    }

    /// <remarks/>
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [XmlTypeAttribute(AnonymousType = true)]
    public partial class Group
    {
        private List<Item> itemField;

        private string textField;

        /// <remarks/>
        [XmlElementAttribute("item")]
        public List<Item> item
        {
            get
            {
                return this.itemField;
            }
            set
            {
                this.itemField = value;
            }
        }

        /// <remarks/>
        [XmlAttributeAttribute()]
        public string Text
        {
            get
            {
                return this.textField;
            }
            set
            {
                this.textField = value;
            }
        }
    }

    /// <remarks/>
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [XmlTypeAttribute(AnonymousType = true)]
    public partial class Item
    {
        private int id;

        private string navigateUrlField;

        private string textField;

        /// <remarks/>
        [XmlAttributeAttribute()]
        public int Id
        {
            get
            {
                return this.id;
            }
            set
            {
                this.id = value;
            }
        }

        /// <remarks/>
        [XmlAttributeAttribute()]
        public string NavigateUrl
        {
            get
            {
                return this.navigateUrlField;
            }
            set
            {
                this.navigateUrlField = value;
            }
        }

        /// <remarks/>
        [XmlAttributeAttribute()]
        public string Text
        {
            get
            {
                return this.textField;
            }
            set
            {
                this.textField = value;
            }
        }
    }
}