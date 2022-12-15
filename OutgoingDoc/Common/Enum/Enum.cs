using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OutgoingDoc.Enum
{
    public enum BasicInformation
    {

        WhomAddress = 8,
        TypeOfDocument = 1,
        SignatoryPerson = 2,
        SendForm = 3,
        ExecutionStatus = 5,
        RelatedDocument = 6,
        Author = 7,
        Result=9,
        Department=10,
        IntWhomAddress = 4,

    }
    public enum Result
    {
        Unsuccessful = 0,
        Success = 1
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
        Disposed=34,
        WaitforConfirming=36
    }
    public enum DocSaveStatus
    {
        Save = 0,
        Draft = 2,
        NotSave = 3
    }
    public enum OperationType
    {
        Insert = 1,
        Update = 2,
        Delete = 3
    }

    public enum Document
    {
        BasicInformation = 1,
        //DocumentInformation = 2,
        //AttachmentInformation = 3,       
        AnswerByOutDoc = 2,
        RelateDocumentByOutDoc = 3,
    }
    public enum ActionType
    {
        Send = 1,
        Edit = 2,
        Recognized = 3,
        SendForInformation = 4,
        Accept = 5,
        Signature = 7,
        Return = 9,
        Cancel = 6,
        Print = 15,
        Post = 16,
        NotSent = 17,
        Mailed = 10,
        Blank=21,
        Approve=24
    }

}
