using System;

namespace CustomHelpers.Attributes
{
    [AttributeUsage(AttributeTargets.Property,AllowMultiple = false)]
    public class NoUddtColumnAttribute : Attribute
    {
    }
}
