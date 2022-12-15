/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [outgoingdoc].[spOperationTask] @docId       INT, 
                                               @docTypeId   INT, 
                                               @workPlaceId INT, 
                                               @result      INT OUTPUT
AS
    BEGIN
        DECLARE 
  @taskCount INT= 0,
  @directionId INT, 
  @executorFullName NVARCHAR(MAX),
  @executorOrganizationId INT,
  @executorDepartmentId INT;

        SELECT 
  @taskCount = COUNT(0)
        FROM dbo.DOC_TASK t
        WHERE t.TaskDocId = @docId;

        IF(@taskCount > 0)
            BEGIN
                DECLARE @task TABLE
                (TypeOfAssignmentId INT, 
                 WhomAddressId      INT, 
                 RowNumber          INT
                );

                INSERT INTO @task
                (TypeOfAssignmentId, 
                 WhomAddressId, 
                 RowNumber
                )
                 SELECT 
     t.TypeOfAssignmentId, 
                 t.WhomAddressId, 
                 ROW_NUMBER() OVER(ORDER BY t.TaskDocId)
                 FROM dbo.DOC_TASK t
                 WHERE t.TaskDocId = @docId;

                SELECT @taskCount = COUNT(0) FROM @task;

                WHILE(@taskCount > 0)
                    BEGIN
                        DECLARE 
      @currentWorkPlaceId INT,
      @currentTypeOfAssignmentId INT,
      @taskNo DECIMAL(18, 1),
      @currentExecutorId int;

                        SELECT @currentWorkPlaceId = t.WhomAddressId, 
                               @currentTypeOfAssignmentId = t.TypeOfAssignmentId
                        FROM @task t
                        WHERE t.RowNumber = @taskCount;

                        INSERT INTO DOCS_DIRECTIONS
                        (DirectionCreatorWorkplaceId, 
                         DirectionDocId, 
                         DirectionTypeId, 
                         DirectionWorkplaceId, 
                         DirectionInsertedDate, 
                         DirectionDate, 
                         DirectionVizaId, 
                         DirectionConfirmed, 
                         DirectionSendStatus
                        )
                        VALUES
                        (@workPlaceId, 
                         @docId, 
                         18, 
                         @workPlaceId, 
                         dbo.SYSDATETIME(), 
                         dbo.SYSDATETIME(), 
                         NULL, 
                         1, 
                         1
                        );
                        SET @directionId = SCOPE_IDENTITY();

                        SELECT @executorFullName =
                        (
                            SELECT CONVERT(NVARCHAR(MAX),
                            (
                                SELECT [dbo].[fnGetPersonnelDetailsbyWorkPlaceId](@currentWorkPlaceId, 1)
                            ))
                        );

                        SELECT 
      @executorOrganizationId = wp.WorkplaceOrganizationId, 
                        @executorDepartmentId = wp.WorkplaceDepartmentId
                        FROM dbo.DC_WORKPLACE wp
                        WHERE 
      wp.WorkplaceId = @currentWorkPlaceId;

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
              where w.WorkplaceId= @currentWorkPlaceId

                        INSERT INTO dbo.DOCS_EXECUTOR
                        (ExecutorDirectionId, 
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
                         SendStatusId
                        )
                        VALUES
                        (@directionId, 
                         @docId, 
                         @currentWorkPlaceId, 
                         @executorFullName, 
                         0, 
                         18, 

                        (select DepartmentOrganization from @Departament),
     (select DepartmentTopDepartmentId from @Departament),
     (select DepartmentId from @Departament),
     (select DepartmentSectionId from @Departament),
     (select DepartmentSubSectionId from @Departament),

                         0, 
                         @currentTypeOfAssignmentId
                        );
      SET @currentExecutorId=SCOPE_IDENTITY();

      EXEC dbo.LogDocumentOperation
        @docId = @docId,
        @ExecutorId = @currentExecutorId,
        @SenderWorkPlaceId = @workPlaceId,
        @ReceiverWorkPlaceId = @currentWorkPlaceId,
        @DocTypeId = 12,
        @OperationTypeId = @currentTypeOfAssignmentId,
        @DirectionTypeId = 18,
        @OperationStatusId = null,
        @OperationStatusDate = null,
        @OperationNote = null;

                        SET @taskCount-=1;


        END;
                UPDATE dbo.DOCS
                  SET 
                      DocDocumentstatusId = 1, --Icraatdadir
                      DocDocumentOldStatusId = 16
                WHERE DocId = @docId;
                UPDATE dbo.DOCS_EXECUTOR
                  SET 
                      ExecutorReadStatus = 1
                WHERE ExecutorDocId = @docId
                      AND ExecutorWorkplaceId = @workPlaceId;
                SET @result = 5;
        END;
            ELSE
            BEGIN
                SET @result = 5;
        END;
    END;

