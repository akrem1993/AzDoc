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
CREATE PROCEDURE [dms_insdoc].[spReturnDocumentRequest]
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
@executorId int;
BEGIN

select @docStatus=d.DocDocumentstatusId from dbo.DOCS d where d.DocId=@docId;

SELECT 
 @executorId=de.ExecutorId,
 @directionId=de.ExecutorDirectionId
FROM 
 dbo.DOCS_EXECUTOR de 
WHERE 
 de.ExecutorDocId=@docId 
 AND de.ExecutorWorkplaceId=@workPlaceId  
 AND de.DirectionTypeId=13 
 AND de.ExecutorReadStatus=0;


BEGIN--SEKTOR YA SHOBE MUDiRi  GERI QAYTARARSA
 SELECT
 @vizaId= v.VizaId,
 @vizaSenderWorkPlaceId=v.VizaSenderWorkPlaceId 
 from dbo.DOCS_VIZA v 
 where 
 v.VizaDocId=@docId 
 and v.VizaFromWorkflow=1 
 and v.VizaWorkPlaceId=@workPlaceId
 and v.IsDeleted=0;

 IF @vizaId IS  NULL
  THROW 56000,'Mövcud şəxsin viza nömrəsi tapılmadı',1;

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

 --senedi redakte ucun kime(senedi gonderen shexs) gonderildiyini teyin edirik
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

           null,
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
       @DocTypeId = 3,
       @OperationTypeId = 15,
       @DirectionTypeId = 13,
       @OperationStatusId = null,
       @OperationStatusDate = null,
       @OperationNote = null;
end;
SET @result=9;
return;
END

