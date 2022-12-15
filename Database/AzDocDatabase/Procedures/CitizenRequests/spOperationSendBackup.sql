/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

create  PROCEDURE [citizenrequests].[spOperationSendBackup]
@docId int,
@workPlaceId int,
@result int output 
AS
begin
 set nocount on;
 if exists(select * from dbo.DOCS d where d.DocId=@docId and d.DocDeleted=0)
  begin
    update dbo.DOCS 
   set DocDocumentstatusId=8, --aidiyyətı üzrə göndərilib
   DocDocumentOldStatusId=15   
      where DocId=@docId;

      declare @directionId int,@executorId int,@receiverWorkPlaceId int;
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
                 11,
                @workPlaceId,
                dbo.SYSDATETIME(),
                dbo.SYSDATETIME(),
                1
               )
            set @directionId=SCOPE_IDENTITY();
          declare @executorFullName nvarchar(MAX),@executorOrganizationId int,@executorDepartmentId int;
        select @executorFullName=(select CONVERT(nvarchar(max),(select [dbo].[fnGetPersonnelDetailsbyWorkPlaceId]((SELECT dbo.fnGetDepartmentChief(@workPlaceId)),1))));       
        select @executorOrganizationId=wp.WorkplaceOrganizationId,@executorDepartmentId=wp.WorkplaceDepartmentId from dbo.DC_WORKPLACE wp where wp.WorkplaceId=(SELECT dbo.fnGetDepartmentChief(@workPlaceId))
            set @receiverWorkPlaceId= dbo.fnGetDepartmentChief(@workPlaceId);     

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
              where w.WorkplaceId= @receiverWorkPlaceId


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
     
            ExecutorReadStatus) 
           VALUES (
            @directionId, 
            @docId, 
            @receiverWorkPlaceId,
            @executorFullName, 
            0, 
             11, 

            (select DepartmentOrganization from @Departament),
     (select DepartmentTopDepartmentId from @Departament),
     (select DepartmentId from @Departament),
     (select DepartmentSectionId from @Departament),
     (select DepartmentSubSectionId from @Departament),
      
            0); 
        SET @executorId=SCOPE_IDENTITY();
 
    EXEC dbo.LogDocumentOperation
         @docId = @docId,
         @ExecutorId = @executorId,
         @SenderWorkPlaceId = @workPlaceId,
         @ReceiverWorkPlaceId = @receiverWorkPlaceId,
         @DocTypeId = 1,
         @OperationTypeId = 16,
         @DirectionTypeId = 11,
         @OperationStatusId = 0,
         @OperationStatusDate = null,
         @OperationNote = N''

  
   set @result=1;
      
      update dbo.DOCS_EXECUTOR  
   set ExecutorReadStatus=1,ExecutorControlStatus=1
   where ExecutorDocId=@docId and ExecutorWorkplaceId=@workPlaceId
  end 
end

