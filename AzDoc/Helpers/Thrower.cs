using System;

namespace AzDoc.Helpers
{
    public class Thrower 
    {
        public static void Args(string arg)
        {
            throw new ArgumentException(arg);
        }

        public static void Ex(string msg)
        {
            throw new Exception(msg);
        }

        public static void NotAccept(string msg)
        {
            throw new UnauthorizedAccessException(msg);
        }
    }
}