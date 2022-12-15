
/*
Migrated by Kamran A-eff 23.08.2019
*/
/*
Migrated by Kamran A-eff 06.08.2019
*/
/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [outgoingdoc].[spGetDocView] @docId       INT, 
                                             @docType     INT, 
                                             @workPlaceId INT
AS
    BEGIN
        IF NOT EXISTS
        (
            SELECT d.DocId
            FROM dbo.DOCS d
            WHERE d.DocId = @docId
        )
            THROW 56000, 'Mövcud sənəd tapılmadı', 1;
        DECLARE @executorCount INT, @docIndex NVARCHAR(MAX), @docEnterNo NVARCHAR(MAX);
        SELECT @docIndex = SUBSTRING(d.DocEnterno, CHARINDEX('-', d.DocEnterno) + 1, LEN(d.DocEnterno))
        FROM dbo.docs d
        WHERE d.DocId = @docId;
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
         SendStatusId        INT
        );
		EXEC sp_set_session_context 'docId', @docId; 
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
				 SendStatusId
                )
                       SELECT dbo.fnGetPersonnelbyWorkPlaceId(dol.SenderWorkPlaceId, 106) AS PersonFrom, 
                              dbo.fnGetPersonnelbyWorkPlaceId(dol.ReceiverWorkPlaceId, 106) AS PersonTo, 
                              dot.TypeName AS ExecutorMain, 
                              dol.OperationDate AS DirectionDate, 
                              dos.StatusName AS STATUS, 
                              dol.OperationStatusDate AS StatusDate, 
                              dol.OperationNote AS ExecutorResolutionNote ,
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
                                  SELECT vdv.* FROM dbo.VW_DOC_OLD_LASTNEW  vdv WHERE vdv.DocId=@docId
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
                                   SELECT vdol.* FROM dbo.VW_DOC_OLD_LAST vdol  WHERE vdol.DocId=@docId
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
            d.DocEnterno AS DocEnterNo,
            CASE
                WHEN d.DocEnterdate IS NOT NULL
                THEN d.DocEnterdate
                ELSE d.DocDocDate
            END AS DocEnterDate, 
            d.DocDocno AS DocDocNo, 
            d.DocDocumentstatusId DocDocumentStatusId, 
            
			(
                        SELECT dd.DocumentstatusName
                        FROM dbo.DOC_DOCUMENTSTATUS dd
                        WHERE dd.DocumentstatusId = d.DocDocumentstatusId
                    ) AS DocumentStatusName, -- senedin statusu  

           (
                 SELECT STUFF(
                        (
                            SELECT ';' + OrganizationName
                            FROM dbo.DC_ORGANIZATION o
                            WHERE o.OrganizationId IN
                            (
                                 SELECT af.AdrOrganizationId
                    FROM dbo.DOCS_ADDRESSINFO af
                    WHERE af.AdrDocId = d.DocId
                          AND af.AdrTypeId = 3
                            ) FOR XML PATH('')
                        ), 1, 1, '')
            ) AS SendTo, -- hara unvanlanib     
            (
              	 SELECT STUFF(
                        (
							SELECT ';'+ ((a.AuthorName + ' ' + a.AuthorSurname + ' ' + ISNULL(a.AuthorLastname, '')) + ',' + ' ' + ISNULL(p.PositionName,'') + ' ')
							FROM dbo.DOC_AUTHOR a
							     LEFT JOIN dbo.DC_ORGANIZATION o ON a.AuthorOrganizationId = o.OrganizationId
							     LEFT JOIN dbo.DC_DEPARTMENT dd ON dd.DepartmentId = a.AuthorDepartmentId
							     LEFT JOIN dbo.DC_POSITION p ON p.PositionId = a.AuthorPositionId
							WHERE a.AuthorId IN
							            (
							                    SELECT af.AdrAuthorId
												FROM dbo.DOCS_ADDRESSINFO af
												WHERE af.AdrDocId = d.DocId
												      AND af.AdrTypeId IN(1, 3)
													   AND af.AdrAuthorId IS NOT NULL
                            ) FOR XML PATH('')
                        ), 1, 1, '')
            ) AS ConfirmPerson, -- kime unvanlanib 
            dbo.GET_ADDRESSINFO(@docId, 1, 1) AS Signer, 
            drf.ReceivedFormName AS SendForm, -- gonderilmeformasi ,
            (
                SELECT OrganizationName
                FROM dbo.DC_ORGANIZATION
                WHERE OrganizationId =
                (
                    SELECT af.AdrOrganizationId
                    FROM dbo.DOCS_ADDRESSINFO af
                    WHERE af.AdrDocId = d.DocId
                          AND af.AdrTypeId = 2
                          AND af.AdrAuthorId IS NULL
                )
            ) AS SendToWhere, -- hara unvanlanib
			(
              	 SELECT STUFF(
                        ( SELECT                          
                               ISNULL(' ' + PE.PersonnelName, '') + ISNULL(' ' + PE.PersonnelSurname, '') + ISNULL(' ' + PE.PersonnelLastname, '') + ISNULL(' ' + DO.DepartmentPositionName, '')  
                           
                        FROM [dbo].DC_WORKPLACE WP
                             INNER JOIN [dbo].DC_USER DU ON WP.WorkplaceUserId = DU.UserId
                             INNER JOIN [dbo].DC_PERSONNEL PE ON DU.UserPersonnelId = PE.PersonnelId
                             INNER JOIN [dbo].DC_DEPARTMENT DP ON WP.WorkplaceDepartmentId = DP.DepartmentId
                             INNER JOIN [dbo].DC_DEPARTMENT_POSITION DO ON WP.WorkplaceDepartmentPositionId = DO.DepartmentPositionId
                        WHERE PE.PersonnelStatus = 1
                              AND (WP.WorkplaceId  IN (SELECT WhomAddressId FROM dbo.DOC_TASK dt WHERE dt.TaskDocId=d.DocId)) FOR XML PATH('')
                        ), 1, 1, '')
            ) AS WhomAddress, -- kime unvanlanib məlumat(lazimdir)
			(
              	 SELECT STUFF(
                        (
							SELECT ';'+ ((a.AuthorEmail) +  ' ' )
							FROM dbo.DOC_AUTHOR a
							     LEFT JOIN dbo.DC_ORGANIZATION o ON a.AuthorOrganizationId = o.OrganizationId
							     LEFT JOIN dbo.DC_DEPARTMENT dd ON dd.DepartmentId = a.AuthorDepartmentId
							     LEFT JOIN dbo.DC_POSITION p ON p.PositionId = a.AuthorPositionId
							WHERE a.AuthorId IN
							            (
							                    SELECT af.AdrAuthorId
												FROM dbo.DOCS_ADDRESSINFO af
												WHERE af.AdrDocId = d.DocId
												      AND af.AdrTypeId IN(1, 3)
													   AND af.AdrAuthorId IS NOT NULL
                            ) FOR XML PATH('')
                        ), 1, 1, '')
            ) AS SentAddress,  -- gonderilen unvan
            df.FormName AS DocumentKind, --Senedin novu  
            ---------------------------------------------------------------
            d.DocDescription AS Description, --Sənədin qısa məzmunu
            ------Əvvəlki müraciətlər------ 
            (
                SELECT d.DocId, 
                       d.DocEnterno
                FROM dbo.VW_DOC_INFO d
                WHERE d.DocEnterno LIKE '' +
                (
                    SELECT @docEnterNo
                ) + '%'
                      AND d.DocId <> @docId FOR JSON AUTO
            ) AS JsonPreviosRequests, 
            (
                SELECT COUNT(0)
                FROM dbo.VW_DOC_INFO d
                WHERE d.DocEnterno LIKE '' +
                (
                    SELECT @docEnterNo
                ) + '%'
                      AND d.DocId <> @docId
            ) AS PreviosRequestsCount,
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
                ) s FOR JSON AUTO
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
                      --AND f.FileVisaStatus <> 0
					  AND f.IsReject=0
                ORDER BY f.FileIsMain DESC FOR JSON AUTO
            ) AS JsonFileInfo,
            ------------------------------------------------
            (
                SELECT *
                FROM
                (
                    --SELECT d.DocId, 
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
                    --        FROM dbo.DC_ORGANIZATION o
                    --        WHERE o.OrganizationId IN
                    --        (
                    --            SELECT af.AdrOrganizationId
                    --            FROM dbo.DOCS_ADDRESSINFO af
                    --            WHERE af.AdrDocId = d.DocId
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
                    --            FROM dbo.DOCS_ADDRESSINFO af
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
                    --FROM dbo.VW_DOC_INFO d
                    --     LEFT JOIN dbo.DOCS_RELATED r ON d.DocId = r.RelatedDocumentId
                    --     LEFT JOIN dbo.DC_ORGANIZATION do ON d.DocOrganizationId = do.OrganizationId
                    --     LEFT JOIN dbo.DOCS_APPLICATION da ON d.DocId = da.AppDocId
                    --WHERE r.RelatedDocId = @docId
                    --      AND r.RelatedTypeId = 1

				 SELECT d.DocId, 
                       CASE WHEN  d.DocEnterno IS NOT NULL THEN d.DocEnterno ELSE d.DocDocno END DocEnterno,
					   CASE WHEN  d.DocEnterdate IS NOT NULL THEN d.DocEnterdate ELSE d.DocDocdate END DocEnterdate,  
                       
                  (
                    SELECT STUFF(
                    (
                        SELECT ' ' + OrganizationName +','
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
                ) AS DocumentInfo, 
                       d.DocDescription, 
                       dd.DocumentstatusName
                FROM dbo.VW_DOC_INFO d
                     LEFT JOIN dbo.DC_ORGANIZATION do ON d.DocOrganizationId  = do.OrganizationId
                     LEFT JOIN dbo.DOC_DOCUMENTSTATUS dd ON d.DocDocumentstatusId = dd.DocumentstatusId
                WHERE d.DocId IN
                
                (
                    SELECT dr.RelatedDocId
                    FROM dbo.DOCS_RELATED dr
                    WHERE dr.RelatedDocumentId = @docId
                          AND dr.RelatedTypeId = 1
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
            ------------------------------------------------
            (
                SELECT *
                FROM
                (
                    SELECT d.DocId, 
                           d.DocEnterno, 
                           d.DocEnterdate,
                           CASE
                               WHEN d.DocDoctypeId = 1
                                    OR d.DocDoctypeId = 2
                               THEN(
                    (
                        SELECT STUFF(
                        (
                            SELECT ' ' + OrganizationName
                            FROM dbo.DC_ORGANIZATION o
                            WHERE o.OrganizationId IN
                            (
                                SELECT af.AdrOrganizationId
                                FROM dbo.DOCS_ADDRESSINFO af
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
                                FROM dbo.DOCS_ADDRESSINFO af
                                WHERE af.AdrDocId = d.DocId
                                      AND af.AdrTypeId = 3
                                      AND af.AdrAuthorId IS NOT NULL
                            ) FOR XML PATH('')
                        ), 1, 0, '')
                    ))
                               WHEN d.DocDoctypeId = 18
                               THEN
                    (
                        SELECT af.FullName
                        FROM dbo.DOCS_ADDRESSINFO af
                        WHERE af.AdrDocId = @docId
                              AND af.AdrTypeId = 1
                    )
                           END AS DocumentInfo, 
                           -- do.OrganizationName 
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
            -----------------------------------------------
            --Əməliyyat tarixçəsi
            (
                SELECT *
                FROM @OperationHistory
                ORDER BY DirectionDate,SendStatusId FOR JSON AUTO
            ) AS JsonOperationHistory
            FROM dbo.VW_DOC_INFO d
                 LEFT JOIN dbo.DOC_TOPIC_TYPE dtt ON dtt.TopicTypeId = d.DocTopicType
                 LEFT JOIN dbo.DOC_TOPIC dt ON d.DocTopicId = dt.TopicId
                 LEFT JOIN dbo.DOC_EXECUTIONSTATUS de ON de.ExecutionstatusId = d.DocExecutionStatusId
                 LEFT JOIN dbo.DOC_FORM df ON d.DocFormId = df.FormId
                 LEFT JOIN dbo.DOC_RECEIVED_FORM drf ON d.DocReceivedFormId = drf.ReceivedFormId
                 LEFT JOIN dbo.DOCS_ADDITION da ON d.DocId = da.DocumentId
            WHERE d.docId = @docId
                  AND d.DocDoctypeId = @doctype
        ) s FOR JSON AUTO;
    END;

