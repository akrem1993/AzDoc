/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [outgoingdoc].[spGetElectronicDocument] @docId       INT = NULL, 
                                                        @docType     INT = NULL, 
                                                        @docInfoId   INT = NULL, 
                                                        @workPlaceId INT = NULL
AS
    BEGIN
        IF((@docId IS NOT NULL)
           AND (@doctype IS NOT NULL)
           AND (@docInfoId IS NULL))
            BEGIN
                DECLARE @directionType INT, @executorCount INT,@vizaMaxOrderIndex INT,@adrPersonId INT;

                update dbo.DOCS_EXECUTOR set ExecutorControlStatus=1
				where ExecutorDocId=@docId
				and ExecutorWorkplaceId = @workPlaceId;

                DECLARE @ActionTable TABLE
                (ActionId   INT, 
                 ActionName NVARCHAR(30)
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
    SELECT @vizaMaxOrderIndex = MAX(v.VizaOrderindex)
                FROM dbo.DOCS_VIZA v
                WHERE v.VizaDocId = @docId
                      AND v.IsDeleted = 0;
    SELECT @adrPersonId = a.AdrPersonId
                FROM dbo.DOCS_ADDRESSINFO a
                WHERE a.AdrDocId = @docId;
                SELECT
                (
                    SELECT a.Caption
                    FROM dbo.AC_MENU a
                    WHERE a.DocTypeId = d.DocDoctypeId
                ) AS DocTypeName, 
                d.DocEnterno AS DocEnterNo, 
                d.DocEnterdate AS DocEnterDate, 
                d.DocDocno AS DocDocNo, 
    d.DocDocDate as DocDocDate,--migrate3    
               -- case when d.DocDocdate is not null then d.DocDocdate else d.DocEnterDate  end AS DocDocDate, 
                d.DocDocumentstatusId DocDocumentStatusId, 
                @directionType AS DirectionTypeId, 
                (
                    SELECT fi.FileInfoId, 
                           fi.FileInfoName
                    FROM dbo.DOCS_FILE f
                         INNER JOIN DOCS_FILEINFO fi ON f.FileInfoId = fi.FileInfoId
                    WHERE f.FileDocId = @docId
                          AND f.IsDeleted = 0
						  AND f.IsReject = 0
                    ORDER BY f.FileIsMain DESC FOR JSON AUTO
                ) AS JsonFileInfoSelected, 
                (
       --             SELECT f.FileInfoId -- evvelki select
       --             FROM dbo.DOCS_FILE f
       --             WHERE f.FileDocId = d.DocId
       --                   AND f.FileIsMain = 1
       --                     AND f.IsDeleted = 0
							--AND f.FileVisaStatus<>0

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
					SELECT  top(1) df2.SignatureStatusId 
					FROM dbo.DOCS_FILEINFO df 
						INNER JOIN dbo.docs_file df2 ON df.FileInfoId = df2.FileInfoId
					WHERE df2.FileIsMain = 1 
						AND df2.IsDeleted = 0
						AND df2.IsReject=0
						--AND df2.FileVisaStatus<>0
						--AND df2.FileCurrentVisaGroup NOT IN (0)
						AND df2.FileDocId=d.DocId
					ORDER BY df.FileInfoInsertdate DESC
                ) AS FileSignatureStatus,
                (
                    SELECT *
                    FROM
                    (
                        SELECT v.VizaOrderindex OrderIndex, 
                               dbo.fnGetPersonnelbyWorkPlaceId(v.VizaWorkPlaceId, 106) AS PersonTo, 
                               'Viza üçün' AS ExecutorMain, 
                               0 TypeOfAssignmentId
                        FROM dbo.DOCS_VIZA v
                        WHERE v.VizaDocId = @docId
                              AND v.IsDeleted = 0
							  AND v.VizaFromWorkflow!=2
                              AND v.VizaOrderindex IS NOT NULL
                        UNION
                        SELECT
                        (
                            SELECT @vizaMaxOrderIndex + 1
                        ) OrderIndex, 
                        dbo.fnGetPersonnelbyWorkPlaceId(a.AdrPersonId, 106) AS PersonTo, 
                        N'İmza üçün' AS ExecutorMain, 
                        0 TypeOfAssignmentId
                        FROM dbo.DOCS_ADDRESSINFO a
                        WHERE a.AdrDocId = @docId
                              AND a.AdrTypeId = 1
                        UNION
                        SELECT
                        (
                            SELECT @vizaMaxOrderIndex + 2
                        ) OrderIndex, 
                        dbo.fnGetPersonnelbyWorkPlaceId(a.AdrPersonId, 106) AS PersonTo, 
                        N'Təsdiq üçün' AS ExecutorMain, 
                        0 TypeOfAssignmentId
                        FROM dbo.DOCS_ADDRESSINFO a
                        WHERE a.AdrDocId = @docId
                              AND a.AdrTypeId = 2
                              AND a.AdrPersonId <> 0
                        UNION
                        SELECT CASE
                                   WHEN @adrPersonId > 0
                                   THEN
                        (
                            SELECT @vizaMaxOrderIndex + 3
                        )
                                   WHEN @adrPersonId = 0
                                   THEN
                        (
                            SELECT @vizaMaxOrderIndex + 2
                        )
                               END AS OrderIndex, 
                               dbo.fnGetPersonnelbyWorkPlaceId(t.WhomAddressId, 106) AS PersonTo, 
                        (
                            SELECT s.SendStatusName
                            FROM DOC_SENDSTATUS s
                            WHERE s.SendStatusId = t.TypeOfAssignmentId
                        ) AS ExecutorMain, 
                               t.TypeOfAssignmentId
                        FROM dbo.DOC_TASK t
                        WHERE t.TaskDocId = @docId AND t.TypeOfAssignmentId<>3
                    ) s
                    ORDER BY s.TypeOfAssignmentId FOR JSON AUTO
                ) AS JsonOperationHistory, 
                (
                    SELECT ActionId AS Id, 
                           ActionName AS Name
                    FROM @ActionTable  FOR json AUTO
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

