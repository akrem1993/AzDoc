namespace BLL.Common.Enums
{
    public enum DocType
    {
        None = -1,
        OrgRequests = 1,
        CitizenRequests = 2,
        InsDoc = 3,
        ServiceLetters = 18,
        OutGoing = 12,
        ReserveDocs = 25,
        Smdo=89,
        ColleagueRequests = 27
    }

    public enum DirectionType
    {
        Resolution = 1,
        According = 2,
        Viza = 3,
        NewDocument = 4,
        Answer = 5,
        ChangeExecutor = 6,
        ChangePlanneddate = 7,
        Signature = 8,
        PrintDoc = 9,
        SendToPost = 10,
        CreateResolution = 11,
        ApproveResolution = 12,
        GiveUpViza = 13,
        GiveUpSign = 14,
        Agreement = 15,
        DefaultViza = 16,
        ExecuteServiceLetter = 17
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
        Disposed=34
    }

    public enum DirectConfirmed
    {
        None = 0,
        Confirmed = 1,
        Reject = 2
    }

    public enum SendStatus
    {
        Execution = 1,
        ExecutionAndInfo = 2,
        Info = 3,
        InfoAndControl = 4,
        ConfirmDirection = 5,
        ChangePlanneddate = 6,
        ConfirmViza = 7,
        Sign = 8,
        SendToPost = 9,
        ChangeExecutor = 10,
        Print = 11,
        Agreement = 12
    }
}