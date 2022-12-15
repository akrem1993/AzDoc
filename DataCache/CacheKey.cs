namespace DataCache.Core
{
    public class CacheKey
    {
        private readonly string _format = "{0}-{1}";
        private readonly string _generatedKey;

        public CacheKey(CacheTable entity, string entityId)
        {
            _generatedKey = string.Format(_format, entity.ToString(), entityId);
        }

        public static CacheKey New(CacheTable entity, string entityId)
        {
            return new CacheKey(entity, entityId);
        }

        public override string ToString()
        {
            return _generatedKey;
        }
    }

    public enum CacheTable
    {
        DOC_PERIOD,
        AC_CELL,
        AC_AC_CONTROL,
        AC_DOC_TYPE_CELL,
        AC_SEARCH_COLUMNS,
        DC_SETTING,
        DOC_TYPE_EXCHANGE,
        DC_COUNTRY,
        DC_DEPARTMENT,
        DMSColumn,
        DMSTable,
        DMSTableRelation,
        DOC_TYPE_GROUP,
        SqlResult,
        SQLQuery,
        VW_PERSONS,
        VW_ROLES,
        DC_TREE,
        AC_FILTER,
        DC_SEX,
        DOC_TEMPLATE,
        DOC_SELECTED_TEMPLATELABEL,
        DC_REQUEST,
        DC_REQUESTTYPE,
        DC_REQUESTANSWER,
        DOCS_DIRECTIONCHANGE,
        DMS_APP_VERSION,
        DOC_OPERATION,
        DOC_TOPIC,
        DOC_TOPIC_TYPE
    }
}