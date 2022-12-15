

namespace BLL.Common.Enums
{
    public enum DBResultOutputParameter
    {
        Unsuccessful = -1,
        NoPermissionUser = 0,
        Success = 1,
        NoPermissionUserResetCode = 2,
        UnknownError = 3
    }

    public enum OperType
    {
        Select = 1,
        Insert = 2,
        Update = 3,
        Delete = 4,
        Other = 5
    }

    public enum SelectType
    {
        GetFileInfoById = 1,
        GetByDocId = 2,
        GetResPersonByOrgId = 3,
        GetVizaByFileInfoId = 4,
        GetById = 5,
        GetMainFileByDocId = 6,
        GetSignedFileByDocId = 7
    }

    public enum DocFilter
    {
        TopicTypeOrg = 1,
        DocFormId = 2,
        FormId = 3,
        DocStatusOrg = 4,
        ApplyTypeId = 5,
        DocStatusCts = 6,
        DocStatusOut = 7,
        DocStatusSer = 8,
        DocStatusIns = 9,
        TopicTypeCts = 10,
        OrgRequestsTopics = 11,
        AdminCountries = 12,
        AdminRegions = 13
    }

    public enum DocOperation
    {
        Dispose = 20
    }

    public enum ActionType
    {
        Send = 1,
        Edit = 2,
        Recognized = 3,
        SendForInformation = 4,
        Accept = 5,
        Cancel = 6,
        Signature = 7,
        Return = 9,
        DisposeDoc = 10,
        Print = 15,
        Post = 16,
        NotSent = 17,
        Mailed = 10,
        Blank = 21,
        Approve = 24
    }


}