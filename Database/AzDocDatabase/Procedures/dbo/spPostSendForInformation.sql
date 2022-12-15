/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

CREATE PROCEDURE [dbo].[spPostSendForInformation] @senderWorkPlaceId INT = 0, 
                                         @docId             INT, 
                                         @persons           [dbo].[UdttPersons] READONLY, 
                                         @result            INT OUT
AS
    BEGIN
        DECLARE @currentDirectionId INT, @executorFullName NVARCHAR(MAX), @executorOrganizationId INT, @executorDepartmentId INT, @executorId INT, @personId INT, @docTypeId INT, @personCount INT;
        SELECT @personCount = COUNT(0)
        FROM @persons p;
        WHILE(@personCount > 0)
            BEGIN
                SELECT @personId = s.PersonId
                FROM
                (
                    SELECT p.PersonId, 
                           ROW_NUMBER() OVER(
                           ORDER BY p.PersonId) AS rownumber
                    FROM @persons p
                ) s WHERE s.rownumber=@personCount;
                SELECT @docTypeId = d.DocDoctypeId
                FROM dbo.DOCS d
                WHERE d.DocId = @docId;
                INSERT INTO dbo.DOCS_DIRECTIONS
                (
                --DirectionId - column value is auto-generated
                DirectionDocId, 
                DirectionDate, 
                DirectionWorkplaceId, 
                DirectionTypeId, 
                DirectionControlStatus, 
                DirectionConfirmed, 
                DirectionSendStatus, 
                DirectionCreatorWorkplaceId, 
                DirectionInsertedDate
                )
                       SELECT @docId, 
                              dbo.SYSDATETIME(), 
                              p.PersonId, 
                              2, 
                              0, 
                              1, 
                              1, 
                              @senderWorkPlaceId, 
                              dbo.SYSDATETIME()
                       FROM @persons p WHERE p.PersonId=@personId;
                SET @currentDirectionId = SCOPE_IDENTITY();
                SET @executorFullName = CAST([dbo].[fnGetPersonnelDetailsbyWorkPlaceId](@personId, 1) AS NVARCHAR(MAX));
                SELECT @executorOrganizationId = wp.WorkplaceOrganizationId, 
                       @executorDepartmentId = wp.WorkplaceDepartmentId
                FROM dbo.DC_WORKPLACE wp
                WHERE wp.WorkplaceId = @personId;
                INSERT INTO dbo.DOCS_EXECUTOR
                (
                --ExecutorId - column value is auto-generated
                ExecutorDirectionId, 
                ExecutorDocId, 
                ExecutorWorkplaceId, 
                ExecutorFullName, 
                ExecutorMain, 
                DirectionTypeId, 
                ExecutorOrganizationId, 
                ExecutorTopDepartment, 
                ExecutorDepartment, 
                ExecutorReadStatus, 
                SendStatusId, 
                ExecutorControlStatus
                )
                       SELECT @currentDirectionId, 
                              @docId, 
                              p.PersonId, 
                              @executorFullName, 
                              0, 
                              2, 
                              @executorOrganizationId, 
                              @executorDepartmentId, 
                              @executorDepartmentId, 
                              0, 
                              3, 
                              0
                       FROM @persons p WHERE p.PersonId=@personId;
                SET @executorId = SCOPE_IDENTITY();
                EXEC dbo.LogDocumentOperation 
                     @docId = @docId, 
                     @ExecutorId = @executorId, 
                     @SenderWorkPlaceId = @senderWorkPlaceId, 
                     @ReceiverWorkPlaceId = @personId, 
                     @DocTypeId = @docTypeId, 
                     @OperationTypeId = 3, 
                     @DirectionTypeId = 2, 
                     @OperationStatusId = NULL, 
                     @OperationStatusDate = NULL, 
                     @OperationNote = NULL;
                SET @personCount-=1;
            END;
        SET @result = 1;
    END;

