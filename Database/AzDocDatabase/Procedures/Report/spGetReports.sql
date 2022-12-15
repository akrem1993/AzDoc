CREATE PROCEDURE [report].[spGetReports] @docTypeId         INT = NULL, 
                                        @documentStatusId  INT = NULL, 
                                        @resultOfExecution INT = NULL
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT s.FormTypeId, 
               s.Id, 
               s.Name
        FROM
        (
            SELECT 1 FormTypeId, 
                   am.DocTypeId AS Id, 
                   am.Caption AS Name, 
                   '' AS PositionGroupLevel
            FROM dbo.AC_MENU am
            WHERE am.DocTypeId IS NOT NULL
            UNION
            SELECT 2 FormTypeId, 
                   dd.DocumentstatusId AS Id, 
                   dd.DocumentstatusName AS Name, 
                   '' AS PositionGroupLevel
            FROM dbo.DOC_DOCUMENTSTATUS dd
            WHERE dd.DocumentstatusId IN(1, 8, 12, 25, 27, 28, 29, 30, 31, 32, 33, 34)
            AND dd.DocumentstatusStatus = 1
      
            UNION
            SELECT 4 FormTypeId, 
                   dd.DocumentstatusId AS Id, 
                   dd.DocumentstatusName AS Name, 
                   '' AS PositionGroupLevel
            FROM dbo.DOC_DOCUMENTSTATUS dd
            WHERE dd.DocumentstatusId IN(2, 3, 4, 5, 7, 26)
            AND dd.DocumentstatusStatus = 1
           
            UNION
            SELECT 7 FormTypeId, 
                   dw.WorkplaceId AS Id, 
                   ISNULL(' ' + dp.PersonnelName, '') + ISNULL(' ' + dp.PersonnelSurname, '') + ISNULL(' ' + dp.PersonnelLastname, '') + ISNULL(' ' + ddp.DepartmentPositionName, '') AS Name, 
                   dpg.PositionGroupLevel
            FROM dbo.DC_WORKPLACE dw
                 JOIN dbo.DC_USER du ON dw.WorkplaceUserId = du.UserId
                 JOIN dbo.DC_PERSONNEL dp ON du.UserPersonnelId = dp.PersonnelId
                 JOIN dbo.DC_DEPARTMENT_POSITION ddp ON dw.WorkplaceDepartmentPositionId = ddp.DepartmentPositionId
                 JOIN dbo.DC_POSITION_GROUP dpg ON ddp.PositionGroupId = dpg.PositionGroupId
            WHERE dp.PersonnelStatus = 1
                  AND dw.WorkplaceId IN
            (
                SELECT dw.WorkplaceId
                FROM dbo.DC_WORKPLACE dw
                WHERE dw.WorkplaceDepartmentPositionId IN
                (
                    SELECT ddp.DepartmentPositionId
                    FROM dbo.DC_DEPARTMENT_POSITION ddp
                    WHERE ddp.PositionGroupId IN
                    (
                        SELECT dpg.PositionGroupId
                        FROM dbo.DC_POSITION_GROUP dpg
                        WHERE dpg.PositionGroupId IN
                        (

                        /*1,*/

                        2, 33, 5
                        )
                    )
                )
            )
        ) s
        ORDER BY s.PositionGroupLevel ASC;
    END;

