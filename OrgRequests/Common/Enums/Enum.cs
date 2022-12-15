namespace OrgRequests.Common.Enums
{
    public enum Result
    {
        Unsuccessful = 0,
        Success = 1
    }

    public enum Document
    {
        BasicInformation = 1,
        DocumentInformation = 2,
        AttachmentInformation = 3
    }

    public enum BasicInformation
    {
        TopicTypeName = 1,
        WhomAddress = 2,
        ReceivedForm = 3,
        TypeOfDocument = 4,
        ExecutionStatus = 5,
        RelatedDocument = 6,
        Author=7
    }

    public enum DocumentInformation
    {
        TypeOfAssignment = 6,
        TaskCycle = 7,
        WhomAddressed = 8
    }

    public enum OperationType
    {
        Insert = 1,
        Update = 2,
        Delete = 3
    }

    public enum DocSaveStatus
    {
        Save = 0,
        Draft = 2,
        NotSave = 3
    }

    public enum ActionType
    {
        Send = 1,
        Edit = 2,
        Recognized = 3,
        SendForInformation = 4,
        Accept = 5,
        Disclaim = 6,
        Signature = 7
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
        Draft = 31
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
}