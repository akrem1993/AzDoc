using System.ComponentModel;

namespace BLL.Common.Enums.DMSEnums//OBSOLETE
{
    //public enum DBResultOutputParameter
    //{
    //    Unsuccessful = -1,
    //    NoPermissionUser = 0,
    //    Success = 1,
    //    NoPermissionUserResetCode = 2,
    //    UnknownError = 3
    //}

    public enum VizaAgreementType
    {
        Viza = 1,
        Agreement = 2
    }

    public enum DocDeletedStatus
    {
        Save = 0,
        Draft = 2,
        NotSave = 3
    }

    public enum SignatureStatus
    {
        NotSigned = 1,
        Signed = 2,
        Abandoned = 3
    }

    public enum SQLQuery
    {
        Signer = 8,
        RezerSigner = 45,
        ResolutionPrefix = 52,
        ResolutionSuffix = 53,
        DefaultVizaPositionGroup = 67
    }

    public enum RelatedType
    {
        RelatedDoc = 1,
        Answer = 2
    }

    public enum DMSControls
    {
        TextBox = 2,
        ButtonEdit = 3,
        CheckBox = 4,
        ComboBox = 5,
        DateEdit = 6,
        SpinEdit = 7,
        TimeEdit = 8,
        ColorEdit = 9,
        DropDownEdit = 10,
        Memo = 11,
        Image = 12,
        HyperLink = 13,
        Persons = 14,
        Files = 15,
        RelatedDoc = 16,
        HTMLEditor = 17,
        OrganizationsGrid = 18,
        OrganizationsAuthorGrid = 19,
        DMSAnswer = 20,
        TabPages = 21,
        Panel = 22,
        DMSApplicant = 23,
        Duplicate = 24,
        QuestionList = 25,
        RoundPanel = 28,
        ContactTable = 29,
        DocInfoGrid = 30,
        Reply = 31,
        SendLocal = 32,
        DuplicatePanel = 33,
        RelatedList = 34,
        AgreementPerson = 35
    }

    public enum ApplierType
    {
        Individual = 1,
        Juridical = 2,
        IndividualCol = 3,
        JuridicalCol = 4
    }

    public enum Representer
    {
        Applicant = 1,
        Representative = 2
    }

    public enum AppView
    {
        AddDocument = 1,
        Execution = 2,
        Applicant = 3,
        Files = 4
    }

    public enum DMSOperationType
    {
        Update,
        Insert
    }

    public enum CellSelectionMode
    {
        Single = 1,
        Multiple = 2
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

    public enum AdrType
    {
        [Description("F")]
        From = 1,

        [Description("T")]
        To = 2,

        [Description("O")]
        Organization = 3
    }

    public enum GridLookupPersonsType
    {
        PersonFrom = 1,
        PersonTo = 2,
        PersonApprove = 3
    }

    public enum DML
    {
        INSERT,
        UPDATE,
        DELETE
    }

    public enum RDMS
    {
        SQLServer,
        Oracle
    }

    public enum Right
    {
        Yes = 0,
        CreatePersonelDocument = 1,
        SendToPerson = 2,
        CreateSector = 3,
        SendSector = 4,
        CreateSection = 5,
        SendSection = 6,
        CreateDepartament = 8,
        SendDepartament = 9,
        CreateTopDepartament = 10,
        SendTopDepartament = 11,
        ViewControl = 28,
        AllDocument = 32
    }

    public enum RightType
    {
        View = 1,
        Insert = 2,
        Update = 3,
        RegistrationPaper = 4,
        Answer = 5,
        EDocument = 6,
        Resolution = 7,
        SendToPerson = 8,
        ExecutionStatus = 9,
        MenuDocument = 10,
        MenuAdminPanel = 11,
        MenuService = 12,
        DocumentNumberEdit = 13,
        Reserve = 14,
        MistakenDocument = 15,
        Mailed = 16,
        ReturnDocument = 17,
        PrintDoc = 18,
        SendForResolution = 19
    }

    public enum OperationType
    {
        CaseMenu = 1,
        Document = 2,
        ControlWindow = 3,
        TopMenu = 4,
        Handbook = 5,
        Other = 6,
        Report = 7
    }

    public enum OrgGroupType
    {
        ControlUp = 1,
        ControlDown
    }

    public enum VizaFromWorkflow
    {
        Chief = 1,
        Resolution = 2,
        Viza = 3
    }

    public enum VizaStatus
    {
        NotViza = 0,
        IsViza = 1,
        ConfirmViza = 2,
        RejectionVizaViza = 3,
        Signed = 4
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

   

    public enum DirectionInfoChange
    {
        ChangeExecutor = 1,
        ChangePlanneddate = 2
    }

    public enum NumberingType
    {
        EnterNo = 1,
        Viza = 2,
        Apell = 3,
        Draft = 4
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

    public enum DocTypeGroup
    {
        Incoming = 1,
        Posted = 2,
        Internal = 3,
        Subordinate = 4
    }

    public enum DocType
    {
        OrganizationApp = 1,
        CitizensApp = 2,
        ServiceLetters = 18,
        OutGoing=12,
        SendToSendDocument = 12,
        OrgRequests = 19,
        WaitingDocs=23,
        CitizenRequests=24,
        InsDoc=25
    }

    public enum Role
    {
        Admin = 230,
        Operator = 231
    }

    public enum PositionGroupLevel
    {
        Minister = 1,
        MinisterMainDeputy = 2,
        MinisterDeputy = 3,
        Director = 100,
        DirectorDeputy = 101,
        TopDepartmentChief = 200,
        DepartmentChief = 300,
        SectionChief = 400,
        SectorChief = 405,
    }

    public enum PositionGroup
    {
        Director = 5,
        DepartmentChief = 13,
        SectionChief = 17,
        SectionChiefDeputy = 18,
        SectorChief = 26
    }

    public enum VizaConfirmed
    {
        IsViza = 0,
        ConfirmViza = 1,
        RejectionViza = 2
    }

    public enum DepartmentType
    {
        Directory = 1,
        Sector = 6
    }

    public enum OperationDoc
    {
        AddViza = 1,
        AddResolution = 2,
        AddSendToPerson = 3,
        EditDoc = 4,
        Answer = 5,
        Related = 6,
        MistakenDocument = 7,
        DocumentNumberEdit = 8,
        Mailed = 9,
        Print = 10,
        Draft = 11,
        ReadDoc = 12
    }

    public enum HeadGroups
    {
        Minister = 1,
        MinisterAsistant = 2,
        Director = 5,
        DepartmentHead = 9
    }
}