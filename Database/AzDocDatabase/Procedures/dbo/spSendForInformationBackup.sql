
/*
Migrated by Kamran A-eff 23.08.2019
*/
/*
Migrated by Kamran A-eff 06.08.2019
*/

CREATE PROCEDURE [dbo].[spSendForInformationBackup] @senderWorkPlaceId INT = 0, 
                                             @docId             INT = 0
AS
    BEGIN
        DECLARE @orgId INT, @currentPositionGroupId INT, @positionGroupId INT, @currentPositionGroupLevel INT;
        SELECT @currentPositionGroupId = dpg.PositionGroupId
        FROM dbo.DC_WORKPLACE dw
             JOIN dbo.DC_USER du ON dw.WorkplaceUserId = du.UserId
             JOIN dbo.DC_PERSONNEL dp ON du.UserPersonnelId = dp.PersonnelId
             JOIN dbo.DC_DEPARTMENT_POSITION ddp ON dw.WorkplaceDepartmentPositionId = ddp.DepartmentPositionId
             JOIN dbo.DC_POSITION_GROUP dpg ON ddp.PositionGroupId = dpg.PositionGroupId
        WHERE dp.PersonnelStatus = 1
              AND dw.WorkplaceId = @senderWorkPlaceId;
        SELECT @orgId =
        (
            SELECT [dbo].[fnPropertyByWorkPlaceId](@senderWorkPlaceId, 12)
        );
        SELECT @currentPositionGroupLevel = dpg.PositionGroupLevel
        FROM dbo.DC_POSITION_GROUP dpg
        WHERE dpg.PositionGroupId = @currentPositionGroupId;


    
        DECLARE @Organization TABLE(OrganizationId INT);
      
        INSERT INTO @Organization(OrganizationId)
               SELECT do.OrganizationId
               FROM dbo.DC_ORGANIZATION do;
    
        SELECT s.FormTypeId, 
               s.Id, 
               s.Name, 
               s.PositionGroupLevel, 
               s.DirectionConfirmed
        FROM
        (
            SELECT 1 FormTypeId, 
                   dw.WorkplaceId AS Id, 
                   ISNULL(' ' + dp.PersonnelName, '') + ISNULL(' ' + dp.PersonnelSurname, '') + ISNULL(' ' + dp.PersonnelLastname, '') + ISNULL(' ' + ddp.DepartmentPositionName, '') AS Name, 
                   dpg.PositionGroupLevel, 
                   0 DirectionConfirmed
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
                WHERE dw.WorkplaceDepartmentId IN
                (
                    SELECT ddp.DepartmentId
                    FROM dbo.DC_DEPARTMENT_POSITION ddp
                    WHERE ddp.PositionGroupId IN
                    (
                       SELECT dpg2.PositionGroupId FROM dbo.DC_POSITION_GROUP dpg2 WHERE dpg2.PositionGroupLevel>=@currentPositionGroupLevel
                    )
                )
                      AND dw.WorkplaceOrganizationId = CASE
                                                           WHEN @orgId = 1
                                                           THEN dw.WorkplaceOrganizationId
                                                           ELSE @orgId
                                                       END
            )
			UNION
			SELECT 1 FormTypeId, 
                   dw.WorkplaceId AS Id, 
                   ISNULL(' ' + dp.PersonnelName, '') + ISNULL(' ' + dp.PersonnelSurname, '') + ISNULL(' ' + dp.PersonnelLastname, '') + ISNULL(' ' + ddp.DepartmentPositionName, '') AS Name, 
                   dpg.PositionGroupLevel, 
                   0 DirectionConfirmed
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
                WHERE dw.WorkplaceDepartmentId IN
                (
                    SELECT ddp.DepartmentId
                    FROM dbo.DC_DEPARTMENT_POSITION ddp
                    WHERE ddp.PositionGroupId IN
                    (
                       SELECT dpg2.PositionGroupId FROM dbo.DC_POSITION_GROUP dpg2 WHERE 
					   dpg2.PositionGroupLevel<=CASE WHEN @currentPositionGroupLevel=5 then 100  end 
                    )
                )
                      AND dw.WorkplaceOrganizationId = 1
            )
            UNION            
            SELECT 2 FormTypeId, 
                   dol.ReceiverWorkPlaceId AS Id, 
                   ISNULL(' ' + dp.PersonnelName, '') + ISNULL(' ' + dp.PersonnelSurname, '') + ISNULL(' ' + dp.PersonnelLastname, '') + ISNULL(' ' + ddp.DepartmentPositionName, '') AS Name, 
                   dpg.PositionGroupLevel, 
                   dd.DirectionConfirmed
            FROM dbo.DocOperationsLog dol
                 JOIN dbo.DOCS_EXECUTOR de ON dol.ExecutorId = de.ExecutorId
                 JOIN dbo.DOCS_DIRECTIONS dd ON de.ExecutorDirectionId = dd.DirectionId
                 JOIN dbo.DC_WORKPLACE dw ON dol.ReceiverWorkPlaceId = dw.WorkplaceId
                 JOIN dbo.DC_USER du ON dw.WorkplaceUserId = du.UserId
                 JOIN dbo.DC_PERSONNEL dp ON du.UserPersonnelId = dp.PersonnelId
                 JOIN dbo.DC_DEPARTMENT_POSITION ddp ON dw.WorkplaceDepartmentPositionId = ddp.DepartmentPositionId
                 JOIN dbo.DC_POSITION_GROUP dpg ON ddp.PositionGroupId = dpg.PositionGroupId
            WHERE dol.DocId = @docId
                  AND dol.SenderWorkPlaceId = @senderWorkPlaceId
                  AND dol.OperationTypeId = 3
                  AND dol.IsDeleted IS NULL
        ) s
        ORDER BY s.PositionGroupLevel ASC;
    END;
