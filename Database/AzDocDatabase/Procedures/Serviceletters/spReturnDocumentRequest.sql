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
-- Author:  Musayev Nurlan, Rufin Əhmədov
-- Create date: 08.05.2019
-- Description: Sənədin geri qaytarilmasi
-- =============================================
CREATE PROCEDURE [serviceletters].[spReturnDocumentRequest]
@docId int,
@workPlaceId int,
@note nvarchar(max)=null,
@result int output
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
@taskExecutorId int,
@taskDirectonId int;
BEGIN

select @docStatus=d.DocDocumentstatusId from dbo.DOCS d where d.DocId=@docId AND d.DocDeleted=0;

IF @docStatus IS NULL THROW  56000,'Mövcud sənəd tapılmadı',1;

SELECT 
@executorId=de.ExecutorId,
@directionId=de.ExecutorDirectionId,
@executorSendStatus=de.SendStatusId,
@executorDirectionType=de.DirectionTypeId
FROM 
dbo.DOCS_EXECUTOR de 
WHERE 
de.ExecutorDocId=@docId 
AND de.ExecutorWorkplaceId=@workPlaceId  
 --AND de.DirectionTypeId=13 
AND de.ExecutorReadStatus=0;

if(@executorSendStatus IS not NULL AND @docStatus=1 AND @executorDirectionType=1)
BEGIN
    EXEC dbo.ReturnDirectionExecution
                         @docId = @docId,
                         @workPlaceId = @workPlaceId,
                          @note=@note;
    SET @result=1;
    return;
end;

IF @docStatus IN (35,16)--testiq olub yadaki imzalanibsa
BEGIN

IF EXISTS(SELECT dt.TaskId FROM dbo.DOC_TASK dt
              JOIN dbo.DOCS d ON dt.TaskDocId=d.DocId 
              WHERE 
              dt.TaskDocId=@docId 
              AND dt.TypeOfAssignmentId=3
              AND dt.WhomAddressId=@workPlaceId
              AND d.DocDoctypeId=18)
THROW 56000,'Bu əməliyyat müveqqeti olaraq işləmir',1;

EXEC serviceletters.ReturnInfoDocument
	@docId = @docId,
	@workPlaceId = @workPlaceId,
	@note = @note

return;
end;


BEGIN--SEKTOR YA SHOBE MUDiRi  GERI QAYTARARSA
 SELECT
 @vizaId= v.VizaId,
 @vizaSenderWorkPlaceId=v.VizaSenderWorkPlaceId 
 from dbo.DOCS_VIZA v 
 where 
 v.VizaDocId=@docId 
 --and v.VizaFromWorkflow=1 
 and v.VizaWorkPlaceId=@workPlaceId
 --AND v.VizaConfirmed=0
 and v.IsDeleted=0;

IF @vizaId IS  NULL THROW 56000,'Mövcud şəxsin viza nömrəsi tapılmadı',1;

BEGIN
 UPDATE dbo.DOCS_DIRECTIONS
 SET
 dbo.DOCS_DIRECTIONS.DirectionConfirmed=0
 WHERE 
 dbo.DOCS_DIRECTIONS.DirectionVizaId=@vizaId;

 UPDATE dbo.DOCS_EXECUTOR
 SET
 dbo.DOCS_EXECUTOR.ExecutorReadStatus = 1 
 where 
 dbo.DOCS_EXECUTOR.ExecutorId=@executorId; 

 update dbo.DOCS_VIZA--Vizadan imtina edilir ve silinir statusu alir
 set 
 VizaNotes=@note,
 VizaReplyDate=null,
 dbo.DOCS_VIZA.VizaSenddate=null,
 dbo.DOCS_VIZA.VizaConfirmed=0
 where 
 VizaId=@vizaId;

 UPDATE dbo.DocOperationsLog
 SET
     dbo.DocOperationsLog.OperationStatus = 8, -- int
     dbo.DocOperationsLog.OperationStatusDate = dbo.SYSDATETIME(), -- datetime
     dbo.DocOperationsLog.OperationNote =@note -- nvarchar
 where 
 dbo.DocOperationsLog.DocId=@docId
 AND dbo.DocOperationsLog.ExecutorId=@executorId;

 --senedi redakte ucun teyin edirik
  Insert into DOCS_DIRECTIONS(
          DirectionCreatorWorkplaceId,
          DirectionDocId,
          DirectionTypeId,
          DirectionWorkplaceId,
          DirectionInsertedDate,
          DirectionDate,
          DirectionVizaId,
          DirectionConfirmed,
          DirectionSendStatus) 
     values
         (
          @workPlaceId,
          @docId,
          13,
          @workPlaceId,
          dbo.SYSDATETIME(),
          dbo.SYSDATETIME(),
          @vizaId,
          0,
          1
         )
  set @newDirectionId=SCOPE_IDENTITY();

 --senedi redakte ucun kime(senedi gonderen shexs) gonderildiyini teyin edirik

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
              where w.WorkplaceId= @vizaSenderWorkPlaceId

 Insert into DOCS_EXECUTOR(DirectionTypeId,
           ExecutorDocId,
           ExecutorMain,
           ExecutorWorkplaceId,
           ExecutorFullName,
           ExecutorOrganizationId,
           ExecutorTopDepartment,
           ExecutorDepartment,
           ExecutorSection,
           ExecutorSubsection,
           SendStatusId,
           ExecutorDirectionId,
           ExecutorReadStatus
           ) 
     values 
           (13,
           @docId,
           0,
           @vizaSenderWorkPlaceId,
           dbo.fnGetPersonnelbyWorkPlaceId(@vizaSenderWorkPlaceId,106),
           (select DepartmentOrganization from @Departament),
           (select DepartmentTopDepartmentId from @Departament),
           (select DepartmentId from @Departament),
           (select DepartmentSectionId from @Departament),
           (select DepartmentSubSectionId from @Departament),

           15, --Shahriyar elave etdi
           @newDirectionId,
           0
           )
 SET @executorId=SCOPE_IDENTITY();
 ------------------------------------------------------------------

    EXEC dbo.LogDocumentOperation
       @docId = @docId,
       @ExecutorId = @executorId,
       @SenderWorkPlaceId = @workPlaceId,
       @ReceiverWorkPlaceId = @vizaSenderWorkPlaceId,
       @DocTypeId = 18,
       @OperationTypeId = 15,
       @DirectionTypeId = 13,
       @OperationStatusId = null,
       @OperationStatusDate = null,
       @OperationNote = null;
end;
SET @result=9;
return;
END;


END

