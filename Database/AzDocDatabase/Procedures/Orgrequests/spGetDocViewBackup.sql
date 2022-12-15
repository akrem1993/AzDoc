
-- =============================================
-- Author:  Musayev Nurlan
-- Create date: 23.04.2019
-- Description: Qyediyyat nezaret vereqesi ucun select proseduru
-- =============================================
CREATE PROCEDURE [orgrequests].[spGetDocViewBuckUp] @docId       INT, 
                                             @workPlaceId INT
AS
     DECLARE @docType INT= 1;--Sənədin tipi(təşkilat müraciəti=1)
     DECLARE @executorCount INT;
    BEGIN
        IF(@docId IS NOT NULL
           AND @doctype IS NOT NULL)
            BEGIN
                SELECT @executorCount = COUNT(0)
                FROM dbo.DOCS_EXECUTOR e
                WHERE e.ExecutorDocId = @docId
                      AND e.ExecutorWorkplaceId = @workPlaceId
                      AND e.DirectionTypeId = 18;
                DECLARE @OperationHistory TABLE
                (PersonFrom              NVARCHAR(MAX), 
                 PersonTo                NVARCHAR(MAX), 
                 ExecutorMain            NVARCHAR(MAX), 
                 DirectionDate           DATETIME, 
                 STATUS                  NVARCHAR(MAX), 
                 StatusDate              DATETIME, 
                 ExecutorResolutionNote  NVARCHAR(MAX), 
                 SendStatusId            INT, 
                 NewDirectionPlannedDate DATETIME, 
                 DirectionChangeStatus   NVARCHAR(MAX)
                );
                EXEC sp_set_session_context 
                     'docId', 
                     @docId;
                DECLARE @authorCount INT= 0;
                SELECT @authorCount = COUNT(af.AdrAuthorId)
                FROM DOCS_ADDRESSINFO af
                WHERE af.AdrDocId = @docId
                      AND af.AdrTypeId = 3
                      AND af.AdrAuthorId IS NOT NULL;
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
                         SendStatusId, 
                         NewDirectionPlannedDate, 
                         DirectionChangeStatus
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
                                      END AS SendStatusId, 
                                      (CASE
                                           WHEN dol.OperationStatus = 1
                                                AND dd.ChangeType = 2
                                                AND dol.DirectionTypeId = 7
                                           THEN dd.NewDirectionPlannedDate
                                       END) AS NewDirectionPlannedDate, 
                                      (CASE
                                           WHEN dol.OperationStatus = 1
                                                AND dol.DirectionTypeId = 7
                                                AND dd.ChangeType = 2
                                                AND dd.DirectionChangeStatus = 1
                                           THEN N'Təsdiq edilib'
                                           WHEN dol.OperationStatus = 1
                                                AND dol.DirectionTypeId = 7
                                                AND dd.ChangeType = 2
                                                AND dd.DirectionChangeStatus = 0
                                           THEN N'Təsdiqdədir'
                                           WHEN dol.OperationStatus = 1
                                                AND dol.DirectionTypeId = 7
                                                AND dd.ChangeType = 2
                                                AND dd.DirectionChangeStatus = 2
                                           THEN N'İmtina edilib'
                                       END) AS DirectionChangeStatus
                               FROM dbo.DocOperationsLog dol
                                    LEFT JOIN dbo.DocOperationStatus dos ON dol.OperationStatus = dos.StatusId
                                    JOIN dbo.DocOperationTypes dot ON dot.TypeId = dol.OperationTypeId
                                    LEFT JOIN dbo.DOCS_EXECUTOR de ON dol.ExecutorId = de.ExecutorId
                                    LEFT JOIN dbo.DOCS_DIRECTIONCHANGE dd ON de.ExecutorDirectionId = dd.DirectionId
									 AND dol.operationnote = dd.DirectionChangeNote---tekrar setirlerin gelmemesi ucun (gular )
                               WHERE dol.DocId = @docId
                                     AND dol.IsDeleted IS NULL;
                END;
                    ELSE
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
                                 SendStatusId, 
                                 NewDirectionPlannedDate, 
                                 DirectionChangeStatus
                                )
                                       SELECT oh.PersonFrom, 
                                              oh.PersonTo, 
                                              oh.ExecutorMain, 
                                              oh.DirectionDate, 
                                              oh.STATUS, 
                                              oh.StatusDate, 
                                              oh.ExecutorResolutionNote, 
                                              oh.SendStatusId, 
                                              oh.NewDirectionPlannedDate, 
                                              oh.DirectionChangeStatus
                                       FROM
                                       (
                                           SELECT distinct  vdol.*
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
                                              END AS SendStatusId, 
                                              (CASE
                                                   WHEN dol.OperationStatus = 1
                                                        AND dd.ChangeType = 2
                                                        AND dol.DirectionTypeId = 7
                                                   THEN dd.NewDirectionPlannedDate
                                               END) AS NewDirectionPlannedDate, 
                                              (CASE
                                                   WHEN dol.OperationStatus = 1
                                                        AND dol.DirectionTypeId = 7
                                                        AND dd.ChangeType = 2
                                                        AND dd.DirectionChangeStatus = 1
                                                   THEN N'Təsdiq edilib'
                                                   WHEN dol.OperationStatus = 1
                                                        AND dol.DirectionTypeId = 7
                                                        AND dd.ChangeType = 2
                                                        AND dd.DirectionChangeStatus = 0
                                                   THEN N'Təsdiqdədir'
                                                   WHEN dol.OperationStatus = 1
                                                        AND dol.DirectionTypeId = 7
                                                        AND dd.ChangeType = 2
                                                        AND dd.DirectionChangeStatus = 2
                                                   THEN N'İmtina edilib'
                                               END) AS DirectionChangeStatus
                                       FROM dbo.DocOperationsLog dol
                                            LEFT JOIN dbo.DocOperationStatus dos ON dol.OperationStatus = dos.StatusId
                                            JOIN dbo.DocOperationTypes dot ON dot.TypeId = dol.OperationTypeId
                                            LEFT JOIN dbo.DOCS_EXECUTOR de ON dol.ExecutorId = de.ExecutorId
                                            LEFT JOIN dbo.DOCS_DIRECTIONCHANGE dd ON (de.ExecutorDirectionId = dd.DirectionId AND dd.OperationId=dol.OperationId)
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
                                 SendStatusId, 
                                 NewDirectionPlannedDate, 
                                 DirectionChangeStatus
                                )
                                       SELECT oh.PersonFrom, 
                                              oh.PersonTo, 
                                              oh.ExecutorMain, 
                                              oh.DirectionDate, 
                                              oh.STATUS, 
                                              oh.StatusDate, 
                                              oh.ExecutorResolutionNote, 
                                              oh.SendStatusId, 
                                              oh.NewDirectionPlannedDate, 
                                              oh.DirectionChangeStatus
                                       FROM
                                       (
                                           SELECT distinct vdol.*
                                           FROM dbo.VW_DOC_OLD_LAST vdol
                                           WHERE vdol.DocId = @docId
                                       ) oh;
                        END;
                END;

				---------

                SELECT *
                FROM
                (
                    SELECT 
                    -- Bashliq 
                    (
                        SELECT o.OrganizationName
                        FROM dbo.DC_ORGANIZATION o
                        WHERE o.OrganizationId = d.DocOrganizationId
                    ) AS OrganizationName, -- teskilati adi
                    (
                        SELECT a.Caption
                        FROM dbo.AC_MENU a
                        WHERE a.DocTypeId = d.DocDoctypeId
                    ) AS ModuleName, -- modulun adi
                    -- Qeydiyyat məlumatları
                    d.DocEnterno AS RegisterNumber, -- qeydiyyat nomresi
                    d.DocEnterdate AS RegisterDate, --qeydiyyat tarixi
                    d.DocDocno AS DocumentNumber, -- senedin nomresi
                    d.DocDocdate AS DocumentDate, -- senedin tarixi
                    (
                        SELECT STUFF(
                        (
                            SELECT ' ' + OrganizationName
                            FROM DC_ORGANIZATION o
                            WHERE o.OrganizationId IN
                            (
                                SELECT  af.AdrOrganizationId
                                FROM DOCS_ADDRESSINFO af
                                WHERE af.AdrDocId = d.DocId
                                      AND af.AdrTypeId = 3
                                      AND af.AdrAuthorId IS NOT NULL
                            ) FOR XML PATH('')
                        ), 1, 1, '')
                    ) AS EntryFromWhere, -- haradan daxil olub
                    (CASE
                         WHEN d.DocExecutionStatusId IS NULL
                         THEN ds.SendStatusName
                         ELSE es.ExecutionstatusName
                     END) AS ExecuteRule, -- icra qaydasi 
                    d.DocExecutionStatusId AS ExecutionStatusId, --Icra statusu  
                    --           ((CASE
                    --                 WHEN
                    --           (
                    --               SELECT TOP 1 da.AuthorDepartmentId
                    --               FROM dbo.DOC_AUTHOR da
                    --               WHERE da.AuthorId IN
                    --               (
                    --                   SELECT af.AdrAuthorId
                    --                   FROM DOCS_ADDRESSINFO af
                    --                   WHERE af.AdrDocId = d.DocId
                    --                         AND af.AdrTypeId = 3
                    --                         AND af.AdrAuthorId IS NOT NULL
                    --               )
                    --           ) IS NULL
                    --                 THEN
                    --           (
                    --               SELECT STUFF(
                    --               (
                    --                   SELECT a.AuthorName + ' ' + a.AuthorSurname + ' ' + ISNULL(a.AuthorLastname, '')  + CASE WHEN a.AuthorPositionId IS NOT NULL then	'(' + p.PositionName + ')' ELSE	',' end
                    --                   FROM dbo.DOC_AUTHOR a
                    --                        LEFT JOIN dbo.DC_ORGANIZATION o ON a.AuthorOrganizationId = o.OrganizationId
                    --LEFT JOIN dbo.DC_DEPARTMENT dd ON dd.DepartmentId = a.AuthorDepartmentId
                    --                        LEFT JOIN dbo.DC_POSITION p ON p.PositionId = a.AuthorPositionId
                    --                   WHERE a.AuthorId IN
                    --                   (
                    --                       SELECT af.AdrAuthorId
                    --                       FROM DOCS_ADDRESSINFO af
                    --                       WHERE af.AdrDocId = d.DocId
                    --                             AND af.AdrTypeId = 3
                    --                             AND af.AdrAuthorId IS NOT NULL
                    --                   ) FOR XML PATH('')
                    --               ), 1, 0, '')
                    --           )
                    --                 ELSE
                    --           (
                    --               SELECT STUFF(
                    --               (
                    --                   SELECT(a.AuthorName + ' ' + a.AuthorSurname + ' ' + ISNULL(a.AuthorLastname, '')) + ', ' + p.PositionName
                    --                   FROM dbo.DOC_AUTHOR a
                    --                        LEFT JOIN dbo.DC_ORGANIZATION o ON a.AuthorOrganizationId = o.OrganizationId
                    --                        LEFT JOIN dbo.DC_DEPARTMENT dd ON dd.DepartmentId = a.AuthorDepartmentId
                    --                        LEFT JOIN dbo.DC_POSITION p ON p.PositionId = a.AuthorPositionId
                    --                   WHERE a.AuthorId IN
                    --                   (
                    --                       SELECT af.AdrAuthorId
                    --                       FROM DOCS_ADDRESSINFO af
                    --                       WHERE af.AdrDocId = d.DocId
                    --                             AND af.AdrTypeId = 3
                    --                             AND af.AdrAuthorId IS NOT NULL
                    --                   ) FOR XML PATH('')
                    --               ), 1, 0, '')
                    --           )
                    --             END)) AS EntryFromWho, -- kimden daxil olub 
                    (
                        SELECT STUFF(
                        (
                            SELECT a.AuthorName + ' ' + a.AuthorSurname + ' ' + ISNULL(a.AuthorLastname, '') + CASE
                                                                                                                   WHEN a.AuthorPositionId IS NOT NULL
                                                                                                                   THEN '(' + p.PositionName + ')' + CASE
                                                                                                                                                         WHEN @authorCount > 1
                                                                                                                                                         THEN ','
                                                                                                                                                         ELSE ''
                                                                                                                                                     END
                                                                                                                   ELSE ','
                                                                                                               END
                            FROM dbo.DOC_AUTHOR a
                                 LEFT JOIN dbo.DC_ORGANIZATION o ON a.AuthorOrganizationId = o.OrganizationId
                                 LEFT JOIN dbo.DC_DEPARTMENT dd ON dd.DepartmentId = a.AuthorDepartmentId
                                 LEFT JOIN dbo.DC_POSITION p ON p.PositionId = a.AuthorPositionId
                            WHERE a.AuthorId IN
                            (
                                SELECT af.AdrAuthorId
                                FROM DOCS_ADDRESSINFO af
                                WHERE af.AdrDocId = d.DocId
                                      AND af.AdrTypeId = 3
                                      AND af.AdrAuthorId IS NOT NULL
                            ) FOR XML PATH('')
                        ), 1, 0, '')
                    ) AS EntryFromWho, 
                    d.DocPlannedDate AS ExecDuration, -- icra muddeti
                    (
                        SELECT OrganizationName
                        FROM DC_ORGANIZATION
                        WHERE OrganizationId =
                        (
                            SELECT af.AdrOrganizationId
                            FROM DOCS_ADDRESSINFO af
                            WHERE af.AdrDocId = d.DocId
                                  AND af.AdrTypeId = 2
                                  AND af.AdrAuthorId IS NULL
                        )
                    ) AS SendToWhere, -- hara unvanlanib
                    df.FormName AS DocumentKind, --Senedin novu  
                    (
                        SELECT CASE
                                   WHEN af.AdrPersonId IS NULL
                                   THEN do.OrganizationName
                                   ELSE af.FullName
                               END
                        FROM DOCS_ADDRESSINFO af
                             JOIN dbo.DC_ORGANIZATION do ON af.AdrOrganizationId = do.OrganizationId
                        WHERE af.AdrDocId = d.DocId
                              AND af.AdrTypeId = 2
                              AND af.AdrAuthorId IS NULL
                    ) AS SendToWho, -- kime unvanlanib 
                    dr.ReceivedFormName AS EntryForm, -- daxil olma formasi 
                    tt.TopicTypeName AS Subject, -- movzu
                    (
                        SELECT dd.DocumentstatusName
                        FROM dbo.DOC_DOCUMENTSTATUS dd
                        WHERE dd.DocumentstatusId = d.DocDocumentstatusId
                    ) AS DocumentStatus, -- senedin statusu
                    d.DocDocumentstatusId AS DocDocumentStatusId,
                    --Sənədin qısa məzmunu
                    d.DocDescription AS ShortContent, --qisa mezmun   
                    d.DocDuplicateId, -- Təkrar müraciət
                    --Qoşma sənəd
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
                             INNER JOIN DOCS_FILEINFO fi ON f.FileInfoId = fi.FileInfoId
                        WHERE f.FileDocId = @docId
                              AND f.IsDeleted = 0
                        ORDER BY f.FileIsMain DESC FOR JSON AUTO
                    ) AS JsonFileInfo, 
                    (
                        SELECT *
                        FROM
                        (
                            --SELECT r.RelatedDocumentId AS DocId, 
                            --       d.DocEnterno, 
                            --       d.DocEnterdate, 
                            --       d.DocDocno, 
                            --       d.DocDocdate, 
                            --       d.DocDoctypeId, 
                            --       (CONCAT(da.AppFirstname, SPACE(1), da.AppSurname, SPACE(1), da.AppLastname) + ' ' +
                            --(
                            --    SELECT ' ' + OrganizationName
                            --    FROM DC_ORGANIZATION o
                            --    WHERE o.OrganizationId =
                            --    (
                            --        SELECT TOP (1) af.AdrOrganizationId
                            --        FROM DOCS_ADDRESSINFO af
                            --        WHERE af.AdrDocId = r.RelatedDocumentId
                            --              AND af.AdrTypeId = 3
                            --              AND af.AdrAuthorId IS NOT NULL
                            --    )
                            --)) DocumentInfo, 
                            --       d.DocDescription
                            --FROM dbo.VW_DOC_INFO d
                            --     LEFT JOIN dbo.DOCS_RELATED r ON d.DocId = r.RelatedDocumentId
                            --     LEFT JOIN dbo.DOCS_APPLICATION da ON d.DocId = da.AppDocId
                            --WHERE r.RelatedDocId = @docId
                            --      AND r.RelatedTypeId = 1
                            --UNION
                            --SELECT r.RelatedDocId AS DocId, 
                            --       d.DocEnterno, 
                            --       d.DocEnterdate, 
                            --       d.DocDocno, 
                            --       d.DocDocdate, 
                            --       d.DocDoctypeId, 
                            --       (CONCAT(da.AppFirstname, SPACE(1), da.AppSurname, SPACE(1), da.AppLastname) + ' ' +
                            --(
                            --    SELECT ' ' + OrganizationName
                            --    FROM DC_ORGANIZATION o
                            --    WHERE o.OrganizationId =
                            --    (
                            --        SELECT TOP (1) af.AdrOrganizationId
                            --        FROM DOCS_ADDRESSINFO af
                            --        WHERE af.AdrDocId = r.RelatedDocId
                            --              AND af.AdrTypeId = 3
                            --              AND af.AdrAuthorId IS NOT NULL
                            --    )
                            --)) DocumentInfo, 
                            --       d.DocDescription
                            --FROM dbo.VW_DOC_INFO d
                            --     LEFT JOIN dbo.DOCS_RELATED r ON d.DocId = r.RelatedDocId
                            --     LEFT JOIN dbo.DOCS_APPLICATION da ON d.DocId = da.AppDocId
                            --WHERE r.RelatedDocumentId = @docId
                            --      AND r.RelatedTypeId = 1

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
                                   
                 (SELECT STUFF(
                (
                   SELECT ', ' + do.OrganizationName FROM dbo.DC_ORGANIZATION do WHERE do.OrganizationId IN (SELECT da.AdrOrganizationId FROM dbo.DOCS_ADDRESSINFO da WHERE da.AdrDocId=d.DocId AND da.AdrTypeId=3)FOR XML PATH('')
                ), 1, 1, '') )AS DocumentInfo,
                                   d.DocDescription, 
                                   dr.ResultName, 
                                   dd.DocumentstatusName
                            FROM dbo.VW_DOC_INFO d
                                  LEFT JOIN dbo.DOC_RESULT dr ON d.DocResultId = dr.Id
                                 LEFT JOIN dbo.DOC_DOCUMENTSTATUS dd ON d.DocDocumentstatusId = dd.DocumentstatusId
								
                            WHERE d.DocId IN
                            (
                            (
                                SELECT dr.RelatedDocId
                                FROM dbo.DOCS_RELATED dr
                                WHERE dr.RelatedDocumentId = @docId
                                      AND dr.RelatedTypeId = 1
                            )
                            )
                                  OR d.DocId IN
                            (
                                SELECT dr.RelatedDocumentId
                                FROM dbo.DOCS_RELATED dr
                                WHERE dr.RelatedDocId = @docId
                                      AND dr.RelatedTypeId = 1
                            )
                        ) s FOR JSON AUTO
                    ) AS JsonRelatedDocumentInfo, 
                    (
                        SELECT t.TaskId, 
                               t.TaskDocNo, 
                        (
                            SELECT s.SendStatusName
                            FROM dbo.DOC_SENDSTATUS s
                            WHERE s.SendStatusId = t.TypeOfAssignmentId
                        ) TypeOfAssignment, 
                               CONVERT(INT, t.TaskNo) AS TaskNo, 
                               t.TaskDecription Task, 
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
                    ) AS JsonTask, --Tapşırıqlar
                    (
                        SELECT *
                        FROM
                        (
                            SELECT d.DocId, 
                                   d.DocEnterno, 
                                   d.DocEnterdate, 
                                   d.DocDocno, 
                                   d.DocDocdate, 
                                   d.DocDoctypeId,
                                   CASE
                                       WHEN d.DocDoctypeId = 1
                                            OR d.DocDoctypeId = 2
                                       THEN(
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
                            ) + ' , ' +
                            (
                                SELECT STUFF(
                                (
                                    SELECT(a.AuthorName + ' ' + a.AuthorSurname + ' ' + ISNULL(a.AuthorLastname, ''))
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
                            ))
                                       WHEN d.DocDoctypeId = 12
                                       THEN
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
                            )
                                       WHEN d.DocDoctypeId = 3
                                            OR d.DocDoctypeId = 18
                                       THEN
                            (
                                SELECT af.FullName
                                FROM dbo.DOCS_ADDRESSINFO af
                                WHERE af.AdrDocId = @docId
                                      AND af.AdrTypeId = 1
                            )
                                   END AS DocumentInfo, 
                                   d.DocDescription, 
                                   dd.DocumentstatusName
                            FROM dbo.VW_DOC_INFO d
                                 LEFT JOIN dbo.DC_ORGANIZATION do ON d.DocOrganizationId = do.OrganizationId
                                 LEFT JOIN dbo.DOC_DOCUMENTSTATUS dd ON d.DocDocumentstatusId = dd.DocumentstatusId
                            WHERE d.DocId IN
                            (
                            (
                                SELECT dr.RelatedDocId
                                FROM dbo.DOCS_RELATED dr
                                WHERE dr.RelatedDocumentId = @docId
                                      AND dr.RelatedTypeId = 2
                            )
                            )
                                  OR d.DocId IN
                            (
                                SELECT dr.RelatedDocumentId
                                FROM dbo.DOCS_RELATED dr
                                WHERE dr.RelatedDocId = @docId
                                      AND dr.RelatedTypeId = 2
                            )
                            --SELECT d.DocId, 
                            --       d.DocEnterno, 
                            --       d.DocEnterdate, 
                            --       do.OrganizationName AS DocumentInfo, 
                            --       d.DocDescription, 
                            --       dr.ResultName, 
                            --       dd.DocumentstatusName
                            --FROM dbo.VW_DOC_INFO d
                            --     LEFT JOIN dbo.DC_ORGANIZATION do ON d.DocOrganizationId = do.OrganizationId
                            --     LEFT JOIN dbo.DOC_RESULT dr ON d.DocResultId = dr.Id
                            --     LEFT JOIN dbo.DOC_DOCUMENTSTATUS dd ON d.DocDocumentstatusId = dd.DocumentstatusId
                            --WHERE d.DocId IN
                            --(
                            --(
                            --    SELECT dr.RelatedDocId
                            --    FROM dbo.DOCS_RELATED dr
                            --    WHERE dr.RelatedDocumentId = @docId
                            --          AND dr.RelatedTypeId = 2
                            --)
                            --)
                            --      OR d.DocId IN
                            --(
                            --    SELECT dr.RelatedDocumentId
                            --    FROM dbo.DOCS_RELATED dr
                            --    WHERE dr.RelatedDocId = @docId
                            --          AND dr.RelatedTypeId = 2
                            --)
                        ) s FOR JSON AUTO
                    ) AS JsonAnswerDocumentInfo, 
                    d.DocUndercontrolStatusId AS SupervisionId, 
                    (
                        SELECT *
                        FROM @OperationHistory
                        ORDER BY DirectionDate, 
                                 SendStatusId FOR JSON AUTO
                    ) AS JsonOperationHistory--Əməliyyat tarixçəsi
                    FROM dbo.VW_DOC_INFO d
                         LEFT JOIN dbo.DOC_TOPIC_TYPE tt ON tt.TopicTypeId = d.DocTopicType
                         LEFT JOIN dbo.DOC_EXECUTIONSTATUS es ON es.ExecutionStatusId = d.DocExecutionStatusId
                         LEFT JOIN dbo.DOC_SENDSTATUS ds ON d.DocSendTypeId = ds.SendStatusId
                         LEFT JOIN dbo.DOCS_ADDRESSINFO ai ON ai.AdrDocId = d.DocId
                                                              AND ai.AdrAuthorId IS NOT NULL
                         LEFT JOIN dbo.DOC_FORM df ON df.FormId = d.DocFormId
                         LEFT JOIN dbo.DOC_RECEIVED_FORM dr ON dr.ReceivedFormId = d.DocReceivedFormId
                    WHERE d.docId = @docId
                          AND d.DocDoctypeId = @doctype
                ) s FOR JSON AUTO;
        END;
    END;
