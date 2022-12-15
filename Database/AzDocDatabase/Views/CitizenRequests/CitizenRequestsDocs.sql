










CREATE   VIEW [citizenrequests].[CitizenRequestsDocs]
AS
SELECT d.DocId, 
               d.DocEnterno, 
               d.DocPlannedDate AS DocLastExecutionDate, 
               d.DocDocumentstatusId, 
               d.DocEnterdate, --
               d.DocDocno, 
        (
                SELECT s.SendStatusName + ':' + STUFF(
                (
                    SELECT ', ' +
                    (
                        SELECT dbo.fnGetPersonnelbyWorkPlaceId(e.ExecutorWorkplaceId, 106)
                    )
                    FROM dbo.DOCS_EXECUTOR e
                         LEFT JOIN dbo.DOCS_DIRECTIONS dr ON e.ExecutorDirectionId = dr.DirectionId
                    WHERE e.ExecutorDocId = d.DocId
                          AND e.DirectionTypeId = 1
                          AND dr.DirectionConfirmed = 1
                          AND e.SendStatusId = s.SendStatusId 
                          AND e.ExecutionstatusId IS null
                          FOR XML PATH('')
                          
                ), 1, 1, '') + '; '
                FROM dbo.DOC_SENDSTATUS s
                ORDER BY 1 FOR XML PATH('')
        ) AS TaskTo, 
        (
            SELECT STUFF(
            (
                SELECT ' ' + OrganizationName + ''
                FROM DC_ORGANIZATION o
                WHERE o.OrganizationId IN
                (
                    SELECT DISTINCT af.AdrOrganizationId
                    FROM DOCS_ADDRESSINFO af
                    WHERE af.AdrDocId = d.DocId
                          AND af.AdrTypeId = 3
                          AND af.AdrAuthorId IS NOT NULL
                ) FOR XML PATH('')
            ), 1, 1, '')
        ) AS DocAuthorInfo, 
        (case when (SELECT COUNT(0) FROM dbo.DOCS_APPLICATION da WHERE da.AppDocId = d.DocId)=1 then
        (
            SELECT STUFF(
            (
                SELECT ' ' + da.AppFirstname + ' ' + da.AppSurname
                FROM dbo.DOCS_APPLICATION da
                WHERE da.AppDocId = d.DocId FOR XML PATH('')
            ), 1, 1, '')
        )
		when  (SELECT COUNT(0) FROM dbo.DOCS_APPLICATION da WHERE da.AppDocId = d.DocId)>1 then
		(
            SELECT STUFF(
            (
                SELECT ' ' + da.AppFirstname + ' ' + da.AppSurname + '; '
                FROM dbo.DOCS_APPLICATION da
                WHERE da.AppDocId = d.DocId FOR XML PATH('')
            ), 1, 1, '')
        )
			end)
	    AS CitizenInfo,
        (
        (
            SELECT STUFF(
            (
                SELECT(a.AuthorName + ' ' + a.AuthorSurname + ' ' + ISNULL(a.AuthorLastname, '')) + ''
                FROM dbo.DOC_AUTHOR a
                WHERE a.AuthorId IN
                (
                    SELECT af.AdrAuthorId
                    FROM DOCS_ADDRESSINFO af
                    WHERE af.AdrDocId = d.DocId
                          AND af.AdrTypeId = 3
                          AND af.AdrAuthorId IS NOT NULL
                ) FOR XML PATH('')
            ), 1, 0, '')
        )
        ) AS Signer,
               CASE
                   WHEN af.FullName IS NULL
                   THEN
        (
            SELECT OrganizationName
            FROM DC_ORGANIZATION
            WHERE OrganizationId =
            (
                SELECT DISTINCT af.AdrOrganizationId
                FROM DOCS_ADDRESSINFO af
                WHERE af.AdrDocId = d.DocId
                      AND af.AdrTypeId = 2
                      AND af.AdrAuthorId IS NULL
            )
        )
                   ELSE af.FullName
               END AS WhomAdressed, 
               drf.ReceivedFormId DocFormId, 
               tt.TopicTypeId AS DocTopicTypeId, 
               da.ApplytypeId, 
               df.FormId, 
               d.DocDocdate AS DocDate, 
               d.DocDescription,
               CASE
                   WHEN EXISTS
        (
            SELECT da.AppAddress1
            FROM dbo.DOCS_APPLICATION da
            WHERE da.AppDocId = d.DocId
                  AND da.AppRepresenterId = 2
        )
                   THEN
        (
            SELECT da.AppAddress1
            FROM dbo.DOCS_APPLICATION da
            WHERE da.AppDocId = d.DocId
                  AND da.AppRepresenterId = 2
        )
                   WHEN NOT EXISTS
        (
            SELECT da.AppAddress1
            FROM dbo.DOCS_APPLICATION da
            WHERE da.AppDocId = d.DocId
                  AND da.AppRepresenterId = 2
        )
                   THEN
        (
            SELECT TOP 1 da.AppAddress1
            FROM dbo.DOCS_APPLICATION da
            WHERE da.AppDocId = d.DocId
                  AND da.AppRepresenterId = 1
        )
               END AS AppAddress,
               CASE
                   WHEN dr.DirectionCreatorWorkplaceId = e.ExecutorWorkplaceId
                   THEN CONVERT(BIT, 1)
                   ELSE e.ExecutorControlStatus
               END ExecutorControlStatus,
d.DocPeriodId,
dr.DirectionTypeId,
e.SendStatusId,
dr.DirectionSendStatus,
ds.DocumentstatusId,
d.DocTopicId,
d.DocReceivedFormId,
d.DocFormId AS DocForm,
dr.DirectionInsertedDate,
e.ExecutorReadStatus,
e.ExecutorWorkplaceId,
dr.DirectionConfirmed,
e.ExecutionstatusId,
d.DocTopicType,
d.DocOrganizationId,
(dbo.fnGetPersonnelbyWorkPlaceId
     (
     (
         SELECT de.ExecutorWorkplaceId
         FROM dbo.DOCS_EXECUTOR de
         WHERE de.ExecutorDocId = d.DocId
               AND de.DirectionTypeId=4
     ), 106
     )) AS CreaterPersonnelName,
e.ExecutorOrganizationId

FROM VW_DOC_INFO AS d
 JOIN dbo.DOCS_DIRECTIONS dr ON d.DocId = dr.DirectionDocId
 JOIN dbo.DOCS_EXECUTOR e ON dr.DirectionId = e.ExecutorDirectionId
 JOIN dbo.DOC_FORM df ON df.FormId = d.DocFormId
 JOIN dbo.DOC_APPLYTYPE da ON d.DocApplytypeId = da.ApplytypeId
 JOIN dbo.DOC_DOCUMENTSTATUS ds ON ds.DocumentstatusId = d.DocDocumentstatusId
left JOIN dbo.DOCS_ADDRESSINFO af ON af.AdrDocId = d.DocId
                                AND  af.AdrTypeId in(2,3)
 JOIN dbo.DOC_RECEIVED_FORM drf ON  drf.ReceivedFormId = d.DocReceivedFormId
JOIN dbo.DOC_TOPIC_TYPE tt ON tt.TopicTypeId = d.DocTopicType
WHERE  
d.DocDoctypeId = 2
AND 
(( SELECT CASE WHEN dr.DirectionTypeId = 12 THEN 1 ELSE ISNULL(dr.DirectionConfirmed, 0)END) = 1
OR (e.SendStatusId IN(5, 15) AND dr.DirectionSendStatus = 1))--kamran-derkenar ucun
AND (e.SendStatusId IS NULL OR  isnull(e.ExecutionstatusId,0) <> 1)--Nurlan(icraci geri qaytaranda gridde gorsenmemesi ucun)


