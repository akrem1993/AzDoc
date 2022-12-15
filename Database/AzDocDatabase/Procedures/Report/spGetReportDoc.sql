CREATE PROCEDURE [report].[spGetReportDoc] @workPlaceId       INT, 
                                          @beginDate         DATETIME = NULL, 
                                          @endDate           DATETIME = NULL, 
                                          @docTypeId         INT      = NULL, 
                                          @documentStatusId  INT      = NULL, 
                                          @resultOfExecution INT      = NULL
AS
    BEGIN
        SET NOCOUNT ON;
        IF(@beginDate IS NOT NULL
           AND @endDate IS NOT NULL)
            BEGIN
                SELECT d.DocId, 
                       d.DocEnterno, 
                       d.DocEnterdate, 
                       NULL AS MainPerformer, 
                       d.DocPlannedDate, 
                       d.DocDocno, 
                       d.DocDocdate, 
                (
                    SELECT da.FullName
                    FROM dbo.DOCS_ADDRESSINFO da
                    WHERE da.AdrDocId = d.DocId
                          AND da.AdrTypeId = 1
                ) AS FullName, 
                (
                    SELECT STUFF(
                    (
                        SELECT ' ' + OrganizationName
                        FROM DC_ORGANIZATION o
                        WHERE o.OrganizationId IN
                        (
                            SELECT af.AdrOrganizationId
                            FROM DOCS_ADDRESSINFO af
                            WHERE af.AdrDocId = d.DocId
                                  AND af.AdrTypeId = 3
                                  AND af.AdrAuthorId IS NOT NULL
                        ) FOR XML PATH('')
                    ), 1, 1, '')
                ) AS EntryFromWhere, 
                       d.DocDescription
                FROM VW_DOC_INFO AS d
                     LEFT JOIN dbo.DOCS_DIRECTIONS dr ON d.DocId = dr.DirectionDocId
                     LEFT JOIN dbo.DOCS_EXECUTOR e ON dr.DirectionId = e.ExecutorDirectionId
                WHERE(d.DocInsertedByDate BETWEEN @beginDate AND @endDate)
                     AND d.DocDoctypeId = CASE
                                              WHEN @docTypeId IS NOT NULL
                                              THEN @docTypeId
                                              ELSE d.DocDoctypeId
                                          END
                     AND d.DocDocumentstatusId = CASE
                                                     WHEN @documentStatusId IS NOT NULL
                                                          AND @resultOfExecution IS NULL
                                                     THEN @documentStatusId
                                                     WHEN @documentStatusId IS NOT NULL
                                                          AND @resultOfExecution IS NOT NULL
                                                     THEN @resultOfExecution
                                                     ELSE d.DocDocumentstatusId
                                                 END
                ORDER BY dr.DirectionInsertedDate DESC;
        END;
            ELSE
            BEGIN
                SELECT d.DocId, 
                       d.DocEnterno, 
                       d.DocEnterdate, 
                       NULL AS MainPerformer, 
                       d.DocPlannedDate, 
                       d.DocDocno, 
                       d.DocDocdate, 
                (
                    SELECT da.FullName
                    FROM dbo.DOCS_ADDRESSINFO da
                    WHERE da.AdrDocId = d.DocId
                          AND da.AdrTypeId = 1
                ) AS FullName, 
                (
                    SELECT STUFF(
                    (
                        SELECT ' ' + OrganizationName
                        FROM DC_ORGANIZATION o
                        WHERE o.OrganizationId IN
                        (
                            SELECT af.AdrOrganizationId
                            FROM DOCS_ADDRESSINFO af
                            WHERE af.AdrDocId = d.DocId
                                  AND af.AdrTypeId = 3
                                  AND af.AdrAuthorId IS NOT NULL
                        ) FOR XML PATH('')
                    ), 1, 1, '')
                ) AS EntryFromWhere, 
                       d.DocDescription
                FROM VW_DOC_INFO AS d
                     LEFT JOIN dbo.DOCS_DIRECTIONS dr ON d.DocId = dr.DirectionDocId
                     LEFT JOIN dbo.DOCS_EXECUTOR e ON dr.DirectionId = e.ExecutorDirectionId
                WHERE d.DocDocumentstatusId = 1 AND e.ExecutorWorkplaceId=@workPlaceId
                ORDER BY dr.DirectionInsertedDate DESC;
        END;
    END;

