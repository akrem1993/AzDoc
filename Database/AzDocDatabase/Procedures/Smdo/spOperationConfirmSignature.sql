
/*
Migrated by Kamran A-eff 23.08.2019
*/
/*
Migrated by Kamran A-eff 06.08.2019
*/
/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [smdo].[spOperationConfirmSignature] @docId       INT, 
                                                               @docTypeId   INT, 
                                                               @workPlaceId INT, 
                                                               @note        NVARCHAR(MAX) = NULL, 
                                                               @result      INT OUTPUT
AS
    BEGIN
        SET NOCOUNT ON;
        DECLARE @organizationIndex INT, @date DATE= dbo.SYSDATETIME(), @directionId INT, @confirmWorkPlaceId INT= 0, @oldConfirmWorkPlaceId INT= 0, @executorFullName NVARCHAR(MAX), @executorOrganizationId INT, @executorDepartmentId INT, @vizaId INT, @fileId INT;
        DECLARE @signatureExecutorId INT, @docStatus INT;
        SELECT @docStatus = d.DocDocumentstatusId
        FROM dbo.DOCS d
        WHERE d.DocId = @docId;
        IF(@docStatus <> 30)
            RETURN;
        SELECT @signatureExecutorId = de.ExecutorId
        FROM dbo.DOCS_EXECUTOR de
        WHERE de.ExecutorDocId = @docId
              AND de.ExecutorWorkplaceId = @workPlaceId
              AND de.ExecutorReadStatus = 0
              AND de.DirectionTypeId = 8;
        UPDATE dbo.DOCS_EXECUTOR
          SET 
              ExecutorReadStatus = 1, 
              ExecutorControlStatus = 1
        WHERE ExecutorId = @signatureExecutorId;
        UPDATE dbo.DocOperationsLog
          SET 
              dbo.DocOperationsLog.OperationStatus = 9, 
              dbo.DocOperationsLog.OperationStatusDate = dbo.SYSDATETIME(), 
              dbo.DocOperationsLog.OperationNote = @note
        WHERE dbo.DocOperationsLog.DocId = @docId
              AND ExecutorId = @signatureExecutorId;
        UPDATE dbo.DOCS
          SET 
              DocEnterdate = dbo.SYSDATETIME(), 
              DocDocumentstatusId = 16, --İmzalanib
              DocDocumentOldStatusId = 30
        WHERE DocId = @docId;
        UPDATE dbo.DOCS_DIRECTIONS
          SET 
              DirectionSendStatus = 1
        WHERE DirectionDocId = @docId
              AND DirectionTypeId = 8;
        UPDATE dbo.DOCS_FILE
          SET 
              SignatureStatusId = 2, 
              SignatureDate = dbo.SYSDATETIME()
        WHERE FileDocId = @docId
              AND FileIsMain = 1
              AND IsDeleted = 0
              AND IsReject = 0;
        SELECT @confirmWorkPlaceId = a.AdrPersonId
        FROM DOCS_ADDRESSINFO a
        WHERE a.AdrDocId = @docId
              AND a.AdrTypeId = 2; --Tesdiq eden shexs

        IF(@confirmWorkPlaceId = 0) -- Təsdiq edən şəxs yoxdu
            BEGIN
                DECLARE @relatedDocCount INT= 0;
                SELECT @relatedDocCount = COUNT(0)
                FROM dbo.DOCS_RELATED dr
                WHERE dr.RelatedDocId = @docId
                      AND dr.RelatedTypeId = 2;
                IF(@relatedDocCount = 0)
                    BEGIN
                        EXEC [smdo].spOperationWhomAddress 
                             @docId = @docId, 
                             @docTypeId = @docTypeId, 
                             @workPlaceId = @workPlaceId, 
                             @result = @result OUT;
                        SET @result = @result;
                END;
                    ELSE
                    BEGIN
                        WHILE(@relatedDocCount > 0)
                            BEGIN
                                DECLARE @workplaceCountAnswer INT, @relatedDocumentId INT;
                                SELECT @workplaceCountAnswer = COUNT(0)
                                FROM dbo.DOCS_EXECUTOR de
                                WHERE de.ExecutorDocId IN
                                (
                                    SELECT dr.RelatedDocumentId
                                    FROM dbo.DOCS_RELATED dr
                                    WHERE dr.RelatedDocId = @docId
                                          AND dr.RelatedTypeId = 2
                                )
                                      AND de.SendStatusId = 1
                                      AND de.ExecutorReadStatus = 0;
                                SELECT @relatedDocumentId = s.RelatedDocumentId
                                FROM
                                (
                                    SELECT dr.RelatedDocumentId, 
                                           ROW_NUMBER() OVER(
                                           ORDER BY dr.RelatedDocumentId) AS rownumber
                                    FROM dbo.DOCS_RELATED dr
                                    WHERE dr.RelatedDocId = @docId
                                          AND dr.RelatedTypeId = 2
                                ) s
                                WHERE s.rownumber = @relatedDocCount;
                                IF(
                                (
                                    SELECT COUNT(0)
                                    FROM dbo.DOCS d
                                    WHERE d.DocId = @relatedDocumentId
                                          AND d.DocDoctypeId IN(1, 2)
                                ) = 0)
                                    BEGIN
                                        UPDATE dbo.DocOperationsLog
                                          SET 
                                              OperationStatus = 14, -- int
                                              OperationStatusDate = dbo.SYSDATETIME()
                                        WHERE dbo.DocOperationsLog.DocId = @relatedDocumentId
                                              AND ReceiverWorkPlaceId =
                                        (
                                            SELECT dol.ReceiverWorkPlaceId
                                            FROM dbo.DocOperationsLog dol
                                            WHERE dol.DocId = @relatedDocumentId
                                                  AND dol.ExecutorId =
                                            (
                                                SELECT de.ExecutorTopId
                                                FROM dbo.DOCS_EXECUTOR de
                                                     JOIN dbo.DOCS_DIRECTIONS dd ON de.ExecutorDirectionId = dd.DirectionId
                                                WHERE de.ExecutorDocId = @relatedDocumentId
                                                      AND de.ExecutorWorkplaceId =
                                                (
                                                    SELECT de.ExecutorWorkplaceId
                                                    FROM dbo.DOCS_EXECUTOR de
                                                    WHERE de.ExecutorDocId = @docId
                                                          AND de.DirectionTypeId = 4
                                                )
                                                      AND de.ExecutorTopId IS NOT NULL
                                            )
                                        );
                                END;
                                IF(@workplaceCountAnswer = 0)
                                    BEGIN
                                        UPDATE dbo.docs
                                          SET 
                                              DocDocumentstatusId = 12, 
                                              DocDocumentOldStatusId = 1
                                        WHERE DocId = @relatedDocumentId;
                                        UPDATE dbo.DOCS_EXECUTOR
                                          SET 
                                              dbo.DOCS_EXECUTOR.ExecutorReadStatus = 1, -- bit										   
                                              dbo.DOCS_EXECUTOR.ExecutorControlStatus = 1 -- bit
                                        WHERE dbo.DOCS_EXECUTOR.ExecutorDocId = @relatedDocumentId;
                                END;
                                SET @relatedDocCount-=1;
                END;
                        EXEC [smdo].spOperationWhomAddress 
                             @docId = @docId, 
                             @docTypeId = @docTypeId, 
                             @workPlaceId = @workPlaceId, 
                             @result = @result OUT;
                        SET @result = @result;
                END;
        END;
            ELSE --Təsdiq edən şəxs var.. Onda təsdiq edən şəxsə getsin
            BEGIN
                EXEC [smdo].spSendToConfirmedPerson 
                     @docId = @docId, 
                     @docTypeId = @docTypeId, 
                     @workPlaceId = @workPlaceId, 
                     @confirmWorkPlaceId = @confirmWorkPlaceId, 
                     @result = @result OUT;
        END;
        SET @result = 7;
    END;

