/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [dbo].[spAddExecutor] 
@executorDocId int, 
@directionTypeId int,
@executorSection int, 
@executorMain tinyint, 
@executorReadStatus bit,
@executorSubsection int, 
@executorDepartment int,
@executorWorkplaceId int, 
@executorDirectionId int, 
@executorFullName nvarchar(500), 
@executorTopDepartment int,
@executorOrganizationId int,
@result int OUTPUT

WITH EXEC AS CALLER
AS
INSERT INTO dbo.DOCS_EXECUTOR
(
        ExecutorDirectionId, ExecutorDocId, 
        ExecutorWorkplaceId, ExecutorFullName, 
        ExecutorMain, DirectionTypeId, 
        ExecutorOrganizationId, ExecutorTopDepartment, 
        ExecutorDepartment, ExecutorSection, 
        ExecutorSubsection, ExecutorStepId, 
        ExecutionstatusId, ExecutorNote, 
        ExecutorReadStatus, ExecutorResolutionNote, 
        SendStatusId
) 
VALUES 
(
        @executorDirectionId, @executorDocId, 
        @executorWorkplaceId, @executorFullName, 
        @executorMain, @directionTypeId, 
        @executorOrganizationId, @executorTopDepartment, 
        @executorDepartment, @executorSection, 
        @executorSubsection, NULL, 
        NULL, NULL, 
        @executorReadStatus, NULL, 
        NULL
);

set @result=1;

