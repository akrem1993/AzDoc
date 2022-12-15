/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/


/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [smdo].[spAddNewDocumentLoad] @docType     INT = NULL, 
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
                        SELECT @orgId =
                        (
                            SELECT [dbo].[fnPropertyByWorkPlaceId](@workPlaceId, 12)
                        );
                        SELECT s.FormTypeId, 
                               s.Id, 
                               s.Name
                        FROM
                        (
                            SELECT 3 FormTypeId, 
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
                                    WHERE ddp.PositionGroupId IN(1, 2, 36)
                                )
                            )
                            UNION
                            SELECT 3 FormTypeId, 
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
                                SELECT dbo.fnGetDepartmentChief(@workPlaceId) AS WorkplaceId
                            )
                                 AND dw.WorkplaceOrganizationId = @orgId
                            UNION
                            SELECT 3 FormTypeId, 
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
                                SELECT dbo.fnGetDepartmentChief(@workPlaceId) AS WorkplaceId
                            )
                            UNION
                            SELECT 3 FormTypeId, 
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
                                        WHERE dpg.PositionGroupId IN(5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20)
                                        AND dpg.PositionGroupStatus = 1
                                    )
                                )
                                AND dw.WorkplaceOrganizationId = @orgId
                            )
                            UNION --ConfirmingPerson  
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
                                        WHERE dpg.PositionGroupId IN(1, 2, 33)
                                    )
                                )
                                AND dw.WorkplaceOrganizationId = @orgId
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
                                  AND (dw.WorkplaceId IN
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
                                        WHERE dpg.PositionGroupId IN(1, 2, 33)
                                    )
                                )
                            )
                            OR dw.WorkplaceId IN
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
                                        WHERE dpg.PositionGroupId IN(5)
                                    )
                                )
                                AND dw.WorkplaceOrganizationId = @orgId
                                AND dw.WorkplaceOrganizationId <> 1
                            ))
                            UNION
                            SELECT 3 FormTypeId, 
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
                                        WHERE dpg.PositionGroupId IN(5)
                                    )
                                )
                            )
                            UNION --ExecutionStatus 
                            SELECT 5 FormTypeId, 
                                   s.SendStatusId Id, 
                                   s.SendStatusName Name, 
                                   '' AS PositionGroupLevel
                            FROM DOC_SENDSTATUS s
                                 INNER JOIN dbo.DOC_SENDSTATUS_TYPE st ON s.SendStatusId = st.SendStatusId
                            WHERE st.DocTypeId = 18
                            UNION --WhomAddressed
                            SELECT 2 FormTypeId, 
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
                            SELECT 2 FormTypeId, 
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
                                        WHERE dpg.PositionGroupId IN(1 ,2, 33, 5)
                                    )
                                )
                            )
                            UNION
                            SELECT 7 FormTypeId, 
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
                                FROM dbo.VW_DOC_INFO d
                                     INNER JOIN dbo.DOCS_APPLICATION da ON d.DocId = da.AppDocId
                            ) sub
                            WHERE sub.DocumentInfo IS NOT NULL;
                    END;
                        ELSE
                        IF(@formTypeId = 7) --ResultModel
                            BEGIN
                                SELECT dr.Id AS ResultId, 
                                       dr.ResultName
                                FROM dbo.DOC_RESULT dr
                                WHERE dr.ResultStatus = 1;
                        END;
        END;
            ELSE
            IF(@docId IS NOT NULL)
                BEGIN
                    IF(@formTypeId = 1)
                        BEGIN
                            SELECT  *
                            FROM
                            (
                                SELECT d.DocId, 
                                       d.DocEnterdate AS DocEnterDate, 
                                (
                                    SELECT a.AdrPersonId
                                    FROM DOCS_ADDRESSINFO a
                                    WHERE a.AdrDocId = @docId
                                          AND a.AdrTypeId = 1
                                ) AS SignatoryPersonId, 
                                (
                                    SELECT a.AdrPersonId
                                    FROM DOCS_ADDRESSINFO a
                                    WHERE a.AdrDocId = @docId
                                          AND a.AdrTypeId = 2
                                ) AS ConfirmingPersonId, 
                                       d.DocPlannedDate AS PlannedDate, 
                                       d.DocDescription AS ShortContent, 
                                (
                                    SELECT *
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
                                ) AS JsonWhomAddress, 
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
                                               END AS DocumentInfo, 
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
                                ) AS AnswerByLetterModels
                                FROM dbo.DOCS d
                                     INNER JOIN dbo.DOCS_ADDRESSINFO ad ON d.DocId = ad.AdrDocId
                                WHERE d.DocId = @docId
                                      AND ad.AdrAuthorId IS NULL
                            ) s FOR JSON AUTO;
                    END;
                        ELSE
                        IF(@formTypeId = 2) -- AnswerByLetter
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
												   d.DocDoctypeId
                                            FROM dbo.DOCS d
                                                 LEFT JOIN dbo.DC_ORGANIZATION do ON d.DocOrganizationId = do.OrganizationId
                                            WHERE d.DocId = @docId
                                        ) s FOR JSON AUTO
                                    ) AS AnswerByLetterModels
                                    FROM dbo.DOCS d
                                    WHERE d.DocId = @docId
                                ) s FOR JSON AUTO;
                        END;
                            ELSE
                            IF(@formTypeId = 3) -- RelateDocumentByServiceLetter
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
                                                           WHEN d.DocDoctypeId = 3
                                                                OR d.DocDoctypeId = 18
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
                                        ) AS RelateDocumentByServiceLetterModels
                                        FROM dbo.DOCS d
                                        WHERE d.DocId = @docId
                                    ) s FOR JSON AUTO;
                            END;
            END;
    END;

