
/*
Migrated by Kamran A-eff 23.08.2019
*/
/*
Migrated by Kamran A-eff 06.08.2019
*/
/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [smdo].[spOperationWhomAddress] @docId       INT, 
                                                          @docTypeId   INT, 
                                                          @workPlaceId INT, 
                                                          @result      INT OUTPUT
AS
    BEGIN
        DECLARE @taskCount INT= 0, @typeOfAssignment INT= 0, @directionId INT, @executorFullName NVARCHAR(MAX), @executorOrganizationId INT, @executorDepartmentId INT;
        SELECT @taskCount = COUNT(0)
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
                       SELECT t.TypeOfAssignmentId, 
                              t.WhomAddressId, 
                              ROW_NUMBER() OVER(
                              ORDER BY t.TaskDocId)
                       FROM dbo.DOC_TASK t
                       WHERE t.TaskDocId = @docId;
                SELECT @taskCount = COUNT(0)
                FROM @task;
                WHILE(@taskCount > 0)
                    BEGIN
                        DECLARE @currentWorkPlaceId INT, @currentTypeOfAssignmentId INT, @taskNo DECIMAL(18, 1), @currentExecutorId INT;
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
                        SELECT @executorOrganizationId = wp.WorkplaceOrganizationId, 
                               @executorDepartmentId = wp.WorkplaceDepartmentId
                        FROM dbo.DC_WORKPLACE wp
                        WHERE wp.WorkplaceId = @currentWorkPlaceId;
                        DECLARE @Departament TABLE
                        (DepartmentOrganization    INT NULL, 
                         DepartmentTopDepartmentId INT NULL, 
                         DepartmentId              INT, 
                         DepartmentSectionId       INT NULL, 
                         DepartmentSubSectionId    INT NULL
                        );
                        INSERT INTO @Departament
                        (DepartmentOrganization, 
                         DepartmentTopDepartmentId, 
                         DepartmentId, 
                         DepartmentSectionId, 
                         DepartmentSubSectionId
                        )
                               SELECT d.DepartmentOrganization, 
                                      d.DepartmentTopDepartmentId, 
                                      d.DepartmentId, 
                                      d.DepartmentSectionId, 
                                      d.DepartmentSubSectionId
                               FROM DC_WORKPLACE w
                                    JOIN DC_DEPARTMENT_POSITION dp ON w.WorkplaceDepartmentPositionId = dp.DepartmentPositionId
                                    JOIN DC_DEPARTMENT d ON dp.DepartmentId = d.DepartmentId
                               WHERE w.WorkplaceId = @currentWorkPlaceId;
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
                        (
                            SELECT DepartmentOrganization
                            FROM @Departament
                        ), 
                        (
                            SELECT DepartmentTopDepartmentId
                            FROM @Departament
                        ), 
                        (
                            SELECT DepartmentId
                            FROM @Departament
                        ), 
                        (
                            SELECT DepartmentSectionId
                            FROM @Departament
                        ), 
                        (
                            SELECT DepartmentSubSectionId
                            FROM @Departament
                        ), 
                         0, 
                         @currentTypeOfAssignmentId
                        );
                        SET @currentExecutorId = SCOPE_IDENTITY();
					    DELETE from @Departament;
                        EXEC dbo.LogDocumentOperation 
                             @docId = @docId, 
                             @ExecutorId = @currentExecutorId, 
                             @SenderWorkPlaceId = @workPlaceId, 
                             @ReceiverWorkPlaceId = @currentWorkPlaceId, 
                             @DocTypeId = 3, 
                             @OperationTypeId = @currentTypeOfAssignmentId, 
                             @DirectionTypeId = 18, 
                             @OperationStatusId = NULL, 
                             @OperationStatusDate = NULL, 
                             @OperationNote = NULL;
                        SET @taskCount-=1;
        END;
		
                IF EXISTS
                (
                    SELECT da.*
                    FROM dbo.DOCS_ADDRESSINFO da
                    WHERE da.AdrDocId = @docId
                          AND da.AdrTypeId = 2
                          AND da.AdrPersonId <> 0
                )
                    BEGIN
                        IF EXISTS
                        (
                            SELECT dt.*
                            FROM dbo.DOC_TASK dt
                            WHERE dt.TaskDocId = @docId
                                  AND dt.TypeOfAssignmentId = 1
                        )
                            BEGIN
                                UPDATE dbo.DOCS
                                  SET 
                                      DocDocumentstatusId = 1, --Icraatdadir
                                      DocDocumentOldStatusId = 16
                                WHERE DocId = @docId;
                        END;
                            ELSE
                            BEGIN
                                UPDATE dbo.DOCS
                                  SET 
                                      DocDocumentstatusId = 35, --Təsdiq edilib
                                      DocDocumentOldStatusId = 16,
                                      DocEnterdate=dbo.SYSDATETIME()
                                WHERE DocId = @docId;
                        END;
                END;
                    ELSE
                    BEGIN
                        IF EXISTS
                        (
                            SELECT dt.*
                            FROM dbo.DOC_TASK dt
                            WHERE dt.TaskDocId = @docId
                                  AND dt.TypeOfAssignmentId = 1
                        )
                            BEGIN
                                UPDATE dbo.DOCS
                                  SET 
                                      DocDocumentstatusId = 1, --Icraatdadir
                                      DocDocumentOldStatusId = 16
                                WHERE DocId = @docId;
                        END;
                            ELSE
                            BEGIN
                                UPDATE dbo.DOCS
                                  SET 
                                      DocDocumentstatusId = 16, --Imza olunub
                                      DocDocumentOldStatusId = 16
                                WHERE DocId = @docId;
                        END;
                END;
                UPDATE dbo.DOCS_EXECUTOR
                  SET 
                      ExecutorReadStatus = 1
                WHERE ExecutorDocId = @docId
                      AND ExecutorWorkplaceId = @workPlaceId;
                SET @result = 5;
        END;
            ELSE
            BEGIN
                IF EXISTS
                (
                    SELECT da.*
                    FROM dbo.DOCS_ADDRESSINFO da
                    WHERE da.AdrDocId = @docId
                          AND da.AdrTypeId = 2
                          AND da.AdrPersonId <> 0
                )
                    BEGIN
                        UPDATE dbo.DOCS
                          SET 
                              DocDocumentstatusId = 35, --Təsdiq edilib
                              DocDocumentOldStatusId = 16,
                              DocEnterdate=dbo.SYSDATETIME()
                        WHERE DocId = @docId;
                END;
                    ELSE
                    BEGIN
                        UPDATE dbo.DOCS
                          SET 
                              DocDocumentstatusId = 16, --Imza olunub
                              DocDocumentOldStatusId = 16
                        WHERE DocId = @docId;
                END;
                SET @result = 5;
        END;
    END;

