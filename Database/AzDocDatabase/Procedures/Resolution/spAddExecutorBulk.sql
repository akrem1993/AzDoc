/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/


CREATE PROCEDURE [resolution].[spAddExecutorBulk] 
@directionControlStatus      BIT=NULL, 
@directionPlanneddate        DATETIME=NULL, 
@directionddate        DATETIME=NULL, 
@directionId int,
@directionTypeId int,
@executorList [dbo].[UdttDirectionExecutor] readonly
WITH EXEC AS CALLER
AS
declare @docId int;
select @docId=DirectionDocId from DOCS_DIRECTIONS where DirectionId=@directionId
--if(@directionControlStatus=1)
--begin
--update DOCS set DocExecutionStatusId=3 where DocId=@docId
update DOCS_DIRECTIONS set DirectionControlStatus=@directionControlStatus where DirectionId=@directionId
--end
if (@directionPlanneddate is not null)
 begin 
update DOCS_DIRECTIONS set DirectionPlanneddate=@directionPlanneddate where DirectionId=@directionId
end

;with executors as (
select  ExecutorId,dd.DirectionId ExecutorDirectionId,dd.DirectionDocId ExecutorDocId, 
        ExecutorWorkplaceId, ExecutorFullName, 
        ExecutorMain, @directionTypeId DirectionTypeId, 
        ExecutorOrganizationId, ExecutorTopDepartment, 
        ExecutorDepartment, ExecutorSection, 
        ExecutorSubsection, ExecutorStepId, 
        ExecutionstatusId, ExecutorNote, 
        ExecutorReadStatus, ExecutorResolutionNote, 
        SendStatusId from @executorList e
  ,DOCS_DIRECTIONS dd
where dd.DirectionId=@directionId
)

MERGE DOCS_EXECUTOR AS TARGET
USING executors AS SOURCE 
ON (TARGET.ExecutorId = SOURCE.ExecutorId) 
--When records are matched, update the records if there is any change
WHEN MATCHED AND (TARGET.SendStatusId <> SOURCE.SendStatusId OR TARGET.SendStatusId = SOURCE.SendStatusId)--icra novu deyisdirilmesi ve ya eyni qalmasi halinda metnin deyiwdirilmesi
THEN UPDATE SET TARGET.ExecutorMain = case SOURCE.SendStatusId when 1 then 1 else 0 end,
 TARGET.SendStatusId = SOURCE.SendStatusId,
 TARGET.ExecutorResolutionNote=SOURCE.ExecutorResolutionNote
--When no records are matched, insert the incoming records from source table to target table
WHEN NOT MATCHED BY TARGET   
THEN INSERT (  ExecutorDirectionId,ExecutorDocId, 
        ExecutorWorkplaceId, ExecutorFullName, 
        ExecutorMain, DirectionTypeId, 
        ExecutorOrganizationId, ExecutorTopDepartment, 
        ExecutorDepartment, ExecutorSection, 
        ExecutorSubsection, ExecutorStepId, 
        ExecutionstatusId, ExecutorNote, 
        ExecutorReadStatus, ExecutorResolutionNote, 
        SendStatusId) VALUES (@directionId,ExecutorDocId, 
  ExecutorWorkplaceId, ExecutorFullName,
  /*ExecutorMain*/ case SendStatusId when 1 then 1 else 0 end, DirectionTypeId,
  ExecutorOrganizationId, ExecutorTopDepartment,  
        ExecutorDepartment, ExecutorSection, 
  ExecutorSubsection,ExecutorStepId,
  ExecutionstatusId, ExecutorNote,
  ExecutorReadStatus,ExecutorResolutionNote, 
  SendStatusId)
--When there is a row that exists in target and same record does not exist in source then delete this record target
WHEN NOT MATCHED BY SOURCE and TARGET.ExecutorDirectionId=@directionId and TARGET.SendStatusId!=5
THEN  
DELETE;

