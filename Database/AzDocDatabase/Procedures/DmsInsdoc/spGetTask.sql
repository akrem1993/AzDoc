/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [dms_insdoc].[spGetTask] @docId INT,@workPlaceId int=NULL,@docTypeId int=NULL
AS
    BEGIN
 DECLARE @executorCount INT;
 SELECT @executorCount = COUNT(0)
                FROM dbo.DOCS_EXECUTOR e
                WHERE e.ExecutorDocId = @docId
                      AND e.ExecutorWorkplaceId = @workPlaceId
                      AND e.DirectionTypeId = 18;

        SELECT t.TaskId, 
               t.TaskDocNo, 
               t.TaskDocId,
        (
            SELECT s.SendStatusName
            FROM dbo.DOC_SENDSTATUS s
            WHERE s.SendStatusId = t.TypeOfAssignmentId
        ) TypeOfAssignment, 
        (
            SELECT ISNULL(' ' + PE.PersonnelName, '') + ISNULL(' ' + PE.PersonnelSurname, '') + ISNULL(' ' + PE.PersonnelLastname, '')
            FROM dbo.DC_WORKPLACE WP
                 JOIN [dbo].DC_USER DU ON WP.WorkplaceUserId = DU.UserId
                 JOIN [dbo].DC_PERSONNEL PE ON DU.UserPersonnelId = PE.PersonnelId
            WHERE PE.PersonnelStatus = 1
                  AND WP.WorkplaceId = t.WhomAddressId
        ) WhomAddress, 
               t.TaskNo, 
               t.TaskDecription Task, 
               t.TaskCycleId TaskCycle, 
        (
            SELECT tc.TaskCycleName
            FROM dbo.DOC_TASK_CYCLE tc
            WHERE tc.TaskCycleId = t.TaskCycleId
                  AND tc.DocTypeId = 3
        ) TaskCycleName, 
               t.ExecutionPeriod, 
               t.PeriodOfPerformance, 
               t.OriginalExecutionDate
        FROM dbo.DOC_TASK t
        WHERE t.TaskDocId = @docId
   AND t.WhomAddressId = CASE
                                                    WHEN @executorCount > 0
                                                    THEN @workPlaceId
                                                    WHEN @executorCount = 0
                                                    THEN t.WhomAddressId
                                                END;
    END;

