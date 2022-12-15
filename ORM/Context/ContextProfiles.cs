using System.Configuration;
using System.Linq;

namespace ORM.Context
{
    public static class ContextProfiles
    {
        public static readonly string ConnectionString;
        public static DbType Db;

        static ContextProfiles()
        {
            Db = DbType.None;

#if !DEBUG
            ConnectionString = ConfigurationManager.ConnectionStrings["DmsDbContext"].ConnectionString;
            Db = DbType.Production;
#endif
#if DEBUG
            ConnectionString = ConfigurationManager.ConnectionStrings["DmsDbContext"].ConnectionString;
            Db = DbType.Test;
#endif
        }

        public static string DbSource
        {
            get
            {
                if (Db == DbType.Production)
                    return "";

                return ConnectionString.Split(';').Any()
                    ?
                    ConnectionString.Split(';')[0]
                    :
                    "";
            }
        }
    }

    public enum DbType
    {
        None = 0,
        Production,
        Test,
        PreProduction
    }
}
