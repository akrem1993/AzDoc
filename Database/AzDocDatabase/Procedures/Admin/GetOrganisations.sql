CREATE PROCEDURE [admin].[GetOrganisations] @pageIndex  INT = 1, 
                                           @pageSize   INT = 20, 
                                           @totalCount INT = NULL OUT
AS
    BEGIN
        SELECT do.OrganizationId AS Id, 
               do.OrganizationShortname AS [Name], 
               do1.OrganizationShortname AS TopOrgName, 
               do.OrganizationIndex AS [Index]
        FROM DC_ORGANIZATION do
             LEFT OUTER JOIN DC_ORGANIZATION do1 ON do.OrganizationTopId = do1.OrganizationId
        WHERE do.OrganizationStatus = 1
        ORDER BY do.OrganizationId DESC
        OFFSET @pageSize * (@pageIndex - 1) ROWS FETCH NEXT @pageSize ROWS ONLY;

        SELECT @totalCount = COUNT(0)
        FROM DC_ORGANIZATION do
        WHERE do.OrganizationStatus = 1;

    END;
