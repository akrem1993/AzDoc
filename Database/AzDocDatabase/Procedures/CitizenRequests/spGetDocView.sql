
/*
Migrated by Kamran A-eff 23.08.2019
*/
/*
Migrated by Kamran A-eff 06.08.2019
*/
/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [citizenrequests].[spGetDocView] @docId       INT, 
                                                 @docType     INT, 
                                                 @workPlaceId INT,
												 @newPlanedHistory nvarchar(max) OUT
AS
    BEGIN
        IF NOT EXISTS
        (
            SELECT d.DocId
            FROM dbo.VW_DOC_INFO d
            WHERE d.DocId = @docId
        )
            THROW 56000, 'Mövcud sənəd tapılmadı', 1;
        DECLARE @executorCount INT, @docIndex NVARCHAR(MAX), @docEnterNo NVARCHAR(MAX), @docEnterNoCount INT, @strDocEnterNo NVARCHAR(MAX), @strDocEnterNo1 NVARCHAR(MAX), @strDocInsertByDate DATETIME, @strDocId INT;
        IF(@docId > 2734)
            BEGIN
                SELECT @strDocEnterNo = LEFT(SUBSTRING(d.DocEnterno, (CHARINDEX('-', d.DocEnterno) + 1), LEN(d.DocEnterno)), CHARINDEX('-', SUBSTRING(d.DocEnterno, (CHARINDEX('-', d.DocEnterno) + 1), LEN(d.DocEnterno))) - 1)
                FROM dbo.VW_DOC_INFO d
                WHERE d.DocId = @docId;
                SELECT @strDocEnterNo1 = LEFT(d.DocEnterno, (CHARINDEX('-', d.DocEnterno) - 1)), 
                       @strDocInsertByDate = d.DocInsertedByDate
                FROM dbo.VW_DOC_INFO d
                WHERE d.DocId = @docId;
                SELECT @docIndex = SUBSTRING(d.DocEnterno, CHARINDEX('-', d.DocEnterno) + 1, LEN(d.DocEnterno))
                FROM dbo.VW_DOC_INFO d
                WHERE d.DocId = @docId;
                SELECT @docEnterNoCount = COUNT(0)
                FROM
                (
                    SELECT d.DocId, 
                           d.DocEnterno
                    FROM dbo.VW_DOC_INFO d
                    WHERE d.DocEnterno LIKE '%-' + @strDocEnterNo + '-%'
                          AND d.DocId <> @docId
                          AND d.DocDoctypeId = 2
                          AND d.DocInsertedByDate < @strDocInsertByDate
                ) s
                WHERE s.DocEnterno LIKE '%' + @strDocEnterNo1 + '%';
        END;
            ELSE
            BEGIN
                SELECT @strDocEnterNo = LEFT(SUBSTRING(d.DocEnterno, (CHARINDEX('-', d.DocEnterno) + 1), LEN(d.DocEnterno)), 4), 
                       @strDocId = d.DocId
                FROM dbo.VW_DOC_INFO d
                WHERE d.DocId = @docId;
                SET @strDocEnterNo1 = '';
                SELECT @docEnterNoCount = COUNT(0)
                FROM
                (
                    SELECT d.DocId, 
                           d.DocEnterno
                    FROM dbo.VW_DOC_INFO d
                    WHERE d.DocEnterno LIKE '%-' + @strDocEnterNo + '%'
                          AND d.DocId <> @docId
                          AND d.DocDoctypeId = 2
                          AND d.DocId < @strDocId
                ) s
                WHERE s.DocEnterno LIKE '%' + @strDocEnterNo + '%';
        END;
        --IF EXISTS
        --(
        --    SELECT SUBSTRING(d.DocEnterno, CHARINDEX('-', d.DocEnterno) + 1, LEN(d.DocEnterno))
        --    FROM dbo.VW_DOC_INFO d
        --    WHERE d.DocId = @docId
        --          AND d.DocEnterno LIKE '%/%'
        --)
        --    BEGIN
        --        SELECT @docEnterNo =
        --        (
        --            SELECT LEFT(d.DocEnterno, CHARINDEX('-', d.DocEnterno))  -- D- 
        --        ) +
        --        (
        --            SELECT SUBSTRING(@docIndex, 1, CHARINDEX('/', @docIndex) - 1)
        --        )
        --        FROM dbo.VW_DOC_INFO d
        --        WHERE d.DocId = @docId;
        --END;
        --    ELSE
        --    IF EXISTS
        --    (
        --        SELECT *
        --        FROM
        --        (
        --            SELECT SUBSTRING(d.DocEnterno, CHARINDEX('-', d.DocEnterno) + 1, LEN(d.DocEnterno)) AS docEnterNo
        --            FROM dbo.VW_DOC_INFO d
        --            WHERE d.DocId = @docId
        --        ) s
        --        WHERE s.DocEnterno LIKE '%-%'
        --    )
        --        BEGIN
        --            SELECT @docEnterNo =
        --            (
        --                SELECT LEFT(d.DocEnterno, CHARINDEX('-', d.DocEnterno))  -- D- 
        --            ) +
        --            (
        --                SELECT LEFT(
        --                (
        --                    SELECT @docIndex
        --                ), CHARINDEX('-',
        --                (
        --                    SELECT @docIndex
        --                )) - 1)
        --            )
        --            FROM dbo.VW_DOC_INFO d
        --            WHERE d.DocId = @docId;
        --    END;
        --        ELSE
        --        BEGIN
        --            SELECT @docEnterNo =
        --            (
        --                SELECT LEFT(d.DocEnterno, CHARINDEX('-', d.DocEnterno))  -- D- 
        --            ) + (@docIndex)
        --            FROM dbo.VW_DOC_INFO d
        --            WHERE d.DocId = @docId;
        --    END;
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
                --dol.ExecutorId,
                --dol.DocId,
                --dol.OperationFileId as OperationFileId
                       FROM dbo.DocOperationsLog dol
                            LEFT JOIN dbo.DocOperationStatus dos ON dol.OperationStatus = dos.StatusId
                            JOIN dbo.DocOperationTypes dot ON dot.TypeId = dol.OperationTypeId
                            LEFT JOIN dbo.DOCS_EXECUTOR de ON dol.ExecutorId = de.ExecutorId
                            LEFT JOIN dbo.DOCS_DIRECTIONCHANGE dd ON (de.ExecutorDirectionId = dd.DirectionId AND dd.OperationId=dol.OperationId)
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
                                   SELECT DISTINCT vdol.*
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

                               --dol.ExecutorId,
                               --dol.DocId,
                               --dol.OperationFileId as OperationFileId
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

        ----------------------------Qeydiyyat nezaret vereqesi------------------------------------------------------
        SELECT *
        FROM
        (
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
            d.DocEnterno AS RegisterNumber, 
            d.DocEnterdate AS RegisterDate, 
            d.DocDocno AS DocumentNumber, 
            d.DocDocdate AS DocumentDate, 
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
            (CASE
                 WHEN d.DocExecutionStatusId IS NULL
                 THEN ds.SendStatusName
                 ELSE de.ExecutionstatusName
             END) AS ExecuteRule, -- icra qaydasi 

            d.DocExecutionStatusId AS ExecutionStatusId, --Icra statusu
            (
            (
                SELECT STUFF(
                (
                    SELECT(a.AuthorName + ' ' + a.AuthorSurname + ' ' + ISNULL(a.AuthorLastname, ''))
                    FROM dbo.DOC_AUTHOR a
                    WHERE a.AuthorId IN
                    (
                        SELECT af.AdrAuthorId
                        FROM DOCS_ADDRESSINFO af
                        WHERE af.AdrDocId = d.DocID
                              AND af.AdrTypeId = 3
                              AND af.AdrAuthorId IS NOT NULL
                    ) FOR XML PATH('')
                ), 1, 0, '')
            )
            ) AS EntryFromWho, -- kimden daxil olub 
            d.DocPlannedDate AS ExecDuration, -- icra muddeti
		
            (
                SELECT  OrganizationName
                FROM DC_ORGANIZATION
                WHERE OrganizationId =
                (
                    SELECT DISTINCT af.AdrOrganizationId
                    FROM DOCS_ADDRESSINFO af
                    WHERE af.AdrDocId = d.DocId
                          AND af.AdrTypeId = 2
                          AND af.AdrAuthorId IS NULL
                )
            ) AS SendToWhere, -- hara unvanlanib
            da2.ApplytypeName AS DocumentKind, --Senedin novu 
            da.Field1 AS NumberOfApplicants, --Müraciətçilərin sayı
            (
                SELECT DISTINCT CASE
                           WHEN af.AdrPersonId IS NULL
                           THEN  do.OrganizationName
                           ELSE af.FullName
                       END
                FROM DOCS_ADDRESSINFO af
                     JOIN dbo.DC_ORGANIZATION do ON af.AdrOrganizationId = do.OrganizationId
                WHERE af.AdrDocId = d.DocId
                      AND af.AdrTypeId = 2
                      AND af.AdrAuthorId IS NULL
            ) AS SendToWho, -- kime unvanlanib 
            drf.ReceivedFormName AS EntryForm, -- daxil olma formasi 
            dtt.TopicTypeName + ' / ' + dt.TopicName AS Subject, -- movzu
            CASE da.Field16
                WHEN 1
                THEN N'Bəli'
                ELSE 'Xeyr'
            END Corruption, 
            (
            (
                SELECT da2.AgencyName
                FROM dbo.DC_AGENCY da2
                WHERE da2.AgencyId = CONVERT(INT, da.Field2)
            ) + ' / ' +
            (
                SELECT da2.AgencyName
                FROM dbo.DC_AGENCY da2
                WHERE da2.AgencyId = CONVERT(INT, da.Field3)
            )) AS Organization, 
            (
                SELECT dd.DocumentstatusName
                FROM dbo.DOC_DOCUMENTSTATUS dd
                WHERE dd.DocumentstatusId = d.DocDocumentstatusId
            ) AS DocumentStatus, -- senedin statusu
            d.DocDescription AS ShortContent, --qisa mezmun  
            d.DocDuplicateId, -- Təkrar müraciət 
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
            ------Əvvəlki müraciətlər------ 
            (
                SELECT *
                FROM
                (
                    SELECT d.DocId, 
                           d.DocEnterno
                    FROM dbo.VW_DOC_INFO d
                    WHERE d.DocEnterno LIKE '%-' + @strDocEnterNo + CASE
                                                                        WHEN @docId > 2734
                                                                        THEN '-%'
                                                                        ELSE '%'
                                                                    END
                          AND d.DocId <> @docId
                          AND d.DocDoctypeId = 2
						  AND d.DocPeriodId=(SELECT d2.DocPeriodId FROM dbo.DOCS d2 WHERE d2.DocId=@docId)
                          AND (d.DocInsertedByDate <= @strDocInsertByDate
                               OR d.DocId <= @strDocId)
                ) s
                WHERE s.DocEnterno LIKE '%' + CASE
                                                  WHEN @docId > 2734
                                                  THEN @strDocEnterNo1
                                                  ELSE @strDocEnterno
                                              END + '%'
                ORDER BY s.DocId FOR JSON AUTO
            ) AS JsonPreviosRequests, 
            --(
            --    SELECT COUNT(0)
            --    FROM dbo.VW_DOC_INFO d
            --    WHERE d.DocEnterno LIKE '' +
            --    (
            --        SELECT @docEnterNo
            --    ) + '%'
            --          AND d.DocId <> @docId
            --) 
            @docEnterNoCount + 1 AS PreviosRequestsCount,
            -------Muraciətçilər----------------------------
            (
                SELECT *
                FROM
                (
                    SELECT da.AppFirstname, 
                           da.AppSurname, 
                           da.AppLastName, 
                           ds.SocialName, 
                           dc.CountryName, 
                           dr2.RegionName, 
                           da.AppAddress1 AS AppAddress, 
                           dr.RepresenterName, 
                           da.AppPhone1 AS AppPhone, 
                           da.AppEmail1 AS AppEmail
                    FROM dbo.DOCS_APPLICATION da
                         LEFT JOIN dbo.DC_SOCIALSTATUS ds ON da.AppSosialStatusId = ds.SocialId
                         LEFT JOIN dbo.DC_REPRESENTER dr ON da.AppRepresenterId = dr.RepresenterId
                         LEFT JOIN dbo.DC_COUNTRY dc ON da.AppCountry1Id = dc.CountryId
                         LEFT JOIN dbo.DC_REGION dr2 ON da.AppRegion1Id = dr2.RegionId
                    WHERE da.AppDocId = @docId
                ) s
                ORDER BY s.AppFirstname ASC FOR JSON AUTO
            ) AS JsonApplication,
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
                ORDER BY f.FileIsMain DESC FOR JSON AUTO
            ) AS JsonFileInfo,
            ------------------------------------------------

            (
                SELECT *
                FROM
                (
                    --SELECT r.RelatedDocId AS DocId, 
                    --       d.DocEnterno, 
                    --       d.DocEnterdate, 
                    --       d.DocDocno, 
                    --       d.DocDocdate, 
                    --       d.DocDoctypeId,
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
                    --            WHERE af.AdrDocId = r.RelatedDocId
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
                    --    WHERE af.AdrDocId = d.DocId
                    --          AND af.AdrTypeId = 1
                    --)
                    --       END AS DocumentInfo, 
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
                -- do.OrganizationName AS DocumentInfo, 
                                   d.DocDescription, 
                                   dr.ResultName, 
                                   dd.DocumentstatusName
                            FROM dbo.VW_DOC_INFO d
                                 LEFT JOIN dbo.DOC_RESULT dr ON d.DocResultId = dr.Id
                                 LEFT JOIN dbo.DOC_DOCUMENTSTATUS dd ON d.DocDocumentstatusId = dd.DocumentstatusId
							--	 LEFT JOIN dbo.DOCS_ADDRESSINFO da  ON da.AdrDocId=d.DocId AND da.AdrTypeId=3
							--	 LEFT JOIN dbo.DC_ORGANIZATION do ON da.AdrOrganizationId  = do.OrganizationId
                            WHERE d.DocId IN
                            (
                            (
                                SELECT DISTINCT  dr.RelatedDocId
                                FROM dbo.DOCS_RELATED dr
                                WHERE dr.RelatedDocumentId = @docId
                                      AND dr.RelatedTypeId = 1
                            )
                            )
                                  OR d.DocId IN
                            (
                                SELECT DISTINCT dr.RelatedDocumentId
                                FROM dbo.DOCS_RELATED dr
                                WHERE dr.RelatedDocId = @docId
                                      AND dr.RelatedTypeId = 1
                            )
                ) s FOR JSON AUTO
            ) AS JsonRelatedDocumentInfo, 
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
                           do.OrganizationName AS DocumentInfo, 
                           d.DocDescription, 
                           dr.ResultName, 
                           dd.DocumentstatusName
                    FROM dbo.VW_DOC_INFO d
                         LEFT JOIN dbo.DC_ORGANIZATION do ON d.DocOrganizationId = do.OrganizationId
                         LEFT JOIN dbo.DOC_RESULT dr ON d.DocResultId = dr.Id
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
                ) s FOR JSON AUTO
            ) AS JsonAnswerDocumentInfo, 
            d.DocUndercontrolStatusId AS SupervisionId,
            --Əməliyyat tarixçəsi
            (
                SELECT *
                FROM @OperationHistory
                ORDER BY DirectionDate, 
                         SendStatusId ASC FOR JSON AUTO
            ) AS JsonOperationHistory
            FROM dbo.VW_DOC_INFO d
                 LEFT JOIN dbo.DOC_TOPIC_TYPE dtt ON dtt.TopicTypeId = d.DocTopicType
                 LEFT JOIN dbo.DOC_TOPIC dt ON d.DocTopicId = dt.TopicId
                 LEFT JOIN dbo.DOC_EXECUTIONSTATUS de ON de.ExecutionstatusId = d.DocExecutionStatusId
                 LEFT JOIN dbo.DOC_SENDSTATUS ds ON d.DocSendTypeId = ds.SendStatusId
                 LEFT JOIN dbo.DOC_APPLYTYPE da2 ON da2.ApplytypeId = d.DocApplytypeId
                 LEFT JOIN dbo.DOC_RECEIVED_FORM drf ON d.DocReceivedFormId = drf.ReceivedFormId
                 LEFT JOIN dbo.DOCS_ADDITION da ON d.DocId = da.DocumentId
            WHERE d.docId = @docId
                  AND d.DocDoctypeId = @doctype
        ) s FOR JSON AUTO;

	SET	@newPlanedHistory= stuff((SELECT ','+ format(oh.NewDirectionPlannedDate,'dd.MM.yyyy') from @OperationHistory oh WHERE oh.NewDirectionPlannedDate IS NOT null FOR XML path('')),1,1,'') ----Yeni icra muddeti

    END;
