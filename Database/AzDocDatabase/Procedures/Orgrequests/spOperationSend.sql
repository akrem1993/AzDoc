/*
Migrated by Kamran A-eff 23.08.2019
*/
/*
Migrated by Kamran A-eff 06.08.2019
*/
/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [orgrequests].[spOperationSend] @docId       INT, 
                                                @workPlaceId INT, 
                                                @result      INT OUTPUT
AS
     DECLARE @executorId INT, @directionId INT, @executorFullName NVARCHAR(MAX), @executorOrganizationId INT, @executorDepartmentId INT, @chiefWorkPlaceId INT, @docIsAppealBoard INT, @currentDocumentStatusId INT, @currentOrgId INT, @documentStatusId INT, @oldDocumentStatusId INT, @directionTypeId INT, @sendStatusId INT , @operationTypeId INT,@operationStatusId  INT;
    BEGIN
        SET NOCOUNT ON;
        IF EXISTS
        (
            SELECT *
            FROM dbo.DOCS d
            WHERE d.DocId = @docId
                  AND d.DocDeleted = 0
        )
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
                UPDATE dbo.DOCS
                  SET 
                      DocDocumentstatusId = @documentStatusId, --aidiyyətı üzrə göndərilib
                      DocDocumentOldStatusId = @oldDocumentStatusId, 
                      DocUpdatedById = @workPlaceId, 
                      DocUpdatedByDate = dbo.sysdatetime()
                WHERE dbo.DOCS.DocId = @docId;
                INSERT INTO DOCS_DIRECTIONS
                (DirectionCreatorWorkplaceId, 
                 DirectionDocId, 
                 DirectionTypeId, 
                 DirectionWorkplaceId, 
                 DirectionInsertedDate, 
                 DirectionDate, 
                 DirectionConfirmed
                )
                VALUES
                (@workPlaceId, 
                 @docId, 
                 @directionTypeId, 
                 @workPlaceId, 
                 dbo.SYSDATETIME(), 
                 dbo.SYSDATETIME(), 
                 1
                );
                SET @directionId = SCOPE_IDENTITY();
                SELECT @docIsAppealBoard = d.DocIsAppealBoard
                FROM dbo.DOCS d
                WHERE d.DocId = @docId
                      AND d.DocIsAppealBoard = 1;
                IF(@docIsAppealBoard = 1)
                    BEGIN
                        SELECT @chiefWorkPlaceId = dbo.fnGetDepartmentChiefAppeal(@workPlaceId);
                END;
                    ELSE if(@currentOrgId is null)
                    BEGIN
                        SELECT @chiefWorkPlaceId = dbo.fnGetDepartmentChief(@workPlaceId);
                    END;
                    else
                    begin
                      if(@oldDocumentStatusId=15)
                      begin
                        SELECT @chiefWorkPlaceId = dbo.fnGetDepartmentChief(@workPlaceId);
                      end
                      else
                      begin
                        SELECT @chiefWorkPlaceId = dbo.fnGetOrganizationChief(@workPlaceId);
                      end
                    end
                SELECT @executorFullName = CONVERT(NVARCHAR(MAX),
                (
                    SELECT [dbo].[fnGetPersonnelDetailsbyWorkPlaceId](@chiefWorkPlaceId, 1)
                ));
                SELECT @executorOrganizationId = wp.WorkplaceOrganizationId, 
                       @executorDepartmentId = wp.WorkplaceDepartmentId
                FROM dbo.DC_WORKPLACE wp
                WHERE wp.WorkplaceId = @chiefWorkPlaceId;
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
                       WHERE w.WorkplaceId = @chiefWorkPlaceId;
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
                 SendStatusId, 
                 ExecutorReadStatus
                )
                VALUES
                (@directionId, 
                 @docId, 
                 @chiefWorkPlaceId, 
                 @executorFullName, 
                 0, 
                 @directionTypeId, 
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
                 @sendStatusId, 
                 0
                );
                SET @executorId = SCOPE_IDENTITY();
                EXEC dbo.LogDocumentOperation 
                     @docId = @docId, 
                     @ExecutorId = @executorId, 
                     @SenderWorkPlaceId = @workPlaceId, 
                     @ReceiverWorkPlaceId = @chiefWorkPlaceId, 
                     @DocTypeId = 1, 
                     @OperationTypeId = @operationTypeId, 
                     @DirectionTypeId = @directionTypeId, 
                     @OperationStatusId = @operationStatusId, 
                     @OperationStatusDate = NULL, 
                     @OperationNote = NULL;
                SET @result = 1;
                UPDATE dbo.DOCS_EXECUTOR
                  SET 
                      ExecutorReadStatus = 1, 
                      ExecutorControlStatus = 1
                WHERE ExecutorDocId = @docId
                      AND ExecutorWorkplaceId = @workPlaceId;
        END;
    END;
