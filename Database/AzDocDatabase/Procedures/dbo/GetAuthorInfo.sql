/*
Migrated by Kamran A-eff 23.08.2019
*/


/*
Migrated by Kamran A-eff 06.08.2019
*/
/*
Migrated by Kamran A-eff 11.07.2019
*/

-- Alter Procedure GetAuthorInfo
-- =============================================
-- Author:  Ahmadov Rufin
-- Create date: 17.05.2019
-- Description: Get Json Data
-- =============================================
CREATE PROCEDURE [dbo].[GetAuthorInfo] @data        NVARCHAR(MAX), 
                                      @next        INT, 
                                      @workPlaceId INT           = NULL, 
                                      @docTypeId   INT           = NULL
AS
    BEGIN

        -- row sayini qaytarmir(@@ROWCOUNT)
        SET NOCOUNT OFF;
        DECLARE @upperData NVARCHAR(MAX);
        SET @upperData = UPPER(trim(@data));

        IF(@next = 1)  -- muellifi getirir
            BEGIN
                SELECT DISTINCT 
                       do.OrganizationName AS [FullName], 
                       do.OrganizationId AS [AuthorId]
                FROM dbo.DC_ORGANIZATION do
                WHERE do.OrganizationName LIKE N'%' + @data + '%';
                RETURN;
        END;

        IF(@next = 2) -- shobeleri getirir
            BEGIN
                SELECT DISTINCT 
                       dd.DepartmentName AS [FullName], 
                       dd.DepartmentId AS [AuthorId]
                FROM dbo.DC_DEPARTMENT dd
                WHERE dd.DepartmentName LIKE N'%' + @data + '%';
                RETURN;
        END;

        IF(@next = 3)  -- vezifeleri getirecek
            BEGIN
                SELECT DISTINCT 
                       DP.PositionName AS [FullName], 
                       DP.PositionId AS [AuthorId]
                FROM dbo.DC_POSITION DP
                WHERE DP.PositionName LIKE N'%' + @data + '%';
                RETURN;
        END;

        IF(@next = 4) -- muellifleri tapib qaytaracaq  
            BEGIN
                SELECT *
                FROM
                (
                    SELECT a.AuthorId, 
                           a.AuthorOrganizationId, 
                           o.OrganizationName, 
                           (trim(a.AuthorName) +' '+trim(a.AuthorSurname)+ (CASE WHEN a.AuthorLastname IS NULL THEN '' ELSE ' '+trim(a.AuthorLastname) end)) AS [FullName], --a.AuthorName,Ibrahimov Resid 
                           dd.DepartmentName AuthorDepartmentName, 
                           p.PositionName
                    FROM dbo.DOC_AUTHOR a
                         INNER JOIN dbo.DC_ORGANIZATION o ON a.AuthorOrganizationId = o.OrganizationId
                         LEFT JOIN dbo.DC_DEPARTMENT dd ON dd.DepartmentId = a.AuthorDepartmentId
                         LEFT JOIN dbo.DC_POSITION p ON p.PositionId = a.AuthorPositionId
                ) s
                WHERE UPPER(trim(s.OrganizationName)) LIKE N'%' + @upperData + '%'
                      OR UPPER(trim(s.PositionName)) LIKE N'%' + @upperData + '%'
                      OR UPPER(trim(s.FullName)) LIKE N'%' + @upperData + '%';                     ---Ibrahimov Resid 
                RETURN;
        END;

        IF(@next = 5) -- elaqeli senedleri tapib qaytaracaq
            BEGIN
			IF(@docTypeId = 1 OR @docTypeId=2)
			BEGIN
			     SELECT * FROM (
			                        SELECT d.DocId AS [AuthorId], 
			                               d.DocEnterno AS [OrganizationName],
			                            (SELECT STUFF(
											(
												SELECT ' ' + o.OrganizationName
												FROM dbo.DC_ORGANIZATION o
												WHERE o.OrganizationId IN
			                                (
			                                    SELECT af.AdrOrganizationId
			                                    FROM dbo.DOCS_ADDRESSINFO af
			                                    WHERE af.AdrDocId = d.DocId
			                                          AND af.AdrTypeId = 3
			                                          AND af.AdrAuthorId IS NOT NULL
			                                ) FOR XML PATH('')), 1, 1, '')) AS [FullName]

											FROM dbo.VW_DOC_INFO  d INNER JOIN dbo.DOCS_FILE df ON d.DocId = df.FileDocId

									WHERE d.DocDocumentstatusId<>36 and (d.DocDoctypeId=@docTypeId) --AND d.DocOrganizationId=1				
										  OR (d.DocDoctypeId IN (12,18) AND df.SignatureStatusId=2)) sub

			          WHERE UPPER(sub.OrganizationName) LIKE N'%' + @upperData + '%';
			          RETURN;
			END;

			IF(@docTypeId = 3 or @docTypeId = 18)
			                BEGIN
			                    SELECT DISTINCT	sub.AuthorId,sub.OrganizationName,sub.FullName
			                    FROM
			                    (
			                        SELECT d.DocId AS [AuthorId], 
			                               d.DocEnterno AS [OrganizationName],
			                               CASE
			                                   WHEN d.DocDoctypeId = 1
			                                        OR d.DocDoctypeId = 2
			                                   THEN(
			                        (
			                            SELECT STUFF(
			                            (
			                                SELECT ' ' + o.OrganizationName
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
									SELECT(a.AuthorName + ' ' + a.AuthorSurname + ' ' + ISNULL(a.AuthorLastname, ''))
			                                FROM dbo.DOC_AUTHOR a
			                                WHERE a.AuthorId IN
			                                (
			                                    SELECT af.AdrAuthorId
			                                    FROM dbo.DOCS_ADDRESSINFO af
			                                    WHERE af.AdrDocId = d.DocId
			                                          AND af.AdrTypeId = 3
			                                          AND af.AdrAuthorId IS NOT NULL
													  )
			                        ))
			                                   WHEN d.DocDoctypeId = 18
			                                   THEN
			                        (
			                            SELECT af.FullName
			                            FROM dbo.DOCS_ADDRESSINFO af
			                            WHERE af.AdrDocId = d.DocId
			                                  AND af.AdrTypeId = 1
			                        )
			                               END AS [FullName]
			                        FROM dbo.VW_DOC_INFO d
			                             LEFT JOIN dbo.DOCS_APPLICATION da ON d.DocId = da.AppDocId
			                    ) sub
			                    WHERE UPPER(sub.OrganizationName) LIKE N'%' + @upperData + '%';
			                    RETURN;
			            END;

			IF(@docTypeId=12)
			BEGIN
			                    SELECT DISTINCT	sub.AuthorId,sub.OrganizationName,sub.FullName
			                    FROM
			                    (
			                        SELECT d.DocId AS [AuthorId], 
			                               d.DocEnterno AS [OrganizationName],
			                               CASE
			                                   WHEN d.DocDoctypeId = 1
			                                        OR d.DocDoctypeId = 2
			                                   THEN(
			                        (
			                            SELECT STUFF(
			                            (
			                                SELECT ' ' + o.OrganizationName
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
									SELECT(a.AuthorName + ' ' + a.AuthorSurname + ' ' + ISNULL(a.AuthorLastname, ''))
			                                FROM dbo.DOC_AUTHOR a
			                                WHERE a.AuthorId IN
			                                (
			                                    SELECT af.AdrAuthorId
			                                    FROM dbo.DOCS_ADDRESSINFO af
			                                    WHERE af.AdrDocId = d.DocId
			                                          AND af.AdrTypeId = 3
			                                          AND af.AdrAuthorId IS NOT NULL
													  )
			                        ))
			                                   WHEN d.DocDoctypeId = 12
			                                   THEN
			                        (
			                            SELECT af.FullName
			                            FROM dbo.DOCS_ADDRESSINFO af
			                            WHERE af.AdrDocId = d.DocId
			                                  AND af.AdrTypeId = 1
			                        )
			                               END AS [FullName]
			                        FROM dbo.VW_DOC_INFO d
			                             left JOIN dbo.DOCS_APPLICATION da ON d.DocId = da.AppDocId
			                    ) sub
			                    WHERE UPPER(sub.OrganizationName) LIKE N'%' + @upperData + '%';
			                    RETURN;
			            END;
			    END;

        IF(@next = 6) -- cavab senedlerini tapib qaytaracaq
            BEGIN
                SELECT *
                FROM
                (
                    SELECT d.DocId AS [AuthorId], 
                           d.DocEnterno AS [OrganizationName],
                           CASE
                               WHEN d.DocDoctypeId = 1
                                    OR d.DocDoctypeId = 2
                               THEN(
                    (
                        SELECT STUFF(
                        (
                            SELECT ' ' + o.OrganizationName
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
                        WHERE af.AdrDocId = d.DocId
                              AND af.AdrTypeId = 1
                    )
                           END AS [FullName], 
                           d.DocDoctypeId AS [AuthorOrganizationId]
                    FROM dbo.VW_DOC_INFO d
                         LEFT JOIN dbo.DC_ORGANIZATION do ON d.DocOrganizationId = do.OrganizationId
                         LEFT JOIN dbo.DOCS_EXECUTOR de ON d.DocId = de.ExecutorDocId
                    WHERE de.ExecutorWorkplaceId = @workPlaceId
                          AND d.DocResultId IS NULL
                          AND de.DirectionTypeId IN(18, 1)
                         AND de.SendStatusId IN(1, 2)
						 AND d.DocDocumentstatusId<>12
                ) sub
                WHERE UPPER(sub.OrganizationName) LIKE N'%' + @upperData + '%';
                RETURN;
        END;
    END;

