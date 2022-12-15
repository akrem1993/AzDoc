using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ReserveDocs.Common.Enum
{
    public enum BasicInformation
    {

        WhomAddress = 8,
        TypeOfDocument = 1,
        SignatoryPerson = 2,
        FormOfDocument = 3,
        ExecutionStatus = 5,
        RelatedDocument = 6,
        Author = 7,
        Result = 9,
        Department = 10,
        IntWhomAddress = 4,

    }

    public enum DocumentStatus
    {
        Execution = 1,
        Executed = 12,
        Signed = 16,
        Mailed = 20,
        Printed = 27,
        Abandoned = 25,
        Registered = 15,
        SendToPerson = 8,
        IsViza = 28,
        GiveUpViza = 29,
        Signing = 30,
        Draft = 31,
        Disposed = 34
    }
    public enum DocSaveStatus
    {
        Save = 0,
        Draft = 2,
        NotSave = 3
    }
}
