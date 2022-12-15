CREATE PROCEDURE [dbo].[spGetDocCount] @periodId    INT = NULL, 
                                      @workPlaceId INT = NULL
AS
    BEGIN
        SET NOCOUNT ON;
        IF(@periodId IS NULL)
            BEGIN
                SELECT @periodId = MAX(p.PeriodId)
                FROM DOC_PERIOD p;
        END;
        SELECT *
        FROM
        (
            SELECT N'Bütün sənədlər' AS SendStatusName, 
                   COUNT(0) AS DocNo, 
                   -1 AS SendStatusId
            FROM dbo.VW_DOC_INFO d
                  JOIN dbo.DOCS_DIRECTIONS dd ON d.DocId = dd.DirectionDocId
                  JOIN dbo.DOCS_EXECUTOR de ON dd.DirectionId = de.ExecutorDirectionId
                  LEFT JOIN dbo.DOC_SENDSTATUS ds ON de.SendStatusId = ds.SendStatusId
            WHERE de.ExecutorReadStatus = 0
                  AND de.ExecutorWorkplaceId = @workPlaceId
                  AND de.DirectionTypeId <> 4
                  AND (
            (
                SELECT CASE
                           WHEN de.DirectionTypeId IN(12, 13)
                           THEN 1
                           ELSE ISNULL(dd.DirectionConfirmed, 1)
                       END
            ) = 1)
            
            UNION
            SELECT *
            FROM
            (
                SELECT ds.SendStatusName, 
                       COUNT(0) AS DocNo, 
                       ds.SendStatusId
                FROM dbo.VW_DOC_INFO d
                      JOIN dbo.DOCS_DIRECTIONS dd ON d.DocId = dd.DirectionDocId
                      JOIN dbo.DOCS_EXECUTOR de ON dd.DirectionId = de.ExecutorDirectionId
                      LEFT JOIN dbo.DOC_SENDSTATUS ds ON ds.SendStatusId = (CASE
                                                                   WHEN dd.DirectionTypeId = 11
                                                                   THEN 16
                                                                   ELSE de.SendStatusId
                                                               END)
                WHERE de.ExecutorReadStatus = 0
                      AND de.ExecutorWorkplaceId = @workPlaceId
                      AND (
                (
                    SELECT CASE
                               WHEN de.DirectionTypeId IN(12, 13)
                               THEN 1
                               ELSE ISNULL(dd.DirectionConfirmed, 1)
                           END
                ) = 1)
                GROUP BY ds.SendStatusName, 
                         ds.SendStatusId
            ) s
            WHERE s.SendStatusId IS NOT NULL
        ) s
        ORDER BY s.SendStatusId DESC;
    END;
