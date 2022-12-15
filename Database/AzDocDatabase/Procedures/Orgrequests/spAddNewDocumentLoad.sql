/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [orgrequests].[spAddNewDocumentLoad] @docType     INT = NULL, 
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

                        --TopicTypeName                    --Movzu

                        SELECT 1 FormTypeId, 
                               t.TopicTypeId AS Id, 
                               t.TopicTypeName AS Name
                        FROM dbo.DOC_TOPIC_TYPE t
                        WHERE TopicTypeStatus = 1
                              AND  (t.TopicTypeId  BETWEEN 88 AND 134
                                   OR t.TopicTypeId = 69)
								   AND isnull(t.OrganizationId,0)=(CASE WHEN @orgId<>11 THEN 0 end) 

						UNION
						SELECT 1 FormTypeId, 
                               t.TopicTypeId AS Id, 
                               t.TopicTypeName AS Name
                        FROM dbo.DOC_TOPIC_TYPE t
                        WHERE TopicTypeStatus = 1                              
								   AND t.OrganizationId=( case WHEN @orgId=11 THEN 11 end )
								   AND t.TopicTypeId < 160

							 
                        UNION --WhomAddress              --Kime unvanlanib 

                        SELECT 2 FormTypeId, 
                               WP.WorkplaceId AS Id, 
                               ISNULL(' ' + PE.PersonnelName, '') + ISNULL(' ' + PE.PersonnelSurname, '') + ISNULL(' ' + DO.DepartmentPositionName, '') + ISNULL(' ' + DP.DepartmentName, '') AS NAME
                        FROM DC_WORKPLACE AS WP
                             INNER JOIN DC_USER AS DU ON WP.WorkplaceUserId = DU.UserId
                             INNER JOIN DC_PERSONNEL AS PE ON DU.UserPersonnelId = PE.PersonnelId
                             INNER JOIN DC_DEPARTMENT AS DP ON WP.WorkplaceDepartmentId = DP.DepartmentId
                             INNER JOIN DC_DEPARTMENT_POSITION AS DO ON WP.WorkplaceDepartmentPositionId = DO.DepartmentPositionId
                             INNER JOIN DC_POSITION_GROUP pgroup ON pgroup.[PositionGroupId] = DO.PositionGroupId
                        WHERE((WP.WorkplaceOrganizationId = @orgId
                               AND DO.PositionGroupId IN(1, 2, 25, 33,37)
                             AND @orgId = 1)
                        OR (WP.WorkplaceOrganizationId = @orgId
                            AND DO.PositionGroupId IN(5, 6)
                             AND @orgId <> 1))
                        AND PE.PersonnelStatus = 1

                        UNION --SignatoryPerson        --Imza eden 
                        SELECT 3 FormTypeId, 
                               ReceivedFormId AS Id, 
                               ReceivedFormName AS Name
                        FROM DOC_RECEIVED_FORM
                        WHERE ReceivedFormStatus = 1 
						and ReceivedFormId  <> CASE WHEN @orgId=11 THEN 9 ELSE 19  END 
						AND OrganizationId IS NULL
						UNION
						SELECT 3 FormTypeId, 
                               ReceivedFormId AS Id, 
                               ReceivedFormName AS Name
                        FROM DOC_RECEIVED_FORM
                        WHERE ReceivedFormStatus = 1
						 AND OrganizationId= CASE WHEN @orgId=11 THEN 1 end

                        UNION --TypeOfDocument         --Senedin novu 
                        SELECT 4 FormTypeId, 
                               f.FormId Id, 
                               f.FormName Name
                        FROM DOC_FORM f
                        WHERE f.FormId IN
                        (
                            SELECT t.FormId
                            FROM dbo.DOC_FORM_DOCTYPE t
                            WHERE t.DocTypeId = @docType
                                  AND t.FormDocTypeStatus = 1
                        )
                              AND f.FormStatus = 1

                        UNION --ExecutionStatus            --Icra qaydasi

                        SELECT 5 FormTypeId, 
                               ExecutionstatusId AS Id, 
                               ExecutionstatusName AS Name
                        FROM DOC_EXECUTIONSTATUS
                        WHERE ExecutionstatusStatus = 1

                        UNION --TypeOfAssignment      
                        SELECT 6 FormTypeId, 
                               s.SendStatusId Id, 
                               s.SendStatusName Name
                        FROM DOC_SENDSTATUS s
                             INNER JOIN dbo.DOC_SENDSTATUS_TYPE st ON s.SendStatusId = st.SendStatusId
                        WHERE st.DocTypeId = @docType
                              AND s.SendStatusStatus = 1
                              AND st.SendTypeStatus = 1

                        UNION --WhomAddressed                     --Hardan/Kimden daxil olub         

                        SELECT 8 FormTypeId, 
                               WP.WorkplaceId AS Id, 
                               ISNULL(' ' + PE.PersonnelName, '') + ISNULL(' ' + PE.PersonnelSurname, '') + ISNULL(' ' + PE.PersonnelLastname, '') + ISNULL(' ' + DO.DepartmentPositionName, '') AS Name
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
                        )));
                END;
                    ELSE
                    IF(@formTypeId = 6) --RelatedDocument                 --Elaqeli sened
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
                    END;
                        ELSE
                        IF(@formTypeId = 7) --Author         --Muellif    
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
                                       d.DocEnterdate AS DocEnterDate, 
                                       d.DocTopicType AS TopicTypeId, 
                                       d.DocDocno AS DocNo, 
                                       ad.AdrPersonId AS WhomAddressId, 
                                       d.DocReceivedFormId AS ReceivedFormId, 
                                       d.DocDocdate AS DocDate, 
                                       d.DocFormId AS TypeOfDocumentId, 
                                       d.DocExecutionStatusId AS ExecutionStatusId, 
                                       d.DocPlannedDate AS PlannedDate, 
                                       d.DocDescription AS ShortContent, 
                                       d.DocIsAppealBoard, 
                                       d.DocDuplicateId, 
                                       d.DocUndercontrolStatusId AS Supervision, 
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
                                        SELECT d.DocId,
											   r.RelatedId, 
                                               d.DocEnterno, 
                                               (CONCAT(da.AppFirstname, SPACE(1), da.AppSurname, SPACE(1), da.AppLastname) + ' ' +
                                        (
                                            SELECT  OrganizationName
											FROM DC_ORGANIZATION o
											WHERE o.OrganizationId IN
											(
												SELECT af.AdrOrganizationId
												FROM DOCS_ADDRESSINFO af
												WHERE af.AdrDocId = d.DocId
													  AND af.AdrTypeId = 3
													  AND af.AdrAuthorId IS NOT NULL
											)
                                        )) DocumentInfo
                                        FROM dbo.DOCS d
                                                LEFT JOIN dbo.DOCS_RELATED r ON d.DocId = r.RelatedDocumentId
												 LEFT JOIN dbo.DC_ORGANIZATION do ON d.DocOrganizationId = do.OrganizationId
												 LEFT JOIN dbo.DOCS_APPLICATION da ON d.DocId = da.AppDocId
                                        WHERE r.RelatedDocId = @docId
                                    ) s FOR JSON AUTO
                                ) AS RelatedDocModels, 
                                (
                                    SELECT t.TaskId, 
                                    (
                                        SELECT s.SendStatusName
                                        FROM dbo.DOC_SENDSTATUS s
                                        WHERE s.SendStatusId = t.TypeOfAssignmentId
                                    ) TypeOfAssignment, 
                                           t.TaskNo, 
                                           t.TaskDecription Task,                                           
                                    (
                                        SELECT ISNULL(' ' + PE.PersonnelName, '') + ISNULL(' ' + PE.PersonnelSurname, '') + ISNULL(' ' + PE.PersonnelLastname, '') + ISNULL(' ' + DO.DepartmentPositionName, '') + ISNULL(' ' + DP.DepartmentName, '')
                                        FROM [dbo].DC_WORKPLACE WP
                                             INNER JOIN [dbo].DC_USER DU ON WP.WorkplaceUserId = DU.UserId
                                             INNER JOIN [dbo].DC_PERSONNEL PE ON DU.UserPersonnelId = PE.PersonnelId
                                             INNER JOIN [dbo].DC_DEPARTMENT DP ON WP.WorkplaceDepartmentId = DP.DepartmentId
                                             INNER JOIN [dbo].DC_DEPARTMENT_POSITION DO ON WP.WorkplaceDepartmentPositionId = DO.DepartmentPositionId
                                        WHERE PE.PersonnelStatus = 1
                                              AND WP.WorkplaceId = t.WhomAddressId
                                    ) WhomAddress
                                    FROM dbo.DOC_TASK t
                                    WHERE t.TaskDocId = @docId FOR JSON AUTO
                                ) AS TaskModels
                                FROM dbo.DOCS d
                                     INNER JOIN dbo.DOCS_ADDRESSINFO ad ON d.DocId = ad.AdrDocId
                                WHERE d.DocId = @docId
                                      AND ad.AdrAuthorId IS NULL
                            ) s FOR JSON AUTO;
                    END;
            END;
    END;

