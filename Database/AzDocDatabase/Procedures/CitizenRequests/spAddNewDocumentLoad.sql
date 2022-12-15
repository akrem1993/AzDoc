/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [citizenrequests].[spAddNewDocumentLoad] @docType        INT = NULL, 
                                                         @workPlaceId    INT = 0, 
                                                         @formTypeId     INT = 0, 
                                                         @docId          INT = NULL, 
                                                         @organizationId INT = NULL, 
                                                         @topicTypeId    INT = NULL, 
                                                         @countryId      INT = NULL
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
                        );   --orgId-ni tapiriq

                                                 
                        SELECT 1 FormTypeId,                             --TopicTypeName-Movzu    
                               dtt.TopicTypeId AS Id, 
                               dtt.TopicTypeName AS Name
                        FROM dbo.DOC_TOPIC_TYPE dtt
                        WHERE dtt.TopicTypeStatus = 1
                              AND (dtt.TopicTypeId BETWEEN 0 AND 88
                                   OR dtt.TopicTypeId IN(134, 135, 136))
								   AND isnull(dtt.OrganizationId,0)=(CASE WHEN @orgId<>11 THEN 0 end)
						UNION
						 SELECT 1 FormTypeId,                             --TopicTypeName-Movzu    
                               dtt.TopicTypeId AS Id, 
                               dtt.TopicTypeName AS Name
                        FROM dbo.DOC_TOPIC_TYPE dtt
                        WHERE dtt.TopicTypeStatus = 1
                              AND (dtt.TopicTypeId BETWEEN 159 AND 164 )
								   AND isnull(dtt.OrganizationId,0)=(CASE WHEN  @orgId=11 THEN 11 end) 							   
								  
                        UNION --WhomAddress

                        SELECT 2 FormTypeId,                               --Kime unvanlanib
                               WP.WorkplaceId AS Id, 
                               ISNULL(' ' + PE.PersonnelName, '') + ISNULL(' ' + PE.PersonnelSurname, '') + ISNULL(' ' + DO.DepartmentPositionName, '') + ISNULL(' ' + DP.DepartmentName, '') AS NAME
                        FROM DC_WORKPLACE AS WP
                             INNER JOIN DC_USER AS DU ON WP.WorkplaceUserId = DU.UserId
                             INNER JOIN DC_PERSONNEL AS PE ON DU.UserPersonnelId = PE.PersonnelId
                             INNER JOIN DC_DEPARTMENT AS DP ON WP.WorkplaceDepartmentId = DP.DepartmentId
                             INNER JOIN DC_DEPARTMENT_POSITION AS DO ON WP.WorkplaceDepartmentPositionId = DO.DepartmentPositionId
                             INNER JOIN DC_POSITION_GROUP pgroup ON pgroup.[PositionGroupId] = DO.PositionGroupId
                        WHERE((WP.WorkplaceOrganizationId = @orgId
                               AND DO.PositionGroupId IN(1, 2, 33)
                             AND @orgId = 1)
                        OR (WP.WorkplaceOrganizationId = @orgId
                            AND DO.PositionGroupId IN(5, 6)
                             AND @orgId <> 1))
                        AND PE.PersonnelStatus = 1

                        UNION --SignatoryPerson
      
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
						AND OrganizationId=	CASE WHEN @orgId=11 THEN 1 end 

                        UNION --TypeOfDocument  
      
                        SELECT 4 FormTypeId,                                --Senedin Novu
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

                        UNION --ExecutionStatus 
      
                        SELECT 5 FormTypeId,                             --Icra Qaydasi
                               ExecutionstatusId AS Id, 
                               ExecutionstatusName AS Name
                        FROM DOC_EXECUTIONSTATUS
                        WHERE ExecutionstatusStatus = 1

                        UNION --TypeOfApplication   
       
                        SELECT 8 FormTypeId,                              --Muraciet formasi 
                               ApplytypeId AS Id, 
                               ApplytypeName AS Name
                        FROM DOC_APPLYTYPE
                        WHERE ApplytypeStatus = 1

                        UNION
                                                      --Qurum 
                        SELECT 9 FormTypeId, 
                               AgencyId AS Id, 
                               AgencyName AS Name
                        FROM DC_AGENCY                                
                        WHERE AgencyOrganizationId = @orgId

                        UNION --Subtitle
                                                         --alt movzu
                        SELECT 10 FormTypeId, 
                               dt.TopicId AS Id, 
                               dt.TopicName AS Name
                        FROM dbo.DOC_TOPIC dt
                        WHERE dt.TopicTypeId = -1

                        UNION

                        SELECT 11 FormTypeId, 
                               da.AgencyId AS Id, 
                               da.AgencyName AS Name
                        FROM dbo.DC_AGENCY da
                        WHERE da.AgencyTopId = -1

                        UNION 
                                                     --Olke
                        SELECT 12 FormTypeId, 
                               dc.CountryId AS Id, 
                               dc.CountryName AS Name
                        FROM dbo.DC_COUNTRY dc
                        WHERE dc.CountryStatus = 1

                        UNION
                                                    --Rayon
                        SELECT 13 FormTypeId, 
                               dr.RegionId AS Id, 
                               dr.RegionName AS Name
                        FROM dbo.DC_REGION dr
                        WHERE dr.RegionCountryId = -1 AND dr.RegionStatus=1

                        UNION
                                                --sosial status    
                        SELECT 14 FormTypeId, 
                               ds.SocialId AS Id, 
                               ds.SocialName AS Name
                        FROM dbo.DC_SOCIALSTATUS ds
                        WHERE ds.SocialStatus = 1

                        UNION
                                              --Temsilci
                        SELECT 15 FormTypeId, 
                               dr.RepresenterId AS Id, 
                               dr.RepresenterName AS Name
                        FROM dbo.DC_REPRESENTER dr
                        WHERE dr.RepresenterStatus = 1;
                END;
                    ELSE
                    IF(@formTypeId = 6) --RelatedDocument                --Elaqeli sened 
                        BEGIN
                            SELECT *
                            FROM
                            (
                                SELECT d.DocId, 
                                       d.DocEnterno, -- senedin nomresi
                                       CASE
                                           WHEN d.DocDoctypeId = 1
                                                OR d.DocDoctypeId = 2
                                           THEN(
                                (
                                    SELECT STUFF(
                                    (
                                        SELECT ' ' + OrganizationName  --Teskilatin adi
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
                                     INNER JOIN dbo.DOCS_APPLICATION da ON d.DocId = da.AppDocId
                            ) sub
                            WHERE sub.DocumentInfo IS NOT NULL;
                    END;
                        ELSE
                        IF(@formTypeId = 7) --Author  --Hardan/Kimden daxil olub 
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
                            ELSE
                            IF(@formTypeId = 10)--Subtitle         --Alt Movzu
                                BEGIN
                                    SELECT dt.TopicId AS Id, 
                                           dt.TopicName AS Name
                                    FROM dbo.DOC_TOPIC dt
                                    WHERE dt.TopicTypeId = @topicTypeId;
                            END;
                                ELSE
                                IF(@formTypeId = 11) --Subordinate  -- Alt Qurum
                                    BEGIN
                                        SELECT da.AgencyId AS Id, 
                                               da.AgencyName AS Name
                                        FROM dbo.DC_AGENCY da
                                        WHERE da.AgencyTopId = @organizationId;
                                END;
                                    ELSE
                                    IF(@formTypeId = 13)          --Rayon 
                                        BEGIN
                                            SELECT dr.RegionId AS Id, 
                                                   dr.RegionName AS Name
                                            FROM dbo.DC_REGION dr
                                            WHERE dr.RegionCountryId = @countryId AND dr.RegionStatus=1;
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
                                       d.DocApplytypeId AS ApplytypeId, 
                                       d.DocTopicType AS TopicTypeId, 
                                       d.DocTopicId AS SubtitleId, 
                                       d.DocDocno AS DocNo, 
                                       ad.AdrPersonId AS WhomAddressId, 
                                       d.DocReceivedFormId AS ReceivedFormId, 
                                       da.Field1 AS NumberOfApplicants, 
                                       d.DocDocdate AS DocDate, 
                                       d.DocFormId AS TypeOfDocumentId, 
                                       d.DocExecutionStatusId AS ExecutionStatusId, 
                                       d.DocPlannedDate AS PlannedDate, 
                                       da.Field2 AS OrganizationId, 
                                       da.Field3 AS SubordinateId, 
                                       da.Field16 AS Corruption, 
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
                                               p.PositionName
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
                                    SELECT *
                                    FROM
                                    (
                                        SELECT da.AppId, 
                                               d.DocEnterno, 
                                               da.AppFirstname, 
                                               da.AppSurname, 
                                               da.AppLastName, 
                                               da.AppCountry1Id AS AppCountryId, 
                                               da.AppRegion1Id AS AppRegionId, 
                                               dc.CountryName, 
                                               dr2.RegionName, 
                                               da.AppSosialStatusId, 
                                               ds.SocialName, 
                                               da.AppRepresenterId, 
                                               dr.RepresenterName, 
                                               da.AppAddress1 AS AppAddress, 
                                               da.AppPhone1 AS AppPhone, 
                                               da.AppEmail1 AS AppEmail, 
                                               d.DocDuplicateId AS AppFormType
                                        FROM dbo.DOCS_APPLICATION da
                                             LEFT JOIN dbo.DOCS d ON da.AppDocId = d.DocId
                                             LEFT JOIN dbo.DC_SOCIALSTATUS ds ON da.AppSosialStatusId = ds.SocialId
                                             LEFT JOIN dbo.DC_REPRESENTER dr ON da.AppRepresenterId = dr.RepresenterId
                                             LEFT JOIN dbo.DC_COUNTRY dc ON da.AppCountry1Id = dc.CountryId
                                             LEFT JOIN dbo.DC_REGION dr2 ON da.AppRegion1Id = dr2.RegionId
                                        WHERE da.AppDocId = @docId
                                    ) s FOR JSON AUTO
                                ) AS ApplicationModels
                                FROM dbo.DOCS d
                                     INNER JOIN dbo.DOCS_ADDRESSINFO ad ON d.DocId = ad.AdrDocId
                                     LEFT JOIN dbo.DOCS_ADDITION da ON d.DocId = da.DocumentId
                                WHERE d.DocId = @docId
                                      AND ad.AdrAuthorId IS NULL
                            ) s FOR JSON AUTO;
                    END;
            END;

    END;

