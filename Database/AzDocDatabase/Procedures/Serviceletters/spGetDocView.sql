
/*
Migrated by Kamran A-eff 23.08.2019
*/
/*
Migrated by Kamran A-eff 06.08.2019
*/
/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [serviceletters].[spGetDocView] @docId       INT, 
                                                @docType     INT = 18, 
                                                @workPlaceId INT

AS
    BEGIN
        IF NOT EXISTS
        (
            SELECT d.DocId
            FROM dbo.VW_DOC_INFO d
            WHERE d.DocId = @docId
        )
            THROW 56000, 'Mövcud sənəd tapılmadı', 1;
        DECLARE @executorCount INT;
        SELECT @executorCount = COUNT(0)
        FROM dbo.DOCS_EXECUTOR e
        WHERE e.ExecutorDocId = @docId
              AND e.ExecutorWorkplaceId = @workPlaceId
              AND e.DirectionTypeId = 18;
        DECLARE @OperationHistory TABLE
        (PersonFrom             NVARCHAR(MAX), 
         PersonTo               NVARCHAR(MAX), 
         ExecutorMain           NVARCHAR(MAX), 
         DirectionDate          DATETIME, 
         STATUS                 NVARCHAR(MAX), 
         StatusDate             DATETIME, 
         ExecutorResolutionNote NVARCHAR(MAX), 
         SendStatusId           INT
        );
        EXEC sp_set_session_context 
             'docId', 
             @docId;
        IF EXISTS --Yeni sened olduqda
        (
            SELECT dol.DocId
            FROM dbo.DocOperationsLog dol
            WHERE dol.DocId = @docId
                  AND dol.DirectionTypeId = 4
        )
            BEGIN
                INSERT INTO @OperationHistory
                (PersonFrom, 
                 PersonTo, 
                 ExecutorMain, 
                 DirectionDate, 
                 STATUS, 
                 StatusDate, 
                 ExecutorResolutionNote, 
                 SendStatusId
                )
                       SELECT dbo.fnGetPersonnelbyWorkPlaceId(dol.SenderWorkPlaceId, 106) AS PersonFrom, 
                              dbo.fnGetPersonnelbyWorkPlaceId(dol.ReceiverWorkPlaceId, 106) AS PersonTo, 
                              dot.TypeName AS ExecutorMain, 
                              dol.OperationDate AS DirectionDate, 
                              dos.StatusName AS STATUS, 
                              dol.OperationStatusDate AS StatusDate, 
                              dol.OperationNote AS ExecutorResolutionNote,
                              CASE
                                  WHEN de.ExecutionstatusId IS NULL
                                  THEN dol.OperationTypeId
                                  ELSE 0
                              END AS SendStatusId
                       FROM dbo.DocOperationsLog dol
                            LEFT JOIN dbo.DocOperationStatus dos ON dol.OperationStatus = dos.StatusId
                            JOIN dbo.DocOperationTypes dot ON dot.TypeId = dol.OperationTypeId
                            LEFT JOIN dbo.DOCS_EXECUTOR de ON dol.ExecutorId = de.ExecutorId
                       WHERE dol.DocId = @docId
                             AND dol.IsDeleted IS NULL;
        END;
            ELSE--KOhne sened olduqda
            BEGIN
                IF EXISTS
                (
                    SELECT dol.DocId
                    FROM dbo.DocOperationsLog dol
                    WHERE dol.DocId = @docId
                )
                    BEGIN
                        INSERT INTO @OperationHistory
                        (PersonFrom, 
                         PersonTo, 
                         ExecutorMain, 
                         DirectionDate, 
                         STATUS, 
                         StatusDate, 
                         ExecutorResolutionNote, 
                         SendStatusId
                        )
                               SELECT oh.PersonFrom, 
                                      oh.PersonTo, 
                                      oh.ExecutorMain, 
                                      oh.DirectionDate, 
                                      oh.STATUS, 
                                      oh.StatusDate, 
                                      oh.ExecutorResolutionNote, 
                                      oh.SendStatusId
                               FROM
                               (
                                   SELECT vdol.*
                                   FROM dbo.VW_DOC_OLD_LASTNEW vdol
                                   WHERE vdol.DocId = @docId
                               ) oh
                               UNION
                               SELECT dbo.fnGetPersonnelbyWorkPlaceId(dol.SenderWorkPlaceId, 106) AS PersonFrom, 
                                      dbo.fnGetPersonnelbyWorkPlaceId(dol.ReceiverWorkPlaceId, 106) AS PersonTo, 
                                      dot.TypeName AS ExecutorMain, 
                                      dol.OperationDate AS DirectionDate, 
                                      dos.StatusName AS STATUS, 
                                      dol.OperationStatusDate AS StatusDate, 
                                      dol.OperationNote AS ExecutorResolutionNote,
                                      CASE
                                          WHEN de.ExecutionstatusId IS NULL
                                          THEN dol.OperationTypeId
                                          ELSE 0
                                      END AS SendStatusId
                               --dol.ExecutorId,
                               --dol.DocId,
                               --dol.OperationFileId as OperationFileId
                               FROM dbo.DocOperationsLog dol
                                    LEFT JOIN dbo.DocOperationStatus dos ON dol.OperationStatus = dos.StatusId
                                    JOIN dbo.DocOperationTypes dot ON dot.TypeId = dol.OperationTypeId
                                    LEFT JOIN dbo.DOCS_EXECUTOR de ON dol.ExecutorId = de.ExecutorId
                               WHERE dol.DocId = @docId
                                     AND dol.IsDeleted IS NULL;
                END;
                    ELSE
                    BEGIN
                        INSERT INTO @OperationHistory
                        (PersonFrom, 
                         PersonTo, 
                         ExecutorMain, 
                         DirectionDate, 
                         STATUS, 
                         StatusDate, 
                         ExecutorResolutionNote, 
                         SendStatusId
                        )
                               SELECT oh.PersonFrom, 
                                      oh.PersonTo, 
                                      oh.ExecutorMain, 
                                      oh.DirectionDate, 
                                      oh.STATUS, 
                                      oh.StatusDate, 
                                      oh.ExecutorResolutionNote, 
                                      oh.SendStatusId
                               FROM
                               (
                                   SELECT vdv.*
                                   FROM dbo.VW_DOC_OLD_LAST vdv
                                   WHERE vdv.DocId = @docId
                               ) oh;
                END;
        END;

        ----------------------------Qeydiyyat nezaret vereqesi------------------------------------------------------
        DECLARE @signatoryPerson NVARCHAR(MAX), @confirmPerson NVARCHAR(MAX);
        SELECT @signatoryPerson = af.FullName
        FROM dbo.DOCS_ADDRESSINFO af
        WHERE af.AdrDocId = @docId
              AND af.AdrTypeId = 1;
        SELECT @confirmPerson = af.FullName
        FROM dbo.DOCS_ADDRESSINFO af
        WHERE af.AdrDocId = @docId
              AND af.AdrTypeId = 2;
        SELECT 
        -- Bashliq 
        (
            SELECT o.OrganizationName
            FROM dbo.DC_ORGANIZATION o
            WHERE o.OrganizationId = d.DocOrganizationId
        ) AS OrgName, 
        (
            SELECT a.Caption
            FROM dbo.AC_MENU a
            WHERE a.DocTypeId = d.DocDoctypeId
        ) AS DocTypeName,
        -- Qeydiyyat məlumatları--------------------------------------
        d.DocEnterno AS DocEnterNo, 
        d.DocEnterdate AS DocEnterDate, 
        @signatoryPerson AS SignatoryPerson, 
        @confirmPerson AS ConfirmPerson, 
        (
            SELECT s.SendStatusName + ' :' + STUFF(
            (
                SELECT ', ' +
                (
                    SELECT dbo.fnGetPersonnelbyWorkPlaceId(t.WhomAddressId, 106)
                )
                FROM dbo.DOC_TASK t
                WHERE t.TaskDocId = d.DocId
                      -- AND d.DocDocumentstatusId IN(1)
                      AND t.TypeOfAssignmentId = s.SendStatusId FOR XML PATH('')
            ), 1, 1, '')
            FROM dbo.DOC_SENDSTATUS s
            ORDER BY 1 FOR XML PATH('')
        --=======
        --      SELECT STUFF(
        --      (
        --         SELECT( ds.SendStatusName + ': ' + up.PersonnelName + ' ' + up.PersonnelSurname + '; ')
        --          FROM DOC_TASK t
        --               INNER JOIN DC_WORKPLACE w ON w.WorkplaceId = t.WhomAddressId
        --               INNER JOIN DC_USER u ON u.UserId = w.WorkplaceUserId
        --               INNER JOIN DC_PERSONNEL up ON u.UserPersonnelId = up.PersonnelId
        --LEFT JOIN dbo.DOC_SENDSTATUS ds ON t.TypeOfAssignmentId=ds.SendStatusId
        --          WHERE t.TaskDocId = @docId FOR XML PATH('')
        --      ), 1, 0, '')
        ) AS ToWhomAddress, 
        d.DocPlannedDate, 
        d.DocDocumentstatusId DocDocumentStatusId, 
        (CASE
             WHEN d.DocDocumentstatusId = 16
                  AND
        (
            SELECT dol.OperationStatus
            FROM dbo.DOCS_EXECUTOR de
                 LEFT JOIN dbo.DocOperationsLog dol ON de.ExecutorId = dol.ExecutorId
            WHERE de.ExecutorDocId = d.DocId
                  AND de.ExecutorReadStatus = 0
                  AND dol.OperationTypeId = 12
                  AND dol.OperationStatus = 5
        ) = 5
             THEN
        (
            SELECT dd.DocumentstatusName
            FROM dbo.DOC_DOCUMENTSTATUS dd
            WHERE dd.DocumentstatusId = 36
        )
             ELSE
        (
            SELECT dd.DocumentstatusName
            FROM dbo.DOC_DOCUMENTSTATUS dd
            WHERE dd.DocumentstatusId = d.DocDocumentstatusId
        )
         END) DocumentStatusName,
         ---------------------------------------------------------------
        d.DocDescription AS Description, --Sənədin qısa məzmunu
        d.DocResultId,

         --Tapşırıqlar------------------------------------

        (
            SELECT t.TaskId, 
                   t.TaskDocNo, 
            (
                SELECT s.SendStatusName
                FROM dbo.DOC_SENDSTATUS s
                WHERE s.SendStatusId = t.TypeOfAssignmentId
            ) TypeOfAssignment, 
                   t.TaskNo, 
                   t.TaskDecription Task, 
                   t.TaskCycleId TaskCycle, 
            (
                SELECT tc.TaskCycleName
                FROM dbo.DOC_TASK_CYCLE tc
                WHERE tc.TaskCycleId = t.TaskCycleId
                      AND tc.DocTypeId = @docType
            ) TaskCycleName, 
                   t.ExecutionPeriod, 
                   t.PeriodOfPerformance, 
                   t.OriginalExecutionDate, 
            (
                SELECT ISNULL(' ' + PE.PersonnelName, '') + ISNULL(' ' + PE.PersonnelSurname, '') + ISNULL(' ' + PE.PersonnelLastname, '')
                FROM dbo.DC_WORKPLACE WP
                     JOIN [dbo].DC_USER DU ON WP.WorkplaceUserId = DU.UserId
                     JOIN [dbo].DC_PERSONNEL PE ON DU.UserPersonnelId = PE.PersonnelId
                WHERE PE.PersonnelStatus = 1
                      AND WP.WorkplaceId = t.WhomAddressId
            ) WhomAddress
            FROM dbo.DOC_TASK t
            WHERE t.TaskDocId = @docId
                  AND t.WhomAddressId = CASE
                                            WHEN @executorCount > 0
                                            THEN @workPlaceId
                                            WHEN @executorCount = 0
                                            THEN t.WhomAddressId
                                        END FOR JSON AUTO
        ) AS JsonTask,

        -------------------------------------------------
        --Qoşma sənəd------------------------------------
        (
            SELECT fi.FileInfoId, 
                   fi.FileInfoName,
                   CASE f.FileIsMain
                                   WHEN 1
                                   THEN N'Əsas sənəd'
								   ELSE N'Qoşma sənəd'
                               END FileIsMain, 
                   fi.FileInfoCopiesCount, 
                   fi.FileInfoPageCount, 
                   fi.FileInfoInsertdate AS FileInfoDate
            FROM dbo.DOCS_FILE f
                 JOIN DOCS_FILEINFO fi ON f.FileInfoId = fi.FileInfoId
            WHERE f.FileDocId = @docId
                  AND f.IsDeleted = 0
                  --AND f.FileVisaStatus <> 3
                  AND f.IsReject <> 1
            ORDER BY f.FileIsMain DESC FOR JSON AUTO
        ) AS JsonFileInfo,
        ------------------------------------------------

        (
            SELECT *
            FROM
            (
                --SELECT r.RelatedDocumentId AS DocId, 
                --       d.DocEnterno, 
                --       d.DocEnterdate,
                --       CASE
                --           WHEN d.DocDoctypeId = 1
                --                OR d.DocDoctypeId = 2
                --           THEN(
                --(
                --    SELECT STUFF(
                --    (
                --        SELECT ' ' + OrganizationName
                --        FROM DC_ORGANIZATION o
                --        WHERE o.OrganizationId IN
                --        (
                --            SELECT af.AdrOrganizationId
                --            FROM DOCS_ADDRESSINFO af
                --            WHERE af.AdrDocId = r.RelatedDocumentId
                --                  AND af.AdrTypeId = 3
                --                  AND af.AdrAuthorId IS NOT NULL
                --        ) FOR XML PATH('')
                --    ), 1, 1, '')
                --) + ' , ' +
                --(
                --    SELECT STUFF(
                --    (
                --        SELECT(a.AuthorName + ' ' + a.AuthorSurname + ' ' + ISNULL(a.AuthorLastname, ''))
                --        FROM dbo.DOC_AUTHOR a
                --        WHERE a.AuthorId IN
                --        (
                --            SELECT af.AdrAuthorId
                --            FROM DOCS_ADDRESSINFO af
                --            WHERE af.AdrDocId = d.DocId
                --                  AND af.AdrTypeId = 3
                --                  AND af.AdrAuthorId IS NOT NULL
                --        ) FOR XML PATH('')
                --    ), 1, 0, '')
                --))
                --           WHEN d.DocDoctypeId = 18
                --           THEN
                --(
                --    SELECT af.FullName
                --    FROM dbo.DOCS_ADDRESSINFO af
                --    WHERE af.AdrDocId = @docId
                --          AND af.AdrTypeId = 1
                --)
                --       END AS DocumentInfo, 
                --       d.DocDescription
                --FROM dbo.DOCS d
                --     LEFT JOIN dbo.DOCS_RELATED r ON d.DocId = r.RelatedDocumentId
                --     LEFT JOIN dbo.DC_ORGANIZATION do ON d.DocOrganizationId = do.OrganizationId
                --     LEFT JOIN dbo.DOCS_APPLICATION da ON d.DocId = da.AppDocId
                --WHERE r.RelatedDocId = @docId
                --      AND r.RelatedTypeId = 1

                SELECT DISTINCT d.DocId,
                       CASE
                           WHEN d.DocEnterno IS NOT NULL
                           THEN d.DocEnterno
                           ELSE d.DocDocno
                       END DocEnterno,
                       CASE
                           WHEN d.DocEnterdate IS NOT NULL
                           THEN d.DocEnterdate
                           ELSE d.DocDocdate
                       END DocEnterdate,
                       CASE
                           WHEN d.DocDoctypeId IN(1, 2, 12)
                           THEN
                (
                    SELECT STUFF(
                    (
                        SELECT ' ' + OrganizationName + ','
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
                )
                           ELSE do.OrganizationName
                       END AS DocumentInfo, 
                       d.DocDescription, 
                       dr.ResultName, 
                       dd.DocumentstatusName
                FROM dbo.VW_DOC_INFO d
                     LEFT JOIN dbo.DOC_RESULT dr ON d.DocResultId = dr.Id
                     LEFT JOIN dbo.DOC_DOCUMENTSTATUS dd ON d.DocDocumentstatusId = dd.DocumentstatusId
                     LEFT JOIN dbo.DOCS_ADDRESSINFO da ON da.AdrDocId = d.DocId
                                                          AND da.AdrTypeId = 3
                     LEFT JOIN dbo.DC_ORGANIZATION do ON da.AdrOrganizationId = do.OrganizationId
                WHERE d.DocId  IN
                (
                (
                    SELECT   dr.RelatedDocId
                    FROM dbo.DOCS_RELATED dr
                    WHERE dr.RelatedDocumentId = @docId
                          AND dr.RelatedTypeId = 1
                )
                )
                      OR d.DocId IN
                (
                    SELECT  dr.RelatedDocumentId
                    FROM dbo.DOCS_RELATED dr
                    WHERE dr.RelatedDocId = @docId
                          AND dr.RelatedTypeId = 1
                )
            ) s FOR JSON AUTO
        ) AS JsonRelatedDocumentInfo,

        ------------------------------------------------

        (
            SELECT *
            FROM
            (
                SELECT d.DocId,
                       CASE
                           WHEN d.DocEnterno IS NOT NULL
                           THEN d.DocEnterno
                           ELSE d.DocDocno
                       END DocEnterno,
                       CASE
                           WHEN d.DocEnterdate IS NOT NULL
                           THEN d.DocEnterdate
                           ELSE d.DocDocdate
                       END DocEnterdate,
                       CASE
                           WHEN d.DocDoctypeId IN(1, 2, 12)
                           THEN
                (
                    SELECT STUFF(
                    (
                        SELECT ' ' + OrganizationName + ','
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
                )
                           ELSE do.OrganizationName
                       END AS DocumentInfo, 
                       d.DocDescription, 
                       dr.ResultName, 
                       dd.DocumentstatusName
                FROM dbo.VW_DOC_INFO d
                     LEFT JOIN dbo.DC_ORGANIZATION do ON d.DocOrganizationId = do.OrganizationId
                     LEFT JOIN dbo.DOC_RESULT dr ON d.DocResultId = dr.Id
                     LEFT JOIN dbo.DOC_DOCUMENTSTATUS dd ON d.DocDocumentstatusId = dd.DocumentstatusId
                WHERE d.DocId IN
                (
                    SELECT dr.RelatedDocId
                    FROM dbo.DOCS_RELATED dr
                    WHERE dr.RelatedDocumentId = @docId
                          AND dr.RelatedTypeId = 2
                )
                      OR d.DocId IN
                (
                    SELECT dr.RelatedDocumentId
                    FROM dbo.DOCS_RELATED dr
                    WHERE dr.RelatedDocId = @docId
                          AND dr.RelatedTypeId = 2
                )
            ) s FOR JSON AUTO
        ) AS JsonAnswerDocumentInfo, 
        --      (
        --SELECT distinct s.rowNumber FROM (
        --          SELECT CASE
        --                     WHEN d.DocId < @docId
        --                     THEN 2
        --                     ELSE 1
        --                 END AS rowNumber
        --          FROM dbo.DOCS d
        --          WHERE d.DocId IN
        --          (
        --          (
        --              SELECT dr.RelatedDocId
        --              FROM dbo.DOCS_RELATED dr
        --              WHERE dr.RelatedDocumentId = @docId
        --                    AND dr.RelatedTypeId = 2
        --          )
        --          )
        --                OR d.DocId IN
        --          (
        --              SELECT dr.RelatedDocumentId
        --              FROM dbo.DOCS_RELATED dr
        --              WHERE dr.RelatedDocId = @docId
        --                    AND dr.RelatedTypeId = 2
        --          )) s
        --      ) AS AnswerRowNumber,

        (
            SELECT CASE
                       WHEN
            (
                SELECT COUNT(0)
                FROM dbo.DOCS_RELATED dr
                WHERE dr.RelatedDocId = d.DocId
                      AND dr.RelatedTypeId = 2
            ) > 0
                       THEN 2
                       ELSE 1
                   END
        ) AS AnswerRowNumber, 
        (
            SELECT COUNT(0)
            FROM dbo.DOCS d
            WHERE d.DocId IN
            (
                SELECT dr.RelatedDocumentId
                FROM dbo.DOCS_RELATED dr
                WHERE dr.RelatedDocId = @docId
            )
                  AND d.DocDoctypeId = 2
        ) AS CitizenResultCount,
        --Əməliyyat tarixçəsi
        (
            SELECT *
            FROM @OperationHistory
            ORDER BY DirectionDate, 
                     SendStatusId FOR JSON AUTO
        ) AS JsonOperationHistory
        FROM dbo.VW_DOC_INFO d
        WHERE d.docId = @docId
              AND d.DocDoctypeId = @doctype FOR JSON AUTO;
			  

    END;
