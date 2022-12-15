






CREATE viEW [serviceletters].[ServiceLettersDocs]
AS
SELECT d.DocId, 
               d.DocEnterno, 
               (CASE WHEN d.DocDocumentstatusId=16   AND
        (
            SELECT dol.OperationStatus
            FROM dbo.DOCS_EXECUTOR de
                 LEFT JOIN dbo.DocOperationsLog dol ON de.ExecutorId = dol.ExecutorId
            WHERE de.ExecutorDocId = d.DocId
                  AND de.ExecutorReadStatus = 0
                  AND dol.OperationTypeId = 12
                  AND dol.OperationStatus = 5
        ) = 5 THEN 36 
		else 
			ds.DocumentstatusId end) AS DocDocumentstatusId , 
               d.DocEnterdate, --
               d.DocPlannedDate, 
               da.FullName AS Signer, 
        (
                SELECT s.SendStatusName + ' :' + STUFF(
                (
                    SELECT ', ' +
                    (
                        SELECT dbo.fnGetPersonnelbyWorkPlaceId(t.WhomAddressId, 106)
                    )
                    FROM dbo.DOC_TASK t
                    WHERE t.TaskDocId = d.DocId
                          AND d.DocDocumentstatusId IN(1)
                    AND t.TypeOfAssignmentId = s.SendStatusId FOR XML PATH('')
                ), 1, 1, '') + '; '
                FROM dbo.DOC_SENDSTATUS s
                ORDER BY 1 FOR XML PATH('')
        ) AS SendTo, 
               d.DocDescription,
               CASE
                   WHEN dr.DirectionCreatorWorkplaceId = e.ExecutorWorkplaceId
                   THEN CONVERT(BIT, 1)
                   ELSE e.ExecutorControlStatus
               END ExecutorControlStatus,
                dr.DirectionTypeId,
                e.ExecutorWorkplaceId,
                e.ExecutorOrganizationId,
                e.ExecutorTopDepartment,
                e.ExecutorDepartment,
                e.ExecutorSection,
                e.ExecutorSubsection,
--search
da.AdrTypeId,
dr.DirectionConfirmed,
e.SendStatusId,
d.DocPeriodId,
e.ExecutorReadStatus,
dr.DirectionInsertedDate,

dr.DirectionSendStatus,
d.DocOrganizationId,
d.DocDocno,
(dbo.fnGetPersonnelbyWorkPlaceId
     (
     (
         SELECT de.ExecutorWorkplaceId
         FROM dbo.DOCS_EXECUTOR de
         WHERE de.ExecutorDocId = d.DocId
               AND de.DirectionTypeId=4 AND de.ExecutorMain=0
     ), 106
     )) AS CreaterPersonnelName
FROM VW_DOC_INFO AS d
JOIN dbo.DOCS_DIRECTIONS dr ON d.DocId = dr.DirectionDocId
JOIN dbo.DOCS_EXECUTOR e ON dr.DirectionId = e.ExecutorDirectionId
JOIN dbo.DOC_DOCUMENTSTATUS ds ON ds.DocumentstatusId = d.DocDocumentstatusId
JOIN dbo.DOCS_ADDRESSINFO da ON d.DocId = da.AdrDocId
WHERE 
d.DocDoctypeId = 18
AND da.AdrTypeId = 1
AND (ISNULL(dr.DirectionConfirmed, 0) =1
OR (e.SendStatusId = 5 AND dr.DirectionSendStatus = 1))
AND (e.SendStatusId IS NULL OR e.SendStatusId <> 14)
AND e.ExecutionstatusId IS null

