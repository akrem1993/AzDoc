/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [citizenrequests].[spGetElectronicDocument] @docId       INT = NULL, 
                                                        @docType     INT = NULL, 
                                                        @docInfoId   INT = NULL, 
                                                        @workPlaceId INT = NULL
AS
    BEGIN
        IF((@docId IS NOT NULL)
           AND (@doctype IS NOT NULL)
           AND (@docInfoId IS NULL))
            BEGIN
                DECLARE @directionType INT, @executorCount INT;
                
                update dbo.DOCS_EXECUTOR set ExecutorControlStatus=1 
				where ExecutorDocId=@docId
				and ExecutorWorkplaceId = @workPlaceId;

                DECLARE @ActionTable TABLE
                (ActionId   INT, 
                 ActionName NVARCHAR(50)
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
                FROM dbo.DOCS_EXECUTOR e
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
                    FROM dbo.DOCS_FILE f
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
						INNER JOIN dbo.docs_file df2 ON df.FileInfoId = df2.FileInfoId
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
                      AND d.DocDoctypeId = @doctype FOR JSON AUTO;
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

