/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE  PROCEDURE [citizenrequests].[spOperationSend]
@docId int,
@workPlaceId int,
@result int output 
AS
DECLARE @currentDocumentStatusId INT, @currentOrgId INT, @documentStatusId INT, @oldDocumentStatusId INT, @directionTypeId INT, @sendStatusId INT , @operationTypeId INT,@operationStatusId  INT;
begin
 set nocount on;
 if exists(select * from dbo.DOCS d where d.DocId=@docId and d.DocDeleted=0)
  BEGIN
    SELECT @currentDocumentStatusId = d.DocDocumentstatusId, 
                       @currentOrgId = d.DocOrganizationId
                FROM dbo.DOCS d
                WHERE d.DocId = @docId;
                SELECT @documentStatusId = doh.DocumentStatusId, 
                       @oldDocumentStatusId = doh.OldDocumentStatusId, 
                       @directionTypeId = doh.DirectionTypeId, 
                       @sendStatusId = doh.SendStatusId,
                       @operationTypeId=doh.OperationTypeId,
                       @operationStatusId=isnull(doh.OperationStatusId,0)
                FROM dbo.DocOperationHierarchy doh
                WHERE doh.DocTypeId = 1
                      AND doh.OldDocumentStatusId = @currentDocumentStatusId
                      AND ISNULL(doh.OrganizationId, 0) = CASE
                                                              WHEN ISNULL(doh.OrganizationId, 0) = @currentOrgId
                                                              THEN @currentOrgId
                                                              ELSE 0
                                                          END
                      AND doh.IsStatus = 1;
    update dbo.DOCS 
   set DocDocumentstatusId=@documentStatusId, --aidiyyətı üzrə göndərilib
   DocDocumentOldStatusId=@oldDocumentStatusId   
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
                 @directionTypeId,
                @workPlaceId,
                dbo.SYSDATETIME(),
                dbo.SYSDATETIME(),
                1
               )
            set @directionId=SCOPE_IDENTITY();
          declare @executorFullName nvarchar(MAX),@executorOrganizationId int,@executorDepartmentId int;
        select @executorFullName=(select CONVERT(nvarchar(max),(select [dbo].[fnGetPersonnelDetailsbyWorkPlaceId]((SELECT dbo.fnGetDepartmentChief(@workPlaceId)),1))));       
        select @executorOrganizationId=wp.WorkplaceOrganizationId,@executorDepartmentId=wp.WorkplaceDepartmentId from dbo.DC_WORKPLACE wp where wp.WorkplaceId=(SELECT dbo.fnGetDepartmentChief(@workPlaceId))
		    set @receiverWorkPlaceId= (SELECT CASE when @oldDocumentStatusId=15 then dbo.fnGetDepartmentChief(@workPlaceId)
			ELSE dbo.fnGetOrganizationChief(@workPlaceId) end);     
		   
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
			SendStatusId,
            ExecutorReadStatus) 
           VALUES (
            @directionId, 
            @docId, 
            @receiverWorkPlaceId,
            @executorFullName, 
            0, 
             @directionTypeId, 

            (select DepartmentOrganization from @Departament),
     (select DepartmentTopDepartmentId from @Departament),
     (select DepartmentId from @Departament),
     (select DepartmentSectionId from @Departament),
     (select DepartmentSubSectionId from @Departament),
      @sendStatusId,
            0); 
        SET @executorId=SCOPE_IDENTITY();
 
    EXEC dbo.LogDocumentOperation
         @docId = @docId,
         @ExecutorId = @executorId,
         @SenderWorkPlaceId = @workPlaceId,
         @ReceiverWorkPlaceId = @receiverWorkPlaceId,
         @DocTypeId = 1,
         @OperationTypeId = @operationTypeId,
         @DirectionTypeId = @directionTypeId,
         @OperationStatusId = @operationStatusId,
         @OperationStatusDate = null,
         @OperationNote = N''

  
   set @result=1;
      
      update dbo.DOCS_EXECUTOR  
   set ExecutorReadStatus=1,ExecutorControlStatus=1
   where ExecutorDocId=@docId and ExecutorWorkplaceId=@workPlaceId
  end 
end

