
/*
Migrated by Kamran A-eff 23.08.2019
*/
/*
Migrated by Kamran A-eff 06.08.2019
*/
/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [serviceletters].[spOperationVisaAccept] @docId       INT, 
                                                         @docTypeId   INT, 
                                                         @workPlaceId INT, 
                                                         @note        NVARCHAR(MAX) = NULL, 
                                                         @result      INT OUTPUT
AS
    BEGIN
        SET NOCOUNT ON;
        DECLARE @vizaCount INT= 0, @vizaOrderIndex INT= 0, @vizaConfirmedCount INT= 0, @confirmWorkPlaceId INT= 0, @vizaId INT, @documentStatusId INT, @executorId INT, @directionType INT;
        SELECT @documentStatusId = d.DocDocumentstatusId
        FROM dbo.DOCS d
        WHERE d.DocId = @docId;
        IF EXISTS
        (
            SELECT v.VizaId
            FROM dbo.DOCS_VIZA v
            WHERE v.VizaDocId = @docId
                  AND v.VizaWorkPlaceId = @workPlaceId
                  AND v.IsDeleted = 0
        )
            BEGIN      
                --select @vizaCount=count(0) from dbo.DOCS_VIZA v where v.VizaDocId=@docId  AND v.IsDeleted=0;
                --if(@vizaCount>1)
                --begin
			
                SELECT @vizaOrderIndex = v.VizaOrderindex
                FROM dbo.DOCS_VIZA v
                WHERE v.VizaDocId = @docId
                      AND v.VizaWorkPlaceId = @workPlaceId
                      AND v.IsDeleted = 0;
                IF EXISTS
                (
                    SELECT v.VizaId
                    FROM dbo.DOCS_VIZA v
                    WHERE v.VizaDocId = @docId
                          AND (v.VizaOrderindex = @vizaOrderIndex
                               OR v.VizaOrderindex IS NULL)
                          AND v.VizaConfirmed = 0
                          AND v.IsDeleted = 0
                )
                    BEGIN
                        SELECT @executorId = de.ExecutorId, 
                               @directionType = de.DirectionTypeId
                        FROM dbo.DOCS_EXECUTOR de
                        WHERE de.ExecutorDocId = @docId
                              AND de.ExecutorReadStatus = 0
                              AND de.ExecutorWorkplaceId = @workPlaceId;
                        UPDATE dbo.DOCS_VIZA
                          SET 
                              VizaConfirmed = 1, 
                              VizaReplyDate = dbo.SYSDATETIME()
                        WHERE VizaDocId = @docId
                              AND VizaWorkPlaceId = @workPlaceId
                              AND IsDeleted = 0;
                        UPDATE dbo.DOCS_EXECUTOR
                          SET 
                              ExecutorReadStatus = 1, 
                              ExecutorControlStatus = 1
                        WHERE ExecutorId = @executorId;
                        UPDATE dbo.DocOperationsLog
                          SET 
                              dbo.DocOperationsLog.OperationStatus = CASE
                                                                         WHEN @directionType = 3
                                                                         THEN 3
                                                                         ELSE 6
                                                                     END, -- int
                              dbo.DocOperationsLog.OperationStatusDate = dbo.SYSDATETIME(), -- datetime
                              dbo.DocOperationsLog.OperationNote = @note -- nvarchar
                        WHERE dbo.DocOperationsLog.DocId = @docId
                              AND dbo.DocOperationsLog.ExecutorId = @executorId;
                        SELECT @vizaConfirmedCount = COUNT(0)
                        FROM dbo.DOCS_VIZA v
                        WHERE v.VizaDocId = @docId
                              AND v.VizaOrderindex = @vizaOrderIndex
                              AND v.VizaConfirmed = 0
                              AND v.IsDeleted = 0;
                        IF(@vizaConfirmedCount = 0)--eger oz qrupunda testiq edecek shexs qalmayibsa 0 olur
                            BEGIN
                                IF EXISTS
                                (
                                    SELECT *
                                    FROM dbo.DOCS_VIZA v --novbeti qrupda kimse varsa
                                    WHERE v.VizaDocId = @docId
                                          AND v.VizaWorkPlaceId <> @workPlaceId
                                          AND v.VizaOrderindex > @vizaOrderIndex
                                          AND v.IsDeleted = 0
                                )
                                    BEGIN
                                        EXEC [serviceletters].[spSendVizaToNextGroup] 
                                             @workPlaceId = @workPlaceId, 
                                             @docId = @docId;
                                END;
                                    ELSE------novbeti qrup yoxdusa
                                    BEGIN
                                        IF(@documentStatusId = 28) --Əgər senedin statusu vizadadirsa,sened gedir imza eden shexse
                                            BEGIN
                                                EXEC serviceletters.spOperationSigner 
                                                     @docId = @docId, 
                                                     @docTypeId = @docTypeId;
                                        END;
                                        IF(@documentStatusId = 16)--sened testiqlenibse gedir tapsiriqlara
                                            BEGIN
											UPDATE dbo.DOCS
											SET 
												  DocEnterdate = dbo.SYSDATETIME()           
											WHERE DocId = @docId;
                                                DECLARE @relatedDocCount INT= 0;
                                                SELECT @relatedDocCount = COUNT(0)
                                                FROM dbo.DOCS_RELATED dr
                                                WHERE dr.RelatedDocId = @docId
                                                      AND dr.RelatedTypeId = 2;

                                                IF(@relatedDocCount = 0)
                                                    BEGIN
                                                        EXEC serviceletters.spOperationWhomAddress 
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
                                                        EXEC serviceletters.spOperationWhomAddress 
                                                             @docId = @docId, 
                                                             @docTypeId = @docTypeId, 
                                                             @workPlaceId = @workPlaceId, 
                                                             @result = @result OUT;
                                                        SET @result = @result;
                                                END;
                                        END;
                                END;----------------------------------------------------------------------------------------
                        END;
                END;
                SET @result = 5;
                --end
                --else
                --BEGIN
                --       SELECT 
                --       @executorId=de.ExecutorId,
                --       @directionType=de.DirectionTypeId 
                --       FROM dbo.DOCS_EXECUTOR de
                --  WHERE 
                --  de.ExecutorDocId=@docId
                --  and de.ExecutorReadStatus=0
                --  AND de.ExecutorWorkplaceId=@workPlaceId;
                --  update dbo.DOCS_VIZA 
                --  set VizaConfirmed=1,
                --  VizaReplyDate=SYSDATETIME()
                --  where 
                --  VizaDocId=@docId 
                --  and VizaWorkPlaceId=@workPlaceId
                --  and IsDeleted=0;
                --  update dbo.DOCS_EXECUTOR 
                --  set ExecutorReadStatus=1
                --  where 
                --       ExecutorId=@executorId;
                --  UPDATE dbo.DocOperationsLog
                --  SET
                --      dbo.DocOperationsLog.OperationStatus = 3, -- int
                --      dbo.DocOperationsLog.OperationStatusDate = SYSDATETIME(), -- datetime
                --      dbo.DocOperationsLog.OperationNote = @note -- nvarchar
                --  where 
                --  dbo.DocOperationsLog.DocId=@docId
                --  AND dbo.DocOperationsLog.ExecutorId=@executorId;
                --   EXEC dms_insdoc.spOperationSigner 
                -- @docId = @docId,
                -- @docTypeId = @docTypeId;
                --end

        END;
        SET @result = 5;
    END;
