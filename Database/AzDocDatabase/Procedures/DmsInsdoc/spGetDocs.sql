
/*
Migrated by Kamran A-eff 23.08.2019
*/
/*
Migrated by Kamran A-eff 06.08.2019
*/
/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [dms_insdoc].[spGetDocs] @workPlaceId         INT, 
                                         @periodId            INT           = NULL, 
                                         @docTypeId           INT, 
                                         @pageIndex           INT           = 1, 
                                         @pageSize            INT           = 20, 
                                         @totalCount          INT OUT,
                                         ---for searching
                                         @docenterno          NVARCHAR(50)  = NULL, 
                                         @docdocno            NVARCHAR(50)  = NULL, 
                                         @docenterdate        DATETIME      = NULL, 
                                         @docdocumentstatusid INT           = NULL, 
                                         @formid              NVARCHAR(MAX) = NULL
AS
    BEGIN
        IF(@periodId IS NULL)
            BEGIN
                SELECT @periodId =
                (
                    SELECT MAX(p.PeriodId)
                    FROM DOC_PERIOD p
                );
        END;
        SELECT d.DocId, 
               d.DocEnterno, 
               d.DocEnterdate, 
               d.DocDocno, 
               dbo.GET_ADDRESSINFO(d.DocId, 1, 1) AS Signer, 
             ( CASE WHEN d.DocDocumentstatusId in (1,16,36,37) then
			   STUFF(
        (
            SELECT '; ' + s.SendStatusName + ':' + STUFF(
            (
                SELECT ', ' + dbo.fnGetPersonnelbyWorkPlaceId(t.WhomAddressId, 106)
                FROM dbo.DOC_TASK t
                WHERE t.TaskDocId = d.DocId
                      AND t.TypeOfAssignmentId = s.SendStatusId FOR XML PATH('')
            ), 1, 1, '')
            FROM dbo.DOC_SENDSTATUS s
            ORDER BY 1 FOR XML PATH('')
        ), 1, 2, '') END )AS SendTo, 
               d.DocDocumentstatusId, 
               df.FormId, 
               d.DocDescription,
               CASE
                   WHEN dr.DirectionCreatorWorkplaceId = @workPlaceId
                   THEN CONVERT(BIT, 1)
                   ELSE e.ExecutorControlStatus
               END ExecutorControlStatus
        FROM VW_DOC_INFO AS d
             JOIN dbo.DOCS_DIRECTIONS dr ON d.DocId = dr.DirectionDocId
             JOIN dbo.DOCS_EXECUTOR e ON dr.DirectionId = e.ExecutorDirectionId
             JOIN dbo.DOC_DOCUMENTSTATUS ds ON ds.DocumentstatusId = d.DocDocumentstatusId
             JOIN dbo.DOC_FORM df ON df.FormId = d.DocFormId
        WHERE d.DocDoctypeId = @docTypeId
              AND e.ExecutorWorkplaceId = @workPlaceId
              AND d.DocPeriodId = @periodId
              AND ISNULL(dr.DirectionConfirmed, 0) <> 0
              AND ((@docenterno IS NULL
                    OR d.DocEnterno LIKE '%' + @docenterno + '%')
                   AND (@docdocno IS NULL
                        OR d.DocDocno LIKE '%' + @docdocno + '%')
                   AND (@docenterdate IS NULL
                        OR d.DocEnterdate = @docenterdate)
                   AND (@formid IS NULL
                        OR d.DocFormId IN
        (
            SELECT [value]
            FROM STRING_SPLIT(@formid, ',')
        )))
        ORDER BY e.ExecutorReadStatus, 
                 dr.DirectionInsertedDate DESC
        OFFSET @pageSize * (@pageIndex - 1) ROWS FETCH NEXT @pageSize ROWS ONLY;
        SELECT @totalCount = COUNT(0)
        FROM VW_DOC_INFO AS d
             JOIN dbo.DOCS_DIRECTIONS dr ON d.DocId = dr.DirectionDocId
             JOIN dbo.DOCS_EXECUTOR e ON dr.DirectionId = e.ExecutorDirectionId
             JOIN dbo.DOC_DOCUMENTSTATUS ds ON ds.DocumentstatusId = d.DocDocumentstatusId
             JOIN dbo.DOC_FORM df ON df.FormId = d.DocFormId
        WHERE d.DocDoctypeId = @docTypeId
              AND e.ExecutorWorkplaceId = @workPlaceId
              AND d.DocPeriodId = @periodId
              AND ISNULL(dr.DirectionConfirmed, 0) <> 0
              AND ((@docenterno IS NULL
                    OR d.DocEnterno LIKE '%' + @docenterno + '%')
                   AND (@docdocno IS NULL
                        OR d.DocDocno LIKE '%' + @docdocno + '%')
                   AND (@docenterdate IS NULL
                        OR d.DocEnterdate = @docenterdate)
                   AND (@docdocumentstatusid IS NULL
                        OR d.DocDocumentstatusId IN(@docdocumentstatusid))
        AND (@formid IS NULL
             OR d.DocFormId IN
        (
            SELECT [value]
            FROM STRING_SPLIT(@formid, ',')
        )));
        --and  dr.DirectionTypeId=e.DirectionTypeId

    END;
