using System;
using BLL.Common.Enums;

namespace AzDoc.Attributes
{
    [AttributeUsage(AttributeTargets.Class)]
    public class DocTypeMarkAttribute : Attribute
    {
        public DocType DocType { get; }

        public DocTypeMarkAttribute(DocType docType) => DocType = docType;
    }
}