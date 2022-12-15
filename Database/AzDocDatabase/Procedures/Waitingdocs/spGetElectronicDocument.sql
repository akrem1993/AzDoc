CREATE PROCEDURE [WaitingDocs].[spGetElectronicDocument] @docId       INT, 
                                                @docInfoId   INT = NULL, 
                                                @workPlaceId INT = NULL
                                              --  @result      INT OUTPUT
AS
    BEGIN
        BEGIN TRY
   BEGIN TRANSACTION;
   DECLARE @doctypeId int;
            SELECT @doctypeId= d.DocDoctypeId
            FROM dbo.DOCS d
            WHERE d.DocId = @docId;  
            IF(@docTypeId = 1)
                 BEGIN
        IF((@docId IS NOT NULL)
           AND (@doctypeId IS NOT NULL)
           AND (@docInfoId IS NULL))
            BEGIN
                DECLARE @directionType INT, @executorCount INT;
                --UPDATE WaitingDocs.DOCS_EXECUTOR
                --  SET 
                --      ExecutorControlStatus = 1
                --WHERE ExecutorDocId = @docId
                --      AND ExecutorWorkplaceId = @workPlaceId;
                DECLARE @ActionTable TABLE
                (ActionId   INT, 
                 ActionName NVARCHAR(MAX)
                );
                INSERT INTO @ActionTable
                (ActionId, 
                 ActionName
                )
                EXEC [dbo].[GetDocumentActions] 
                     @docId = @docId, 
                     @workPlaceId = @workPlaceId, 
                     @menuTypeId = 1;
                SELECT @directionType = e.DirectionTypeId
                FROM WaitingDocs.DOCS_EXECUTOR e
                WHERE e.ExecutorDocId = @docId
                      AND e.ExecutorWorkplaceId = @workPlaceId;
                SELECT
                (
                    SELECT a.Caption
                    FROM dbo.AC_MENU a
                    WHERE a.DocTypeId = d.DocDoctypeId
                ) AS DocTypeName, 
                d.DocEnterno AS DocEnterNo, 
                d.DocEnterdate AS DocEnterDate, 
                d.DocDocno AS DocDocNo, 
                d.DocDocdate AS DocDocDate, 
                d.DocDocumentstatusId DocDocumentStatusId, 
                @directionType AS DirectionTypeId, 
                (
                    SELECT fi.FileInfoId, 
                           fi.FileInfoName
                    FROM WaitingDocs.DOCS_FILE f
                         INNER JOIN DOCS_FILEINFO fi ON f.FileInfoId = fi.FileInfoId
                    WHERE f.FileDocId = @docId
                          AND f.IsDeleted = 0
                    ORDER BY f.FileIsMain DESC FOR JSON AUTO
                ) AS JsonFileInfoSelected, 
                (
                    --SELECT f.FileInfoId -- evvelki select
                    --FROM dbo.DOCS_FILE f
                    --WHERE f.FileDocId = d.DocId
                    --      AND f.FileIsMain = 1
                    --      AND f.IsDeleted = 0

					SELECT  top(1) df.FileInfoId FROM dbo.DOCS_FILEINFO df 
						INNER JOIN WaitingDocs.docs_file df2 ON df.FileInfoId = df2.FileInfoId
					WHERE df2.FileIsMain = 1 
						AND df2.IsDeleted = 0
						AND df2.IsReject=0
						--AND df2.FileVisaStatus<>0
						AND df2.FileCurrentVisaGroup NOT IN (0)
						AND df2.FileDocId=d.DocId
					ORDER BY df.FileInfoInsertdate DESC
                ) AS FileInfoId, 
                (
                    SELECT ActionId AS Id, 
                           ActionName AS Name
                    FROM @ActionTable FOR json AUTO
                ) AS JsonActionName, 
                d.DocDescription AS Description
                FROM dbo.docs d
                WHERE d.docId = @docId
                      AND d.DocDoctypeId = @doctypeId FOR JSON AUTO;
        END;
            ELSE
            IF(@docInfoId IS NOT NULL)
                BEGIN
                    SELECT *
                    FROM dbo.DOCS_FILEINFO fi
                    WHERE fi.FileInfoId =
                    (
                        SELECT f.FileInfoId
                        FROM dbo.DOCS_FILE f
                        WHERE f.FileInfoId = @docInfoId
                    ) FOR JSON AUTO;
            END;
    END;
    
              
            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH--=======================================CATCH===================================================
            ROLLBACK TRANSACTION;
            --SET @result = -1;
            --DECLARE @ErrorProcedure NVARCHAR(MAX), @ErrorMessage NVARCHAR(MAX), @ErrorSeverity INT, @ErrorState INT;
            --SELECT @ErrorProcedure = 'Procedure:' + ERROR_PROCEDURE(), 
            --       @ErrorMessage = @ErrorProcedure + '.Message:' + ERROR_MESSAGE() + ' Line ' + CAST(ERROR_LINE() AS NVARCHAR(5)), 
            --       @ErrorSeverity = ERROR_SEVERITY(), 
            --       @ErrorState = ERROR_STATE();
            --INSERT INTO dbo.debugTable
            --([text], 
            -- insertDate
            --)
            --VALUES
            --(@ErrorMessage, 
            -- SYSDATETIME()
            --);
            --RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
        END CATCH;--========================================CATCH======================================================

    END;

