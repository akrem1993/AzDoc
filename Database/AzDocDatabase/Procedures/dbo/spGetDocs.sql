
/*
Migrated by Kamran A-eff 23.08.2019
*/
/*
Migrated by Kamran A-eff 06.08.2019
*/
/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [dbo].[spGetDocs] @workPlaceId          INT, 
                                  @periodId             INT           = NULL, 
                                  @sendStatusId         INT           = NULL, 
                                  @docTypeId            INT, 
                                  @pageIndex            INT           = 1, 
                                  @pageSize             INT           = 20, 
                                  @totalCount           INT OUT,
                                  ---for searching
                                  @docenterno           NVARCHAR(50)  = NULL, 
                                  @docdocno             NVARCHAR(50)  = NULL, 
                                  @docenterdate         DATETIME      = NULL, 
                                  @sendto               NVARCHAR(MAX) = NULL, 
                                  @documentstatusname   NVARCHAR(MAX) = NULL, 
                                  @executerule          NVARCHAR(MAX) = NULL, 
                                  @createrpersonnelname NVARCHAR(MAX) = NULL, 
                                  @docdocdate           DATETIME      = NULL, 
                                  @signer               NVARCHAR(MAX) = NULL, 
                                  @docauthorinfo        NVARCHAR(MAX) = NULL, 
                                  @whomfrominfo         NVARCHAR(MAX) = NULL, 
                                  @entryfromwhere       NVARCHAR(MAX) = NULL, 
                                  @docdescription       NVARCHAR(MAX) = NULL
AS
     SET NOCOUNT ON;
     SET ANSI_NULLS OFF;
    BEGIN
        DECLARE @organizationId INT;
        DECLARE @UnreadDocuments TABLE
        (DocId                 INT, 
         DocDoctypeId          INT, 
         DocEnterno            NVARCHAR(MAX), 
         DocEnterdate          DATE NULL, 
         DocDocno              NVARCHAR(MAX), 
         DocDocdate            DATE NULL, 
         DocPlannedDate        DATE NULL, 
         Signer                NVARCHAR(MAX), 
         DocAuthorInfo         NVARCHAR(MAX), 
         WhomFromInfo          NVARCHAR(MAX), 
         SendTo                NVARCHAR(MAX), 
         EntryFromWhere        NVARCHAR(MAX), 
         ExecuteRule           NVARCHAR(MAX), 
         ReceivedFormName      NVARCHAR(MAX), 
         DocDescription        NVARCHAR(MAX), 
         DocumentstatusName    NVARCHAR(MAX), 
         CreaterPersonnelName  NVARCHAR(MAX), 
         ExecutorControlStatus BIT, 
         SendStatusId          INT NULL, 
         DirectionInsertedDate DATETIME NULL, 
         ReadStatus            INT NULL,
		 DirectionTypeId int null
        );
        IF(@periodId IS NULL)
            BEGIN
                SELECT @periodId = MAX(p.PeriodId)
                FROM DOC_PERIOD p;
        END;
        IF EXISTS -- Shahriyar elave etdi
        (
            SELECT de.ExecutorDocId, 
                   de.ExecutorWorkplaceId, 
                   COUNT(de.ExecutorReadStatus) AS coutReadStatus
            FROM dbo.DOCS d
                 JOIN dbo.DOCS_EXECUTOR de ON d.DocId = de.ExecutorDocId
            WHERE d.DocPeriodId = @periodId
                  AND de.ExecutorReadStatus = 0
            GROUP BY de.ExecutorDocId, 
                     de.ExecutorWorkplaceId
            HAVING de.ExecutorWorkplaceId = @workPlaceId
                   AND COUNT(de.ExecutorReadStatus) > 1
        )
            BEGIN
                UPDATE dbo.DOCS_EXECUTOR
                  SET 
                      dbo.DOCS_EXECUTOR.ExecutorReadStatus = 1, -- bit

                      dbo.DOCS_EXECUTOR.ExecutorControlStatus = 1
                WHERE dbo.DOCS_EXECUTOR.ExecutorId IN
                (
                    SELECT de.ExecutorId
                    FROM dbo.DOCS_EXECUTOR de
                    WHERE de.ExecutorDocId IN
                    (
                        SELECT s.ExecutorDocId
                        FROM
                        (
                            SELECT de.ExecutorDocId, 
                                   de.ExecutorWorkplaceId, 
                                   COUNT(de.ExecutorReadStatus) AS coutReadStatus
                            FROM dbo.DOCS d
                                 JOIN dbo.DOCS_EXECUTOR de ON d.DocId = de.ExecutorDocId
                            WHERE d.DocPeriodId = @periodId
                                  AND de.ExecutorReadStatus = 0
                            GROUP BY de.ExecutorDocId, 
                                     de.ExecutorWorkplaceId
                            HAVING de.ExecutorWorkplaceId = @workPlaceId
                                   AND COUNT(de.ExecutorReadStatus) > 1
                        ) s
                    )
                        AND de.ExecutorReadStatus = 0
                        AND de.ExecutorId NOT IN
                    (
                        SELECT s1.maxExecutorId
                        FROM
                        (
                            SELECT de.ExecutorWorkplaceId, 
                                   MAX(de.ExecutorId) AS maxExecutorId
                            FROM dbo.DOCS_EXECUTOR de
                            WHERE de.ExecutorDocId IN
                            (
                                SELECT s.ExecutorDocId
                                FROM
                                (
                                    SELECT de.ExecutorDocId, 
                                           de.ExecutorWorkplaceId, 
                                           COUNT(de.ExecutorReadStatus) AS coutReadStatus
                                    FROM dbo.DOCS d
                                         JOIN dbo.DOCS_EXECUTOR de ON d.DocId = de.ExecutorDocId
                                    WHERE d.DocPeriodId = @periodId
                                          AND de.ExecutorReadStatus = 0
                                    GROUP BY de.ExecutorDocId, 
                                             de.ExecutorWorkplaceId
                                    HAVING de.ExecutorWorkplaceId = @workPlaceId
                                           AND COUNT(de.ExecutorReadStatus) > 1
                                ) s
                            )
                                AND de.ExecutorReadStatus = 0
                            GROUP BY de.ExecutorWorkplaceId
                        ) s1
                    )
                );
        END;
        SELECT @organizationId = dw.WorkplaceOrganizationId
        FROM dbo.DC_WORKPLACE dw
        WHERE dw.WorkplaceId = @workPlaceId;
        INSERT INTO @UnreadDocuments
        (DocId, 
         DocDoctypeId, 
         DocEnterno, 
         DocEnterdate, 
         DocDocno, 
         DocDocdate, 
         DocPlannedDate, 
         Signer, 
         DocAuthorInfo, 
         WhomFromInfo, 
         SendTo, 
         EntryFromWhere, 
         ExecuteRule, 
         ReceivedFormName, 
         DocDescription, 
         DocumentstatusName, 
         CreaterPersonnelName, 
         ExecutorControlStatus, 
         SendStatusId, 
         DirectionInsertedDate,
		 DirectionTypeId
        )
               SELECT d.DocId, 
                      d.DocDoctypeId, 
                      d.DocEnterno, 
                      d.DocEnterdate, 
                      d.DocDocno, 
                      d.DocDocdate, 
                      d.DocPlannedDate,
                      CASE
                          WHEN d.DocDoctypeId IN(1)
                          THEN
               (
                   SELECT da.FullName
                   FROM dbo.DOCS_ADDRESSINFO da
                   WHERE da.AdrDocId = d.DocId
                         AND da.AdrTypeId = 1
               )
                          ELSE ''
                      END AS Signer, 
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
               ) AS DocAuthorInfo, --Hardan daxil olub 
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
               ) AS WhomFromInfo, --Kimdən daxil olub
                      CASE
                          WHEN d.DocDoctypeId IN(1, 2, 18)
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
                          AND e.ExecutionstatusId IS null
                          FOR XML PATH('')
                          
                ), 1, 1, '') + '; '
                FROM dbo.DOC_SENDSTATUS s
                ORDER BY 1 FOR XML PATH('')
        ) end AS SendTo, 
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
               ) AS EntryFromWhere, -- haradan daxil olub
                      CASE
                          WHEN dr.DirectionTypeId IN(1, 6, 17, 12, 18)
                          THEN ds2.SendStatusName
                          ELSE dd.DirectionTypeName
                      END AS ExecuteRule, 
                      drf.ReceivedFormName, 
                      d.DocDescription, 
                      ds.DocumentstatusName,
                      CASE
                          WHEN dr.DirectionCreatorWorkplaceId = dr.DirectionWorkplaceId
                          THEN(dbo.fnGetPersonnelbyWorkPlaceId(dr.DirectionCreatorWorkplaceId, 106))
                          WHEN e.SendStatusId IN(6, 10)
                          THEN(dbo.fnGetPersonnelbyWorkPlaceId
               (
               (
                   SELECT de.ExecutorWorkplaceId
                   FROM dbo.DOCS_EXECUTOR de
                   WHERE de.ExecutorDirectionId = dr.DirectionId
                         AND de.ExecutorMain = 1
                         AND de.SendStatusId = 1
               ), 106
               ))
                          ELSE(dbo.fnGetPersonnelbyWorkPlaceId(dr.DirectionWorkplaceId, 106))
                      END AS CreaterPersonnelName,
                      CASE
                          WHEN dr.DirectionCreatorWorkplaceId = @workPlaceId
                          THEN CONVERT(BIT, 1)
                          ELSE e.ExecutorControlStatus
                      END ExecutorControlStatus, 
                      e.SendStatusId, 
                      dr.DirectionInsertedDate,
					  e.DirectionTypeId
               FROM VW_DOC_INFO AS d
                    LEFT JOIN dbo.DOCS_DIRECTIONS dr ON d.DocId = dr.DirectionDocId
                    LEFT JOIN dbo.DOCS_EXECUTOR e ON dr.DirectionId = e.ExecutorDirectionId
                    LEFT JOIN dbo.DOC_DOCUMENTSTATUS ds ON ds.DocumentstatusId = d.DocDocumentstatusId
                    LEFT JOIN dbo.DOC_RECEIVED_FORM drf ON d.DocReceivedFormId = drf.ReceivedFormId
                    LEFT JOIN dbo.DOC_DIRECTIONTYPE dd ON dr.DirectionTypeId = dd.DirectionTypeId
                    LEFT JOIN dbo.DOC_SENDSTATUS ds2 ON e.SendStatusId = ds2.SendStatusId
               WHERE e.ExecutorWorkplaceId = @workPlaceId
                     AND e.ExecutorReadStatus = 0

                     --AND d.DocOrganizationId = @organizationId
                     AND dr.DirectionTypeId <> 4
                     AND (
               (
                   SELECT CASE
                              WHEN e.DirectionTypeId IN(12, 13)
                              THEN 1
                              ELSE ISNULL(dr.DirectionConfirmed, 1)
                          END
               ) = 1);
        IF(@sendStatusId > 0 )
            BEGIN
				if(@sendStatusId<>16)
				begin
                SELECT ud.DocId, 
                       ud.DocDoctypeId, 
                       ud.DocEnterno, 
                       ud.DocEnterdate, 
                       ud.DocDocno, 
                       ud.DocDocdate, 
                       ud.DocPlannedDate, 
                       ud.Signer, 
                       ud.SendTo, 
                       ud.EntryFromWhere, 
                       ud.ExecuteRule, 
                       ud.ReceivedFormName, 
                       ud.DocDescription, 
                       ud.DocumentstatusName, 
                       ud.CreaterPersonnelName, 
                       ud.ExecutorControlStatus
                FROM @UnreadDocuments ud
                WHERE ud.SendStatusId = CASE
                                            WHEN @sendStatusId > 0
                                            THEN @sendStatusId											
                                            ELSE ud.SendStatusId
                                        END

                      AND ((@docenterno IS NULL
                            OR ud.DocEnterno LIKE N'%' + @docenterno + '%')
                           AND (@docdocno IS NULL
                                OR ud.DocDocno LIKE N'%' + @docdocno + '%')
                           AND (@docenterdate IS NULL
                                OR ud.DocEnterdate = @docenterdate)
                           AND (@sendto IS NULL
                                OR ud.SendTo LIKE N'%' + @sendto + '%')
                           AND (@executerule IS NULL
                                OR ud.ExecuteRule LIKE '%' + @executerule + '%')
                           AND (@createrpersonnelname IS NULL
                                OR ud.CreaterPersonnelName LIKE '%' + @createrpersonnelname + '%')
                           AND (@docdocdate IS NULL
                                OR ud.DocDocdate = @docdocdate)
                           AND (@signer IS NULL
                                OR ud.Signer LIKE '%' + @signer + '%')
                           AND (@docauthorinfo IS NULL
                                OR ud.DocAuthorInfo LIKE '%' + @docauthorinfo + '%')
                           AND (@whomfrominfo IS NULL
                                OR ud.WhomFromInfo LIKE N'%' + @whomfrominfo + '%')
                           AND (@entryfromwhere IS NULL
                                OR ud.EntryFromWhere LIKE N'%' + @entryfromwhere + '%')
                           AND (@docdescription IS NULL
                                OR ud.DocDescription LIKE N'%' + @docdescription + '%'))
                ORDER BY ud.DirectionInsertedDate DESC
                OFFSET @pageSize * (@pageIndex - 1) ROWS FETCH NEXT @pageSize ROWS ONLY;
                SELECT @totalCount = COUNT(0)
                FROM @UnreadDocuments ud
                WHERE ud.SendStatusId = CASE
                                            WHEN @sendStatusId > 0
                                            THEN @sendStatusId
                                            ELSE ud.SendStatusId
                                        END
                      AND ((@docenterno IS NULL
                            OR ud.DocEnterno LIKE N'%' + @docenterno + '%')
                           AND (@docdocno IS NULL
                                OR ud.DocDocno LIKE N'%' + @docdocno + '%')
                           AND (@docenterdate IS NULL
                                OR ud.DocEnterdate = @docenterdate)
                           AND (@sendto IS NULL
                                OR ud.SendTo LIKE N'%' + @sendto + '%')
                           AND (@executerule IS NULL
                                OR ud.ExecuteRule LIKE '%' + @executerule + '%')
                           AND (@createrpersonnelname IS NULL
                                OR ud.CreaterPersonnelName LIKE '%' + @createrpersonnelname + '%')
                           AND (@docdocdate IS NULL
                                OR ud.DocDocdate = @docdocdate)
                           AND (@signer IS NULL
                                OR ud.Signer LIKE '%' + @signer + '%')
                           AND (@docauthorinfo IS NULL
                                OR ud.DocAuthorInfo LIKE N'%' + @docauthorinfo + '%')
                           AND (@whomfrominfo IS NULL
                                OR ud.WhomFromInfo LIKE N'%' + @whomfrominfo + '%')
                           AND (@entryfromwhere IS NULL
                                OR ud.EntryFromWhere LIKE N'%' + @entryfromwhere + '%')
                           AND (@docdescription IS NULL
                                OR ud.DocDescription LIKE N'%' + @docdescription + '%'));
				END
				ELSE
				BEGIN
					SELECT ud.DocId, 
                       ud.DocDoctypeId, 
                       ud.DocEnterno, 
                       ud.DocEnterdate, 
                       ud.DocDocno, 
                       ud.DocDocdate, 
                       ud.DocPlannedDate, 
                       ud.Signer, 
                       ud.SendTo, 
                       ud.EntryFromWhere, 
                       ud.ExecuteRule, 
                       ud.ReceivedFormName, 
                       ud.DocDescription, 
                       ud.DocumentstatusName, 
                       ud.CreaterPersonnelName, 
                       ud.ExecutorControlStatus
                FROM @UnreadDocuments ud
                WHERE ud.DirectionTypeId =11

                      AND ((@docenterno IS NULL
                            OR ud.DocEnterno LIKE N'%' + @docenterno + '%')
                           AND (@docdocno IS NULL
                                OR ud.DocDocno LIKE N'%' + @docdocno + '%')
                           AND (@docenterdate IS NULL
                                OR ud.DocEnterdate = @docenterdate)
                           AND (@sendto IS NULL
                                OR ud.SendTo LIKE N'%' + @sendto + '%')
                           AND (@executerule IS NULL
                                OR ud.ExecuteRule LIKE '%' + @executerule + '%')
                           AND (@createrpersonnelname IS NULL
                                OR ud.CreaterPersonnelName LIKE '%' + @createrpersonnelname + '%')
                           AND (@docdocdate IS NULL
                                OR ud.DocDocdate = @docdocdate)
                           AND (@signer IS NULL
                                OR ud.Signer LIKE '%' + @signer + '%')
                           AND (@docauthorinfo IS NULL
                                OR ud.DocAuthorInfo LIKE '%' + @docauthorinfo + '%')
                           AND (@whomfrominfo IS NULL
                                OR ud.WhomFromInfo LIKE N'%' + @whomfrominfo + '%')
                           AND (@entryfromwhere IS NULL
                                OR ud.EntryFromWhere LIKE N'%' + @entryfromwhere + '%')
                           AND (@docdescription IS NULL
                                OR ud.DocDescription LIKE N'%' + @docdescription + '%'))
                ORDER BY ud.DirectionInsertedDate DESC
                OFFSET @pageSize * (@pageIndex - 1) ROWS FETCH NEXT @pageSize ROWS ONLY;
                SELECT @totalCount = COUNT(0)
                FROM @UnreadDocuments ud
                WHERE ud.DirectionTypeId =11
                      AND ((@docenterno IS NULL
                            OR ud.DocEnterno LIKE N'%' + @docenterno + '%')
                           AND (@docdocno IS NULL
                                OR ud.DocDocno LIKE N'%' + @docdocno + '%')
                           AND (@docenterdate IS NULL
                                OR ud.DocEnterdate = @docenterdate)
                           AND (@sendto IS NULL
                                OR ud.SendTo LIKE N'%' + @sendto + '%')
                           AND (@executerule IS NULL
                                OR ud.ExecuteRule LIKE '%' + @executerule + '%')
                           AND (@createrpersonnelname IS NULL
                                OR ud.CreaterPersonnelName LIKE '%' + @createrpersonnelname + '%')
                           AND (@docdocdate IS NULL
                                OR ud.DocDocdate = @docdocdate)
                           AND (@signer IS NULL
                                OR ud.Signer LIKE '%' + @signer + '%')
                           AND (@docauthorinfo IS NULL
                                OR ud.DocAuthorInfo LIKE N'%' + @docauthorinfo + '%')
                           AND (@whomfrominfo IS NULL
                                OR ud.WhomFromInfo LIKE N'%' + @whomfrominfo + '%')
                           AND (@entryfromwhere IS NULL
                                OR ud.EntryFromWhere LIKE N'%' + @entryfromwhere + '%')
                           AND (@docdescription IS NULL
                                OR ud.DocDescription LIKE N'%' + @docdescription + '%'));
				end
        END;
            ELSE
            BEGIN
                SELECT ud.DocId, 
                       ud.DocDoctypeId, 
                       ud.DocEnterno, 
                       ud.DocEnterdate, 
                       ud.DocDocno, 
                       ud.DocDocdate, 
                       ud.DocPlannedDate, 
                       ud.Signer, 
                       ud.SendTo, 
                       ud.EntryFromWhere, 
                       ud.ExecuteRule, 
                       ud.ReceivedFormName, 
                       ud.DocDescription, 
                       ud.DocumentstatusName, 
                       ud.CreaterPersonnelName, 
                       ud.ExecutorControlStatus
                FROM @UnreadDocuments ud
                WHERE(@docenterno IS NULL
                      OR ud.DocEnterno LIKE N'%' + @docenterno + '%')
                     AND (@docdocno IS NULL
                          OR ud.DocDocno LIKE N'%' + @docdocno + '%')
                     AND (@docenterdate IS NULL
                          OR ud.DocEnterdate = @docenterdate)
                     AND (@sendto IS NULL
                          OR ud.SendTo LIKE N'%' + @sendto + '%')
                     AND (@executerule IS NULL
                          OR ud.ExecuteRule LIKE '%' + @executerule + '%')
                     AND (@createrpersonnelname IS NULL
                          OR ud.CreaterPersonnelName LIKE N'%' + @createrpersonnelname + '%')
                     AND (@docdocdate IS NULL
                          OR ud.DocDocdate = @docdocdate)
                     AND (@signer IS NULL
                          OR ud.Signer LIKE '%' + @signer + '%')
                     AND (@docauthorinfo IS NULL
                          OR ud.DocAuthorInfo LIKE N'%' + @docauthorinfo + '%')
                     AND (@whomfrominfo IS NULL
                          OR ud.WhomFromInfo LIKE N'%' + @whomfrominfo + '%')
                     AND (@entryfromwhere IS NULL
                          OR ud.EntryFromWhere LIKE N'%' + @entryfromwhere + '%')
                     AND (@docdescription IS NULL
                          OR ud.DocDescription LIKE N'%' + @docdescription + '%')
                ORDER BY ud.DirectionInsertedDate DESC
                OFFSET @pageSize * (@pageIndex - 1) ROWS FETCH NEXT @pageSize ROWS ONLY;
                SELECT @totalCount = COUNT(0)
                FROM @UnreadDocuments ud
                WHERE(@docenterno IS NULL
                      OR ud.DocEnterno LIKE N'%' + @docenterno + '%')
                     AND (@docdocno IS NULL
                          OR ud.DocDocno LIKE N'%' + @docdocno + '%')
                     AND (@docenterdate IS NULL
                          OR ud.DocEnterdate = @docenterdate)
                     AND (@sendto IS NULL
                          OR ud.SendTo LIKE N'%' + @sendto + '%')
                     AND (@executerule IS NULL
                          OR ud.ExecuteRule LIKE '%' + @executerule + '%')
                     AND (@createrpersonnelname IS NULL
                          OR ud.CreaterPersonnelName LIKE N'%' + @createrpersonnelname + '%')
                     AND (@docdocdate IS NULL
                          OR ud.DocDocdate = @docdocdate)
                     AND (@signer IS NULL
                          OR ud.Signer LIKE '%' + @signer + '%')
                     AND (@docauthorinfo IS NULL
                          OR ud.DocAuthorInfo LIKE N'%' + @docauthorinfo + '%')
                     AND (@whomfrominfo IS NULL
                          OR ud.WhomFromInfo LIKE N'%' + @whomfrominfo + '%')
                     AND (@entryfromwhere IS NULL
                          OR ud.EntryFromWhere LIKE N'%' + @entryfromwhere + '%')
                     AND (@docdescription IS NULL
                          OR ud.DocDescription LIKE N'%' + @docdescription + '%');
        END;
    END;
