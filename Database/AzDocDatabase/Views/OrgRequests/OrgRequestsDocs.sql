

CREATE VIEW [orgrequests].[OrgRequestsDocs]
AS
     SELECT d.DocId, 
            d.DocEnterno, 
            d.DocPlannedDate AS DocLastExecutionDate, 
            d.DocDocumentstatusId, 
            d.DocEnterdate, --
            d.DocDocno,
            CASE
                WHEN d.DocDocumentstatusId IN(1, 12, 33)
                THEN
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
                   AND e.ExecutionstatusId IS NULL FOR XML PATH('')
         ), 1, 1, '') + '; '
         FROM dbo.DOC_SENDSTATUS s
         ORDER BY 1 FOR XML PATH('')
     )
            END TaskTo, 
     (
         SELECT STUFF(
         (
             SELECT ' ' + OrganizationName + ''
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
     ) AS DocAuthorInfo, 
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
             SELECT DISTINCT 
                    af.AdrOrganizationId
             FROM DOCS_ADDRESSINFO af
             WHERE af.AdrDocId = d.DocId
                   AND af.AdrTypeId = 2
                   AND af.AdrAuthorId IS NULL
         )
     )
                ELSE af.FullName
            END AS WhomAdressed, 
            drf.ReceivedFormId DocFormId, 
            tt.TopicTypeName AS DocTopicType, 
            tt.TopicTypeId AS DocTopicTypeId, 
            df.FormId AS FormId, 
            d.DocDocdate AS DocDate, 
            d.DocDescription,
            CASE
                WHEN dr.DirectionCreatorWorkplaceId = e.ExecutorWorkplaceId
                THEN CONVERT(BIT, 1)
                ELSE e.ExecutorControlStatus
            END ExecutorControlStatus, 
            e.ExecutorWorkplaceId, 
            d.DocPeriodId, 
            dr.DirectionConfirmed, 
            e.SendStatusId, 
            af.AdrTypeId, 
            d.DocReceivedFormId, 
            d.DocFormId AS DocForm, 
            dr.DirectionInsertedDate, 
            e.ExecutorReadStatus, 
            d.DocIsAppealBoard, 
            ddp.PositionGroupId, 
            ds.DocumentstatusId, 
            dr.DirectionSendStatus, 
            e.ExecutorOrganizationId, 
            d.DocOrganizationId, 
            e.ExecutionstatusId, 
            (dbo.fnGetPersonnelbyWorkPlaceId
     (
     (
         SELECT de.ExecutorWorkplaceId
         FROM dbo.DOCS_EXECUTOR de
         WHERE de.ExecutorDocId = d.DocId
               AND de.DirectionTypeId=4
     ), 106
     )) AS CreaterPersonnelName
     FROM dbo.VW_DOC_INFO AS d
          JOIN dbo.DOCS_DIRECTIONS dr ON d.DocId = dr.DirectionDocId
          JOIN dbo.DOCS_EXECUTOR e ON dr.DirectionId = e.ExecutorDirectionId
          JOIN dbo.DC_WORKPLACE dw ON e.ExecutorWorkplaceId = dw.WorkplaceId
          JOIN dbo.DC_DEPARTMENT_POSITION ddp ON dw.WorkplaceDepartmentPositionId = ddp.DepartmentPositionId
          JOIN dbo.DOC_FORM df ON df.FormId =CASE WHEN  d.DocFormId IS NULL THEN 59 ELSE d.DocFormId end
          JOIN dbo.DOC_RECEIVED_FORM drf ON d.DocReceivedFormId = drf.ReceivedFormId
          JOIN dbo.DOC_DOCUMENTSTATUS ds ON ds.DocumentstatusId = d.DocDocumentstatusId
          JOIN dbo.DOCS_ADDRESSINFO af ON af.AdrDocId = d.DocId
                                          AND af.AdrTypeId IN(2, 3)
          JOIN dbo.DOC_FORM form ON form.FormId = d.DocReceivedFormId
          JOIN dbo.DOC_TOPIC_TYPE tt ON tt.TopicTypeId = d.DocTopicType
     WHERE d.DocDoctypeId = 1
           AND (e.SendStatusId IS NULL
                OR ISNULL(e.ExecutionstatusId, 0) <> 1)
           AND (ISNULL(dr.DirectionConfirmed, 0) = 1
                OR (e.SendStatusId IN(5, 15)
           AND dr.DirectionSendStatus = 1))--kamran-derkenar ucun
          AND (e.SendStatusId IS NULL
               OR e.SendStatusId <> 14)--Nurlan(icraci geri qaytaranda gridde gorsenmemesi ucun)
          AND d.DocIsAppealBoard = (CASE
                                        WHEN ddp.PositionGroupId IN(37, 38)
                                        THEN 1
                                        ELSE d.DocIsAppealBoard
                                    END);

