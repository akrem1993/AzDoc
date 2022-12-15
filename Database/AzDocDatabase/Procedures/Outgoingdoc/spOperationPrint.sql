/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [outgoingdoc].[spOperationPrint] @docId       INT, 
                                                               @docTypeId   INT, 
                                                               @workPlaceId INT, 
                                                               @note        NVARCHAR(MAX) = NULL, 
                                                               @result      INT OUTPUT
AS
    BEGIN
        SET NOCOUNT ON;
  DECLARE @currentExecutorId int,@mailerworkplaceId int,@currentDirectionId int,@signerindex nvarchar(25)=null,@departmentindex nvarchar(10)=null,@docIndex nvarchar(20)=null,@docEnterno nvarchar(20)=null,@organizationIndex INT, @date DATE= SYSDATETIME(), @directionId INT, @confirmWorkPlaceId INT= 0, @executorFullName NVARCHAR(MAX), @executorOrganizationId INT, @executorDepartmentId INT, @vizaId INT, @fileId INT;
        DECLARE @signatureExecutorId INT,   @organizationId INT;
   SELECT @docIndex = (COUNT(0) + 1) FROM dbo.DOCS d WHERE d.DocDoctypeId = @docTypeId;

    --   SELECT @organizationIndex = Ltrim(Rtrim(o.organizationindex)) , @organizationIdSigner=o.OrganizationId
    --FROM   dbo.dc_organization o 
    --WHERE  o.organizationid = (SELECT wp.workplaceorganizationid 
    --                           FROM   dbo.dc_workplace wp 
    --                           WHERE  wp.workplaceid = @workPlaceId); 


   SELECT @organizationIndex=LTRIM(RTRIM(o.OrganizationIndex))
     FROM dbo.DC_ORGANIZATION o   WHERE o.OrganizationId=(select wp.WorkplaceOrganizationId from dbo.DC_WORKPLACE wp where wp.WorkplaceId=@workPlaceId); 
   SELECT @departmentindex=LTRIM(RTRIM(DepartmentIndex)) FROM DC_WORKPLACE join DC_DEPARTMENT ON DC_DEPARTMENT.DepartmentId=DC_WORKPLACE.WorkplaceDepartmentId where WorkplaceId=dbo.fnGetDepartmentChiefInViza(@workPlaceId)
   
   SELECT  @organizationId = dbo.DC_WORKPLACE.WorkplaceOrganizationId  from DC_WORKPLACE  where  WorkplaceId =@workPlaceId
   SELECT @mailerworkplaceId =w.WorkplaceId  from DC_WORKPLACE w  join [dbo].[DC_WORKPLACE_ROLE]  wr on wr.WorkplaceId=w.WorkplaceId 
   where RoleId=243  AND w.WorkplaceOrganizationId=@organizationId
   --and w.WorkplaceOrganizationId=@organizationIndex 

             
  
        SELECT @signatureExecutorId = de.ExecutorId
        FROM dbo.DOCS_EXECUTOR de
        WHERE de.ExecutorDocId = @docId
              AND de.ExecutorWorkplaceId = @workPlaceId
              AND de.ExecutorReadStatus = 0
              AND de.DirectionTypeId = 9;
        UPDATE dbo.DOCS_EXECUTOR
          SET 
              ExecutorReadStatus = 1,
     ExecutorControlStatus = 1
        WHERE ExecutorId = @signatureExecutorId;
        UPDATE dbo.DocOperationsLog
          SET 
              dbo.DocOperationsLog.OperationStatus = 10, 
              dbo.DocOperationsLog.OperationStatusDate = dbo.SYSDATETIME(), 
              dbo.DocOperationsLog.OperationNote = @note
        WHERE dbo.DocOperationsLog.DocId = @docId
              AND ReceiverWorkPlaceId = @workPlaceId;
        UPDATE dbo.DOCS
          SET --DocEnterno=@docEnterno,
             -- DocEnterdate = SYSDATETIME(), 
              DocDocumentstatusId = 27, --İmzalanib
              DocDocumentOldStatusId = 16
        WHERE DocId = @docId;
        UPDATE dbo.DOCS_DIRECTIONS
          SET 
              DirectionSendStatus = 1
        WHERE DirectionDocId = @docId
              AND DirectionTypeId = 8;
        
  Insert into DOCS_DIRECTIONS(
           DirectionCreatorWorkplaceId,
           DirectionDocId,
           DirectionTypeId,
           DirectionWorkplaceId,
           DirectionInsertedDate,
           DirectionDate,           
           DirectionConfirmed,
           DirectionSendStatus)
        values
         (
          @workPlaceId,
          @docId,
          10,
          @workPlaceId,
          dbo.SYSDATETIME(),
          dbo.SYSDATETIME(),          
          1,
          1)

        set @currentDirectionId=SCOPE_IDENTITY(); 

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
              where w.WorkplaceId= @mailerworkplaceId

        INSERT INTO dbo.DOCS_EXECUTOR
         (
          ExecutorDirectionId,
          ExecutorDocId, 
          ExecutorWorkplaceId, 
          ExecutorFullName, 
          ExecutorMain, 
          DirectionTypeId,                 
          ExecutorReadStatus,

ExecutorOrganizationId,
                         ExecutorTopDepartment,
                         ExecutorDepartment,
                         ExecutorSection,
                         ExecutorSubsection,
						 SendStatusId
) 
         VALUES (
          @currentDirectionId, 
          @docId, 
          @mailerworkplaceId,
          dbo.fnGetPersonnelbyWorkPlaceId(@mailerworkplaceId,106),
          0, 
          10,               
          0,

(select DepartmentOrganization from @Departament),
     (select DepartmentTopDepartmentId from @Departament),
     (select DepartmentId from @Departament),
     (select DepartmentSectionId from @Departament),
     (select DepartmentSubSectionId from @Departament),
	 9
	 


          );
         SET @currentExecutorId=SCOPE_IDENTITY();
         
                EXEC dbo.LogDocumentOperation
          @docId = @docId,
          @ExecutorId = @currentExecutorId,
          @SenderWorkPlaceId = @workPlaceId,
          @ReceiverWorkPlaceId = @mailerworkplaceId,
          @DocTypeId = 12,
          @OperationTypeId = 9,--poçt etmək üçün
          @DirectionTypeId = 9,
          @OperationStatusId = 1,--cap edildi,
          @OperationStatusDate = null,
          @OperationNote = null;       


        SET @result = 15;

    END;

