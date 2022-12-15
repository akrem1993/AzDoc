
/*
Migrated by Kamran A-eff 23.08.2019
*/
/*
Migrated by Kamran A-eff 06.08.2019
*/
/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [dms_insdoc].[spGetDocView] @docId       INT, 
                                            @docType     INT, 
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
         OperationFileId        INT, 
         SendStatusId           INT
        );
        EXEC sp_set_session_context 
             'docId', 
             @docId;
        IF EXISTS
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
                 OperationFileId, 
                 SendStatusId
                )
                       SELECT dbo.fnGetPersonnelbyWorkPlaceId(dol.SenderWorkPlaceId, 106) AS PersonFrom, 
                              dbo.fnGetPersonnelbyWorkPlaceId(dol.ReceiverWorkPlaceId, 106) AS PersonTo, 
                              dot.TypeName AS ExecutorMain, 
                              dol.OperationDate AS DirectionDate, 
                              dos.StatusName AS STATUS, 
                              dol.OperationStatusDate AS StatusDate, 
                              dol.OperationNote AS ExecutorResolutionNote, 
                              dol.OperationFileId AS OperationFile,
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
                       WHERE dol.DocId = @docId;
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
                         OperationFileId, 
                         SendStatusId
                        )
                               SELECT oh.PersonFrom, 
                                      oh.PersonTo, 
                                      oh.ExecutorMain, 
                                      oh.DirectionDate, 
                                      oh.STATUS, 
                                      oh.StatusDate, 
                                      oh.ExecutorResolutionNote, 
                                      NULL OperationFileId, 
                                      oh.SendStatusId
                               FROM
                               (
                                   SELECT vdv.*
                                   FROM dbo.VW_DOC_VIEW vdv
                               ) oh
                               UNION
                               SELECT dbo.fnGetPersonnelbyWorkPlaceId(dol.SenderWorkPlaceId, 106) AS PersonFrom, 
                                      dbo.fnGetPersonnelbyWorkPlaceId(dol.ReceiverWorkPlaceId, 106) AS PersonTo, 
                                      dot.TypeName AS ExecutorMain, 
                                      dol.OperationDate AS DirectionDate, 
                                      dos.StatusName AS STATUS, 
                                      dol.OperationStatusDate AS StatusDate, 
                                      dol.OperationNote AS ExecutorResolutionNote, 
                                      dol.OperationFileId AS OperationFileId,
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
                               WHERE dol.DocId = @docId;
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
                                   SELECT vdvo.*
                                   FROM dbo.VW_DOC_VIEW_OLD vdvo
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
        d.DocDocno AS DocDocNo, 
        d.DocDocdate AS DocDocDate, 
        @signatoryPerson AS SignatoryPerson, 
        @confirmPerson AS ConfirmPerson, 
        (
            SELECT f.FormName Name
            FROM DOC_FORM f
            WHERE f.FormId = d.DocFormId
        ) AS FormName, 
        d.DocDocumentstatusId DocDocumentStatusId, 
        (
            SELECT dd.DocumentstatusName
            FROM dbo.DOC_DOCUMENTSTATUS dd
            WHERE dd.DocumentstatusId = d.DocDocumentstatusId
        ) DocumentStatusName,
        ---------------------------------------------------------------
        d.DocDescription AS Description, --Sənədin qısa məzmunu
        --Tapşırıqlar------------------------------------
        (
            SELECT t.TaskId, 
                   t.TaskDocNo, 
            (
                SELECT s.SendStatusName
                FROM dbo.DOC_SENDSTATUS s
                WHERE s.SendStatusId = t.TypeOfAssignmentId
            ) TypeOfAssignment,
                   CASE
                       WHEN SUBSTRING(convert(nvarchar(max),t.TaskNo), LEN(convert(nvarchar(max),t.TaskNo)), CHARINDEX('.', convert(nvarchar(max),t.TaskNo))) = '0'
                       THEN SUBSTRING(convert(nvarchar(max),t.TaskNo), 0, CHARINDEX('.', convert(nvarchar(max),t.TaskNo)))
                       ELSE convert(nvarchar(max),t.TaskNo)
                   END AS TaskNo, 
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
                       ELSE ''
                   END FileIsMain, 
                   fi.FileInfoCopiesCount, 
                   fi.FileInfoPageCount, 
                   fi.FileInfoInsertdate AS FileInfoDate
            FROM dbo.DOCS_FILE f
                 JOIN DOCS_FILEINFO fi ON f.FileInfoId = fi.FileInfoId
            WHERE f.FileDocId = @docId
                  AND f.IsDeleted = 0
                  AND f.FileVisaStatus <> 0
            ORDER BY f.FileIsMain DESC FOR JSON AUTO
        ) AS JsonFileInfo,
        ------------------------------------------------

        (
            SELECT *
            FROM
            (
            

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
