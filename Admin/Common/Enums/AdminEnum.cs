using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Admin.Common.Enums
{
    public enum UserOperation
    {
        UserGrid=1,
        UserInfo=2
    }

    public enum formTypes
    {
        FromPerson = 1,
        ToPerson = 2,
        TransferReasons=3,
        EditDocument = 4,
        CloseReadStatus =5,
        FetchPersons=6,
        SpecialPersons=7,
        RedirectToPerson=8,
        PassVizaFromPerson=9,
        GetUserStatistics=10,
        ChangeDocStatus=11
    }

   

}
