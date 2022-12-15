/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

-- =============================================
-- Author:  Musayev Nurlan
-- Create date: 26.06.2019
-- Description: Senedin geri qaytarilmasi
-- =============================================
CREATE PROCEDURE [orgrequests].[ReturnDocumentRequest]
@docId int,
@workPlaceId int,
@note nvarchar(max)=null
AS
DECLARE 
@vizaId int,
@vizaSenderWorkPlaceId int,
@docStatus INT,
@newVizaId int,
@directionId int,
@newDirectionId int,
@executorId int,
@executorSendStatus int,
@executorDirectionType int,
@directionWorkPlaceId int,
@docCreatorWorkPlaceId int,
@countDirectionWorkPlaceId int;
BEGIN

select @docStatus=d.DocDocumentstatusId,@docCreatorWorkPlaceId=d.DocInsertedById from dbo.DOCS d where d.DocId=@docId;

SELECT 
  @countDirectionWorkPlaceId=count(distinct dd.DirectionWorkplaceId)
FROM 
 dbo.DOCS_EXECUTOR de JOIN dbo.DOCS_DIRECTIONS dd ON de.ExecutorDirectionId = dd.DirectionId
WHERE 
 de.ExecutorDocId=@docId 
 AND de.ExecutorWorkplaceId=@workPlaceId ;
 if(@countDirectionWorkPlaceId>1)
 BEGIN
	set @directionWorkPlaceId=@docCreatorWorkPlaceId;
 END
 ELSE
 BEGIN
	SELECT 
	 @executorId=de.ExecutorId,
	 @directionId=de.ExecutorDirectionId,
	  @executorSendStatus=de.SendStatusId,
	  @executorDirectionType=de.DirectionTypeId,
	  @directionWorkPlaceId=dd.DirectionWorkplaceId
	FROM 
	 dbo.DOCS_EXECUTOR de JOIN dbo.DOCS_DIRECTIONS dd ON de.ExecutorDirectionId = dd.DirectionId
	WHERE 
	 de.ExecutorDocId=@docId 
	 AND de.ExecutorWorkplaceId=@workPlaceId  
	 --AND de.DirectionTypeId=13 
	 AND de.ExecutorReadStatus=0;
 end


if(@executorSendStatus IS not NULL AND @docStatus=1 AND @executorDirectionType=1)
BEGIN
    EXEC dbo.ReturnDirectionExecution
                         @docId = @docId,
                         @workPlaceId = @workPlaceId,
                          @note=@note;
    return;
end;


UPDATE dbo.DOCS 
SET
dbo.docs.DocDocumentstatusId=15,
dbo.docs.DocDocumentOldStatusId=@docStatus
WHERE dbo.docs.DocId=@docId;

UPDATE dbo.DOCS_DIRECTIONS 
SET
dbo.docs_directions.DirectionConfirmed=0
WHERE
DirectionId=@directionId;

UPDATE dbo.DOCS_EXECUTOR
SET
dbo.DOCS_EXECUTOR.ExecutorControlStatus = 1 ,
dbo.DOCS_EXECUTOR.ExecutorReadStatus=1
WHERE
dbo.DOCS_EXECUTOR.ExecutorId=@executorId

UPDATE dbo.DocOperationsLog
SET
    dbo.DocOperationsLog.OperationStatus = 8, -- int
    dbo.DocOperationsLog.OperationStatusDate = dbo.sysdatetime(), -- datetime
    dbo.DocOperationsLog.OperationNote = @note -- nvarchar
where
dbo.DocOperationsLog.ExecutorId=@executorId

Insert into DOCS_DIRECTIONS(
                DirectionCreatorWorkplaceId,
                DirectionDocId,
                DirectionTypeId,
                DirectionWorkplaceId,
                DirectionInsertedDate,
                DirectionDate,
                DirectionConfirmed) 
           values
               (
                @workPlaceId,
                @docId,
                19,
                @workPlaceId,
                dbo.SYSDATETIME(),
                dbo.SYSDATETIME(),
                1
               )

SET @directionId=SCOPE_IDENTITY();

declare @Departament table 
(DepartmentOrganization int null,
DepartmentTopDepartmentId int null,
DepartmentId int,
DepartmentSectionId int null,
DepartmentSubSectionId int null)

Insert into @Departament(DepartmentOrganization,
          DepartmentTopDepartmentId,
          DepartmentId,
          DepartmentSectionId,
          DepartmentSubSectionId) 
select d.DepartmentOrganization,
          d.DepartmentTopDepartmentId,
          d.DepartmentId,
          d.DepartmentSectionId,
          d.DepartmentSubSectionId
              from DC_WORKPLACE w join DC_DEPARTMENT_POSITION dp 
              on w.WorkplaceDepartmentPositionId=dp.DepartmentPositionId 
              join DC_DEPARTMENT d  on dp.DepartmentId=d.DepartmentId 
              --where w.WorkplaceId= @docCreatorWorkPlaceId
			  WHERE w.WorkplaceId=@directionWorkPlaceId

INSERT INTO dbo.DOCS_EXECUTOR
           (
            ExecutorDirectionId,
             ExecutorDocId, 
            ExecutorWorkplaceId, 
            ExecutorFullName, 
            ExecutorMain, 
            DirectionTypeId, 

            ExecutorOrganizationId,
            ExecutorTopDepartment,
            ExecutorDepartment,
            ExecutorSection,
            ExecutorSubsection,
			SendStatusId,
            ExecutorReadStatus) 
           VALUES (
            @directionId, 
            @docId, 
            --@docCreatorWorkPlaceId,
			@directionWorkPlaceId,
            '', 
            0, 
            19, 

            (select DepartmentOrganization from @Departament),
            (select DepartmentTopDepartmentId from @Departament),
            (select DepartmentId from @Departament),
            (select DepartmentSectionId from @Departament),
            (select DepartmentSubSectionId from @Departament),
			15,--Shahriyar elave etdi
            0); 
SET @executorId=SCOPE_IDENTITY();


DECLARE @datetime datetime =dbo.sysdatetime();

EXEC dbo.LogDocumentOperation
	@docId = @docId,
	@ExecutorId = @executorId,
	@SenderWorkPlaceId = @workPlaceId,
	--@ReceiverWorkPlaceId = @docCreatorWorkPlaceId,
	@ReceiverWorkPlaceId=@directionWorkPlaceId,
	@OperationTypeId = 17,
	@DirectionTypeId = 17,
	@OperationStatusId = 8,
	@OperationStatusDate =@datetime,
	@OperationNote = NULL;



END

