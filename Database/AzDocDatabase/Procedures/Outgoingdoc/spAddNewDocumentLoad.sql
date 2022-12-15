/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [outgoingdoc].[spAddNewDocumentLoad] @docType     INT = NULL, 
                                                     @workPlaceId INT = 0, 
                                                     @formTypeId  INT = 0, 
                                                     @docId       INT = NULL
AS
    BEGIN
        SET NOCOUNT ON;
        IF(@docId IS NULL)
            BEGIN
                IF(@formTypeId = 0)
                    BEGIN
                        DECLARE @orgId INT;
						    DECLARE @positiongroupId INT;
							SELECT @positiongroupId=dpg.PositionGroupId FROM dbo.DC_WORKPLACE dw
 LEFT JOIN dbo.DC_DEPARTMENT dd ON dd.DepartmentId=dw.WorkplaceDepartmentId
 LEFT JOIN dbo.DC_DEPARTMENT_POSITION ddp ON ddp.DepartmentId=dw.WorkplaceDepartmentId
 LEFT JOIN dbo.DC_POSITION_GROUP dpg ON dpg.PositionGroupId=ddp.PositionGroupId
 WHERE  dw.WorkplaceId=@workplaceID AND  ddp.PositionGroupId IN (37,38)

                        SELECT @orgId =
                        (
                            SELECT [dbo].[fnPropertyByWorkPlaceId](@workPlaceId, 12)
                        );

       SELECT s.FormTypeId, 
                               s.Id, 
                               s.Name
                        FROM
                        (
                        --TypeOfDocument
                        SELECT 1 FormTypeId, 
                               f.FormId Id, 
                               f.FormName Name, 
                               '' AS PositionGroupLevel
                        FROM DOC_FORM f
                        WHERE f.FormId IN
                        (
                            SELECT t.FormId
                            FROM dbo.DOC_FORM_DOCTYPE t
                            WHERE t.DocTypeId = @docType
                                  AND t.FormDocTypeStatus = 1
                        )
                              AND f.FormStatus = 1
                        UNION --SignatoryPerson                        

                        SELECT 2 FormTypeId, 
                               dw.WorkplaceId AS Id, 
                               ISNULL(' ' + dp.PersonnelName, '') + ISNULL(' ' + dp.PersonnelSurname, '') + ISNULL(' ' + dp.PersonnelLastname, '') + ISNULL(' ' + ddp.DepartmentPositionName, '') AS Name, 
                               dpg.PositionGroupLevel
                        FROM dbo.DC_WORKPLACE dw
                             JOIN dbo.DC_USER du ON dw.WorkplaceUserId = du.UserId
                             JOIN dbo.DC_PERSONNEL dp ON du.UserPersonnelId = dp.PersonnelId
                             JOIN dbo.DC_DEPARTMENT_POSITION ddp ON dw.WorkplaceDepartmentPositionId = ddp.DepartmentPositionId
                             JOIN dbo.DC_POSITION_GROUP dpg ON ddp.PositionGroupId = dpg.PositionGroupId
                             JOIN dbo.DC_WORKPLACE_ROLE dwr ON dw.WorkplaceId = dwr.WorkplaceId
                        WHERE dp.PersonnelStatus = 1
                              AND dwr.RoleId = 240
                              AND dw.WorkplaceId IN
                        (
                            SELECT dw.WorkplaceId
                            FROM dbo.DC_WORKPLACE dw
                            WHERE dw.WorkplaceDepartmentId IN
                            (
                                SELECT ddp.DepartmentId
                                FROM dbo.DC_DEPARTMENT_POSITION ddp
                                WHERE ddp.PositionGroupId in (1,2)
                                OR ddp.DepartmentPositionId = 21
                            )
                        )

      UNION
      SELECT 2 FormTypeId, 
                                   dw.WorkplaceId AS Id, 
                                   ISNULL(' ' + dp.PersonnelName, '') + ISNULL(' ' + dp.PersonnelSurname, '') + ISNULL(' ' + dp.PersonnelLastname, '') + ISNULL(' ' + ddp.DepartmentPositionName, '') AS Name, 
                                   dpg.PositionGroupLevel
                            FROM dbo.DC_WORKPLACE dw
                                 JOIN dbo.DC_USER du ON dw.WorkplaceUserId = du.UserId
                                 JOIN dbo.DC_PERSONNEL dp ON du.UserPersonnelId = dp.PersonnelId
                                 JOIN dbo.DC_DEPARTMENT_POSITION ddp ON dw.WorkplaceDepartmentPositionId = ddp.DepartmentPositionId
                                 JOIN dbo.DC_POSITION_GROUP dpg ON ddp.PositionGroupId = dpg.PositionGroupId
                                 JOIN dbo.DC_WORKPLACE_ROLE dwr ON dw.WorkplaceId = dwr.WorkplaceId
                            WHERE dp.PersonnelStatus = 1
                                  AND dwr.RoleId = 240
                                  AND dw.WorkplaceId IN
                            (
                                SELECT dw.WorkplaceId
                                FROM dbo.DC_WORKPLACE dw
                                WHERE dw.WorkplaceDepartmentPositionId IN
                                (
                                    SELECT ddp.DepartmentPositionId
                                    FROM dbo.DC_DEPARTMENT_POSITION ddp
                                    WHERE ddp.PositionGroupId IN
                                    (
                                        SELECT dpg.PositionGroupId
                                        FROM dbo.DC_POSITION_GROUP dpg
                                       WHERE ddp.PositionGroupId in (5, 6, 7)
                                        AND dpg.PositionGroupStatus = 1
                                    )
                                )
                                AND dw.WorkplaceOrganizationId = @orgId
        )
		union
		(  SELECT 2 FormTypeId, 
                               dw.WorkplaceId AS Id, 
                               ISNULL(' ' + dp.PersonnelName, '') + ISNULL(' ' + dp.PersonnelSurname, '') + ISNULL(' ' + dp.PersonnelLastname, '') + ISNULL(' ' + ddp.DepartmentPositionName, '') AS Name, 
                               dpg.PositionGroupLevel
                        FROM dbo.DC_WORKPLACE dw
                             JOIN dbo.DC_USER du ON dw.WorkplaceUserId = du.UserId
                             JOIN dbo.DC_PERSONNEL dp ON du.UserPersonnelId = dp.PersonnelId
                             JOIN dbo.DC_DEPARTMENT_POSITION ddp ON dw.WorkplaceDepartmentPositionId = ddp.DepartmentPositionId
                             JOIN dbo.DC_POSITION_GROUP dpg ON ddp.PositionGroupId = dpg.PositionGroupId
                             JOIN dbo.DC_WORKPLACE_ROLE dwr ON dw.WorkplaceId = dwr.WorkplaceId
                        WHERE dp.PersonnelStatus = 1
                              AND dwr.RoleId = 240
                              AND dw.WorkplaceId=59)
  --------------------AŞ----------- 
  	union
		( SELECT 2 FormTypeId, 
                                   dw.WorkplaceId AS Id, 
                                   ISNULL(' ' + dp.PersonnelName, '') + ISNULL(' ' + dp.PersonnelSurname, '') + ISNULL(' ' + dp.PersonnelLastname, '') + ISNULL(' ' + ddp.DepartmentPositionName, '') AS Name, 
                                   dpg.PositionGroupLevel
                            FROM dbo.DC_WORKPLACE dw
                                 JOIN dbo.DC_USER du ON dw.WorkplaceUserId = du.UserId
                                 JOIN dbo.DC_PERSONNEL dp ON du.UserPersonnelId = dp.PersonnelId
                                 JOIN dbo.DC_DEPARTMENT_POSITION ddp ON dw.WorkplaceDepartmentPositionId = ddp.DepartmentPositionId
                                 JOIN dbo.DC_POSITION_GROUP dpg ON ddp.PositionGroupId = dpg.PositionGroupId
                                 JOIN dbo.DC_WORKPLACE_ROLE dwr ON dw.WorkplaceId = dwr.WorkplaceId
                            WHERE dp.PersonnelStatus = 1
                                  AND dwr.RoleId = 240
                                  AND dw.WorkplaceId IN
                            (
                                SELECT dw.WorkplaceId
                                FROM dbo.DC_WORKPLACE dw
                                WHERE dw.WorkplaceDepartmentPositionId IN
                                (
                                    SELECT ddp.DepartmentPositionId
                                    FROM dbo.DC_DEPARTMENT_POSITION ddp
                                    WHERE ddp.PositionGroupId IN
                                    (
                                        SELECT dpg.PositionGroupId
                                        FROM dbo.DC_POSITION_GROUP dpg
                                       WHERE ddp.PositionGroupId in (37)
                                        AND dpg.PositionGroupStatus = 1 AND @positiongroupId=38
                                    )
                                )
                                AND dw.WorkplaceOrganizationId = @orgId))
	

                        UNION --TypeOfAssignment 
                        SELECT 6 FormTypeId, 
                               s.SendStatusId Id, 
                               s.SendStatusName Name, 
                               '' AS PositionGroupLevel
                        FROM DOC_SENDSTATUS s
                             INNER JOIN dbo.DOC_SENDSTATUS_TYPE st ON s.SendStatusId = st.SendStatusId
                        WHERE st.DocTypeId = @docType
                              AND s.SendStatusStatus = 1
                              AND st.SendTypeStatus = 1                       
                        UNION --SendForm
                        SELECT 3 FormTypeId, 
                               ReceivedFormId AS Id, 
                               ReceivedFormName AS Name, 
                               '' AS PositionGroupLevel
                        FROM DOC_RECEIVED_FORM
                        WHERE ReceivedFormStatus = 1
                        UNION --WhomAddressed
                        SELECT 8 FormTypeId, 
                               WP.WorkplaceId AS Id, 
                               ISNULL(' ' + PE.PersonnelName, '') + ISNULL(' ' + PE.PersonnelSurname, '') + ISNULL(' ' + PE.PersonnelLastname, '') + ISNULL(' ' + DO.DepartmentPositionName, '') AS Name, 
                               '' AS PositionGroupLevel
                        FROM [dbo].DC_WORKPLACE WP
                             INNER JOIN [dbo].DC_USER DU ON WP.WorkplaceUserId = DU.UserId
                             INNER JOIN [dbo].DC_PERSONNEL PE ON DU.UserPersonnelId = PE.PersonnelId
                             INNER JOIN [dbo].DC_DEPARTMENT DP ON WP.WorkplaceDepartmentId = DP.DepartmentId
                             INNER JOIN [dbo].DC_DEPARTMENT_POSITION DO ON WP.WorkplaceDepartmentPositionId = DO.DepartmentPositionId
                        WHERE PE.PersonnelStatus = 1
                              AND (WP.WorkplaceId IN
                        (
                            SELECT WR.WorkplaceId
                            FROM [dbo].DC_WORKPLACE_ROLE WR
                            WHERE WR.RoleId = 240
                        )
                                   OR (WP.WorkplaceId IN
                        (
                        (
                            SELECT WP.WorkplaceId
                            FROM DC_WORKPLACE WP
                            WHERE WP.WorkplaceDepartmentPositionId IN
                            (
                                SELECT dp.DepartmentPositionId
                                FROM DC_DEPARTMENT_POSITION dp
                                WHERE dp.PositionGroupId IN(1, 2, 3, 33, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15, 17, 18, 19)
                            )
                            AND WP.WorkplaceOrganizationId = @orgId
                        )
                        )))
                        UNION
       SELECT 4 FormTypeId, 
                                   dw.WorkplaceId AS Id, 
                                   ISNULL(' ' + dp.PersonnelName, '') + ISNULL(' ' + dp.PersonnelSurname, '') + ISNULL(' ' + dp.PersonnelLastname, '') + ISNULL(' ' + ddp.DepartmentPositionName, '') AS Name, 
                                   dpg.PositionGroupLevel
                            FROM dbo.DC_WORKPLACE dw
                                 JOIN dbo.DC_USER du ON dw.WorkplaceUserId = du.UserId
                                 JOIN dbo.DC_PERSONNEL dp ON du.UserPersonnelId = dp.PersonnelId
                                 JOIN dbo.DC_DEPARTMENT_POSITION ddp ON dw.WorkplaceDepartmentPositionId = ddp.DepartmentPositionId
                                 JOIN dbo.DC_POSITION_GROUP dpg ON ddp.PositionGroupId = dpg.PositionGroupId
                            WHERE dp.PersonnelStatus = 1
                                  AND dw.WorkplaceId IN
                            (
                                SELECT dw.WorkplaceId
                                FROM dbo.DC_WORKPLACE dw
                                WHERE dw.WorkplaceDepartmentPositionId IN
                                (
                                    SELECT ddp.DepartmentPositionId
                                    FROM dbo.DC_DEPARTMENT_POSITION ddp
                                    WHERE ddp.PositionGroupId IN
                                    (
                                        SELECT dpg.PositionGroupId
                                        FROM dbo.DC_POSITION_GROUP dpg
                                        WHERE dpg.PositionGroupId IN(1, 2, 17, 33)
                                    )
                                )
                                AND (dw.WorkplaceOrganizationId = @orgId
                                     OR dw.WorkplaceOrganizationId = (CASE
                                                                          WHEN @orgId != 1
                                                                          THEN 1
                                                                          ELSE-1
                                                                      END))
                            )
                            UNION
                            SELECT 4 FormTypeId, 
                                   dw.WorkplaceId AS Id, 
                                   ISNULL(' ' + dp.PersonnelName, '') + ISNULL(' ' + dp.PersonnelSurname, '') + ISNULL(' ' + dp.PersonnelLastname, '') + ISNULL(' ' + ddp.DepartmentPositionName, '') AS Name, 
                                   dpg.PositionGroupLevel
                            FROM dbo.DC_WORKPLACE dw
                                 JOIN dbo.DC_USER du ON dw.WorkplaceUserId = du.UserId
                                 JOIN dbo.DC_PERSONNEL dp ON du.UserPersonnelId = dp.PersonnelId
                                 JOIN dbo.DC_DEPARTMENT_POSITION ddp ON dw.WorkplaceDepartmentPositionId = ddp.DepartmentPositionId
                                 JOIN dbo.DC_POSITION_GROUP dpg ON ddp.PositionGroupId = dpg.PositionGroupId
                            WHERE dp.PersonnelStatus = 1
                                  AND dw.WorkplaceId IN
                            (
                                SELECT dw.WorkplaceId
                                FROM dbo.DC_WORKPLACE dw
                                WHERE dw.WorkplaceDepartmentPositionId IN
                                (
                                    SELECT ddp.DepartmentPositionId
                                    FROM dbo.DC_DEPARTMENT_POSITION ddp
                                    WHERE ddp.PositionGroupId IN
                                    (
                                        SELECT dpg.PositionGroupId
                                        FROM dbo.DC_POSITION_GROUP dpg
                                        WHERE dpg.PositionGroupId IN(1, 2, 33, 5)
                                    )
                                )
                            )
                            UNION--InfoPerson
                        SELECT 9 FormTypeId, 
                               dr.Id AS Id, 
                               dr.ResultName AS Name,
          '' AS PositionGroupLevel
                        FROM dbo.DOC_RESULT dr
                        WHERE dr.ResultStatus = 1
      ) s
      ORDER BY s.PositionGroupLevel ASC;
                END;
                    ELSE
                    IF(@formTypeId = 6) --RelatedDocument
                        BEGIN
						 SELECT *
                            FROM
                            (
                                SELECT d.DocId, 
                                       d.DocEnterno, 
                                       (CONCAT(da.AppFirstname, SPACE(1), da.AppSurname, SPACE(1), da.AppLastname) + ' ' +
                                (
                                    SELECT [dbo].[fnGetApplicantAddress](da.AppDocId)
                                )) DocumentInfo
                                FROM dbo.DOCS d
                                     INNER JOIN dbo.DOCS_APPLICATION da ON d.DocId = da.AppDocId
                            ) sub
                            WHERE sub.DocumentInfo IS NOT NULL;
                            --SELECT *
                            --FROM
                            --(
                            --    SELECT d.DocId, 
                            --           d.DocEnterno,
                            --           CASE
                            --               WHEN d.DocDoctypeId = 1
                            --                    OR d.DocDoctypeId = 2
                            --               THEN(
                            --    (
                            --        SELECT STUFF(
                            --        (
                            --            SELECT ' ' + OrganizationName
                            --            FROM DC_ORGANIZATION o
                            --            WHERE o.OrganizationId IN
                            --            (
                            --                SELECT af.AdrOrganizationId
                            --                FROM DOCS_ADDRESSINFO af
                            --                WHERE af.AdrDocId = d.DocId
                            --                      AND af.AdrTypeId = 3
                            --                      AND af.AdrAuthorId IS NOT NULL
                            --            ) FOR XML PATH('')
                            --        ), 1, 1, '')
                            --    ) + ' , ' +
                            --    (
                            --        SELECT STUFF(
                            --        (
                            --            SELECT(a.AuthorName + ' ' + a.AuthorSurname + ' ' + ISNULL(a.AuthorLastname, ''))
                            --            FROM dbo.DOC_AUTHOR a
                            --            WHERE a.AuthorId IN
                            --            (
                            --                SELECT af.AdrAuthorId
                            --                FROM DOCS_ADDRESSINFO af
                            --                WHERE af.AdrDocId = d.DocId
                            --                      AND af.AdrTypeId = 3
                            --                      AND af.AdrAuthorId IS NOT NULL
                            --            ) FOR XML PATH('')
                            --        ), 1, 0, '')
                            --    ))
                            --               WHEN d.DocDoctypeId = 18
                            --               THEN
                            --    (
                            --        SELECT af.FullName
                            --        FROM dbo.DOCS_ADDRESSINFO af
                            --        WHERE af.AdrDocId = @docId
                            --              AND af.AdrTypeId = 1
                            --    )
                            --           END AS DocumentInfo
                            --    FROM dbo.DOCS d
                            --         INNER JOIN dbo.DOCS_APPLICATION da ON d.DocId = da.AppDocId
                            --) sub
                            --WHERE sub.DocumentInfo IS NOT NULL;
                    END;
                        ELSE
                        IF(@formTypeId = 9)--Result
                            BEGIN
                                SELECT dr.Id AS ResultId, 
                                       dr.ResultName
                                FROM dbo.DOC_RESULT dr
                                WHERE dr.ResultStatus = 1;
                        END;
                IF(@formTypeId = 8) --WhomAddressed
                    BEGIN
                        SELECT a.AuthorId, 
                               a.AuthorOrganizationId, 
                               o.OrganizationName, 
                               (a.AuthorName + ' ' + a.AuthorSurname + ' ' + a.AuthorName) FullName, 
                               a.AuthorDepartmentname AuthorDepartmentName, 
                               p.PositionName
                        FROM dbo.DOC_AUTHOR a
                             INNER JOIN dbo.DC_ORGANIZATION o ON a.AuthorOrganizationId = o.OrganizationId
                             INNER JOIN dbo.DC_POSITION p ON p.PositionId = a.AuthorPositionId;
                END;
        END;
            ELSE
            IF(@docId IS NOT NULL)
                BEGIN
                    IF(@formTypeId = 1)
                        BEGIN
                            SELECT *
                            FROM
                            (
                                SELECT d.DocId, 
                                       d.DocFormId AS TypeOfDocumentId, 
                                (
                                    SELECT TOP 1 a.AdrPersonId
                                    FROM DOCS_ADDRESSINFO a
                                    WHERE a.AdrDocId = @docId
                                          AND a.AdrTypeId = 1
                                ) AS SignatoryPersonId, --iki defe insert gedib 
                                (
                                    SELECT TOP 1 a.AdrPersonId
                                    FROM DOCS_ADDRESSINFO a
                                    WHERE a.AdrDocId = @docId
                                          AND a.AdrTypeId = 2
                                ) AS ConfirmingPersonId, 
                                       d.DocDescription AS ShortContent, 
                                       d.DocReceivedFormId AS SendFormId, 
                                       DocDocdate AS DocEnterDate, --migrate3 redakte zamani qeydiyyat tarifi yox layihenin tarixi getirilir

                                (
                                    SELECT *
                                    FROM
                                    (
                                        SELECT af.AdrId AuthorId, 
                                               a.AuthorOrganizationId, 
                                               o.OrganizationName, 
                                               (a.AuthorName + ' ' + a.AuthorSurname + ' ' + a.AuthorName) FullName, 
                                               a.AuthorDepartmentname AuthorDepartmentName, 
                                               p.PositionName, 
                                               af.AuthorPrevOrganization AS PrevOrganization
                                        FROM dbo.DOC_AUTHOR a
                                             LEFT JOIN dbo.DC_ORGANIZATION o ON a.AuthorOrganizationId = o.OrganizationId
                                             LEFT JOIN dbo.DC_POSITION p ON p.PositionId = a.AuthorPositionId
                                             LEFT JOIN dbo.DOCS_ADDRESSINFO af ON a.AuthorId = af.AdrAuthorId
                                        WHERE af.AdrDocId = @docId
                                              AND af.AdrAuthorId IS NOT NULL
                                    ) s FOR JSON AUTO
                                ) AS AuthorModels, 
                                (
                                    SELECT *
                                    FROM
                                    (
                                        SELECT r.RelatedId, d.DocId, 
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
            WHEN d.DocDoctypeId = 18 THEN ---------------- 
            (select af.FullName from dbo.DOCS_ADDRESSINFO af where af.AdrDocId=@docId and af.AdrTypeId=1)

                                                       END AS  DocumentInfo, 
                                               d.DocDescription
                                        FROM dbo.DOCS d
                                             LEFT JOIN dbo.DOCS_RELATED r ON d.DocId = r.RelatedDocumentId
                                             LEFT JOIN dbo.DC_ORGANIZATION do ON d.DocOrganizationId = do.OrganizationId
                                        WHERE r.RelatedDocId = @docId
                                              AND r.RelatedTypeId = 1
                                    ) s FOR JSON AUTO
                                ) AS RelatedDocModels,
         (
                                    SELECT
                                    (
                                        SELECT *
                                        FROM
                                        (
                                            SELECT d.DocId, 
                                                   d.DocEnterno, 
                                                   d.DocEnterdate, 
                                                   do.OrganizationName AS DocumentInfo, 
                                                   d.DocDescription, 
                                                   d.DocDoctypeId, 
                                                   d.DocResultId AS ResultId
                                            FROM dbo.DOCS d
                                                 LEFT JOIN dbo.DC_ORGANIZATION do ON d.DocOrganizationId = do.OrganizationId
                                            WHERE d.DocId IN
                                            (
                                                SELECT dr.RelatedDocumentId
                                                FROM dbo.DOCS_RELATED dr
                                                WHERE dr.RelatedDocId = @docId
                                                      AND dr.RelatedTypeId = 2
                                            )
                                        ) s FOR JSON AUTO
                                    )
                                ) AS AnswerByOutDocModels,      -----
                                (SELECT *
                                    FROM
                                    (
                                        SELECT dt.WhomAddressId, 
                                               dt.TypeOfAssignmentId, 
                                        (
                                            SELECT [dbo].[fnGetPersonnelbyWorkPlaceId](dt.WhomAddressId, 106) + ' ' +
                                            (
                                                SELECT [dbo].[fnGetPersonPositionName](dt.WhomAddressId)
                                            )
                                        ) AS WhomAddress, 
                                        (
                                            SELECT s.SendStatusName Name
                                            FROM DOC_SENDSTATUS s
                                            WHERE s.SendStatusId = dt.TypeOfAssignmentId
                                        ) AS TypeOfAssignment
                                        FROM dbo.DOC_TASK dt
                                        WHERE dt.TaskDocId = @docId
                                    ) s FOR JSON AUTO
                                ) AS JsonWhomAddress
                                FROM dbo.DOCS d
                                     INNER JOIN dbo.DOCS_ADDRESSINFO ad ON d.DocId = ad.AdrDocId
                                WHERE d.DocId = @docId
                                      AND ad.AdrAuthorId IS NULL
                            ) s FOR JSON AUTO;
                    END;
                        ELSE
                        IF(@formTypeId = 2) -- AnswerByOutgoing
                            BEGIN
                                SELECT *
                                FROM
                                (
                                    SELECT
                                    (
                                        SELECT *
                                        FROM
                                        (
                                            SELECT d.DocId, 
                                                   d.DocEnterno, 
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
            WHEN d.DocDoctypeId = 18 THEN  
            (select af.FullName from dbo.DOCS_ADDRESSINFO af where af.AdrDocId=@docId and af.AdrTypeId=1)

                                                       END AS  DocumentInfo,
													   d.DocDoctypeId
                                            FROM dbo.DOCS d
                                                 LEFT JOIN dbo.DC_ORGANIZATION do ON d.DocOrganizationId = do.OrganizationId
                                            WHERE d.DocId = @docId
                                        ) s FOR JSON AUTO
                                    ) AS AnswerByOutDocModels
         -- (
                                --    SELECT *
                                --    FROM
                                --    (
                                --        SELECT af.AdrAuthorId AuthorId, ----------xaric olan senedle cavabl;a hali ucun adrauthorid-yazilmalidi
                                --               a.AuthorOrganizationId, 
                                --               o.OrganizationName, 
                                --               (a.AuthorName + ' ' + a.AuthorSurname + ' ' + a.AuthorName) FullName, 
                                --               a.AuthorDepartmentname AuthorDepartmentName, 
                                --               p.PositionName, 
                                --               af.AuthorPrevOrganization AS PrevOrganization
                                --        FROM dbo.DOC_AUTHOR a
                                --             INNER JOIN dbo.DC_ORGANIZATION o ON a.AuthorOrganizationId = o.OrganizationId
                                --             INNER JOIN dbo.DC_POSITION p ON p.PositionId = a.AuthorPositionId
                                --             INNER JOIN dbo.DOCS_ADDRESSINFO af ON a.AuthorId = af.AdrAuthorId
                                --        WHERE af.AdrDocId = @docId
                                --              AND af.AdrAuthorId IS NOT NULL
                                --    ) s FOR JSON AUTO
                                --) AS AuthorModels 
                                    FROM dbo.DOCS d
                                    WHERE d.DocId = @docId
                                ) s FOR JSON AUTO;
                        END;
                            ELSE
                            IF(@formTypeId = 3) -- RelateDocumentByOutgoing
                                BEGIN
                                    SELECT *
                                    FROM
                                    (
                                        SELECT
                                        (
                                            SELECT *
                                            FROM
                                            (
                                                SELECT d.DocId, 
                                                       d.DocEnterno,
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
                                                           WHEN d.DocDoctypeId = 18
                                                           THEN
                                                (
                                                    SELECT af.FullName
                                                    FROM dbo.DOCS_ADDRESSINFO af
                                                    WHERE af.AdrDocId = @docId
                                                          AND af.AdrTypeId = 1
                                                )
                                                       END AS DocumentInfo
                                                FROM dbo.DOCS d
                                                     LEFT JOIN dbo.DC_ORGANIZATION do ON d.DocOrganizationId = do.OrganizationId
                                                WHERE d.DocId = @docId
                                            ) s FOR JSON AUTO
                                        ) AS RelatedDocumentByOutDocModels
                                        FROM dbo.DOCS d
                                        WHERE d.DocId = @docId
                                    ) s FOR JSON AUTO;
                            END;
            END;
    END;

