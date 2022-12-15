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
-- Author:  <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [outgoingdoc].[spSendToConfirmedPerson]
@docId int,
@docTypeId int,
@workPlaceId int,
@confirmWorkPlaceId int,
@result int output 
AS
BEGIN
 declare 
   @directionId int,
   @executorFullName nvarchar(max),
   @executorOrganizationId int,
   @executorDepartmentId int,
   @vizaId int,
   @chiefWorkPlaceId int,
   @fileId int,
   @executorId int;

    SELECT @fileId=f.FileId from dbo.DOCS_FILE f where  f.FileDocId=@docId and f.FileIsMain=1
 SELECT @chiefWorkPlaceId= dbo.fnGetDepartmentChiefInViza (@docId);

  begin-----------
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
          15,
          @workPlaceId,
          dbo.SYSDATETIME(),
          dbo.SYSDATETIME(),
          null,
          1,
          1
         )
      set @directionId=SCOPE_IDENTITY();
            
      
     
       select @executorFullName=(select CONVERT(nvarchar(max),(select [dbo].[fnGetPersonnelDetailsbyWorkPlaceId](@confirmWorkPlaceId,1))));       
       select 
       @executorOrganizationId=wp.WorkplaceOrganizationId,
       @executorDepartmentId=wp.WorkplaceDepartmentId 
       from dbo.DC_WORKPLACE wp 
       where 
       wp.WorkplaceId=@confirmWorkPlaceId

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
              where w.WorkplaceId= @confirmWorkPlaceId
     
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
     
      ExecutorReadStatus,
SendStatusId) 
     VALUES (
      @directionId, 
      @docId, 
      @confirmWorkPlaceId,
      @executorFullName, 
      0, 
      15, 

      (select DepartmentOrganization from @Departament),
     (select DepartmentTopDepartmentId from @Departament),
     (select DepartmentId from @Departament),
     (select DepartmentSectionId from @Departament),
     (select DepartmentSubSectionId from @Departament),
  
      0,
12
      );
     SET @executorId=SCOPE_IDENTITY();

     EXEC dbo.LogDocumentOperation
          @docId = @docId,
          @ExecutorId = @executorId,
          @SenderWorkPlaceId = @workPlaceId,
          @ReceiverWorkPlaceId = @confirmWorkPlaceId,
          @DocTypeId = 12,
          @OperationTypeId = 12,
          @DirectionTypeId = 15,
          @OperationStatusId = 5,
          @OperationStatusDate = null,
          @OperationNote = null
   

   SELECT @vizaId=dv.VizaId FROM dbo.DOCS_VIZA dv --testiq eden shexsin viza nomresini aliriq
          WHERE 
          dv.VizaDocId=@docId
          AND dv.VizaWorkPlaceId=@confirmWorkPlaceId 
          AND dv.VizaFromWorkflow=2
                   AND dv.IsDeleted=0;

   IF @vizaId IS NULL
   begin
   INSERT INTO dbo.DOCS_VIZA
    (VizaDocId, 
        VizaFileId,
        VizaWorkPlaceId,
        VizaReplyDate, 
     VizaNotes, 
     VizaOrderindex,
     VizaSenderWorkPlaceId, 
        VizaSenddate, 
        VizaConfirmed,
        IsDeleted,
     VizaAgreementTypeId,
     VizaFromWorkflow) 
   VALUES (
    @docId,
    @fileId,
    @confirmWorkPlaceId,
      dbo.SYSDATETIME(), 
       NULL,
       NULL,
    @workPlaceId,
    dbo.SYSDATETIME(), 
    0, 
    0,
    1,
    2)
   set @vizaId=SCOPE_IDENTITY();
   END
      ELSE
      BEGIN
        UPDATE dbo.DOCS_VIZA
        SET
            dbo.DOCS_VIZA.VizaSenddate = dbo.SYSDATETIME(), -- datetime
            dbo.DOCS_VIZA.VizaConfirmed = 0 -- tinyint
        WHERE dbo.DOCS_VIZA.VizaId=@vizaId;
      END

   update dbo.DOCS_DIRECTIONS
   set 
      DirectionVizaId=@vizaId 
   where 
   DirectionId=@directionId;

   set @result=7;
 end------------------
END

