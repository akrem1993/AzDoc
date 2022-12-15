using System;
using System.IO;
using System.Text;
using System.Xml;
using System.Xml.Serialization;

namespace Helpers
{
    public static class Serializers
    {
        public static string Serialize<T>(this T val) where T : class
        {
            if (val is null) throw new ArgumentNullException();

            var serializer = new XmlSerializer(typeof(T));

            using (var stringWriter = new Utf8StringWriter())
            {
                using (var xmlWriter = XmlWriter.Create(stringWriter))
                {
                    XmlSerializerNamespaces namespaces = new XmlSerializerNamespaces();
                    namespaces.Add("", "");
                    serializer.Serialize(xmlWriter, val, namespaces);
                    string xml = stringWriter.ToString();
                    return xml;
                }
            }
        }

        public static T Deserialize<T>(this string val) where T : class
        {
            if (string.IsNullOrEmpty(val)) throw new ArgumentNullException();

            var serializer = new XmlSerializer(typeof(T));

            using (var stringReader = new StringReader(val.Trim()))
            {
                T obj = (T)serializer.Deserialize(stringReader);

                return obj;
            }
        }


        public class Utf8StringWriter : StringWriter
        {
            public override Encoding Encoding => Encoding.UTF8;
        }
    }
}
