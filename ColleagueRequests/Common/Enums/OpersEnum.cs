namespace ColleagueRequests.Common.Enums
{
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
        GetById = 5
    }
}