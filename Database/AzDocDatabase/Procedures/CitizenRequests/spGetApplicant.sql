/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [citizenrequests].[spGetApplicant] @docTypeId INT           = NULL, 
                                                   @firstName NVARCHAR(MAX) = NULL, 
                                                   @surName   NVARCHAR(MAX) = NULL, 
                                                   @docId     INT           = NULL
AS
    BEGIN
        IF(@docId IS NULL)
            BEGIN
                IF(@firstName IS NOT NULL
                   AND @surName IS NULL)
                    BEGIN
                        SELECT d.DocId, -- Senedin id-si      
                               d.DocEnterno, --Qeydiyyat nomresi
                               d.DocEnterdate, --Qeydiyyat tarixi,
                               d.DocApplytypeId, --Müraciətin növü,
                               d.DocTopicType, -- Movzu
                               d.DocTopicId, --Alt Movzu
                               app.AppFirstname, 
                               app.AppSurname, 
                               app.AppLastName, 
                               app.CountryName, 
                               app.RegionName, 
                               app.AppCountry1Id AS AppCountryId, 
                               app.AppRegion1Id AS AppRegionId, 
                               app.AppSosialStatusId, 
                               app.AppRepresenterId, 
                               app.Representer, 
                               app.AppAddress1 AS AppAddress, 
                               app.AppPhone1 AS AppPhone, 
                               app.AppEmail1 AS AppEmail, 
                               dt.TopicName -- Mövzu 
                        -- app.applicantName -- Vetendasin melumatlari
                        FROM dbo.VW_DOC_INFO  d
                             LEFT JOIN dbo.DOC_DOCUMENTSTATUS dd ON d.DocDocumentstatusId = dd.DocumentstatusId
                             LEFT JOIN dbo.DOC_TOPIC dt ON d.DocTopicId = dt.TopicId
                             LEFT JOIN
                        (
                            SELECT da.AppDocId, 
                                   da.AppFirstname, 
                                   da.AppSurname, 
                                   da.AppLastName, 
                                   da.AppCountry1Id, 
                            (
                                SELECT dc.CountryName
                                FROM dbo.DC_COUNTRY dc
                                WHERE dc.CountryId = da.AppCountry1Id
                            ) AS CountryName, 
                                   da.AppRegion1Id, 
                            (
                                SELECT dr.RegionName
                                FROM dbo.DC_REGION dr
                                WHERE dr.RegionId = da.AppRegion1Id
                            ) AS RegionName, 
                                   da.AppSosialStatusId, 
                                   da.AppRepresenterId, 
                            (
                                SELECT dr.RepresenterName
                                FROM dbo.DC_REPRESENTER dr
                                WHERE dr.RepresenterId = da.AppRepresenterId
                            ) AS Representer, 
                                   da.AppAddress1, 
                                   da.AppPhone1, 
                                   da.AppEmail1, 
                                   applicantName = STUFF(
                            (
                                SELECT ',' + CONCAT(da2.AppFirstname, ' ', da2.AppSurname, ' ', da2.AppLastName)
                                FROM dbo.DOCS_APPLICATION da2
                                WHERE da.AppDocId = da2.AppDocId FOR XML PATH('')
                            ), 1, 1, '')
                            FROM dbo.DOCS_APPLICATION da
                            GROUP BY da.AppDocId, 
                                     da.AppFirstname, 
                                     da.AppSurname, 
                                     da.AppLastName, 
                                     da.AppCountry1Id, 
                                     da.AppRegion1Id, 
                                     da.AppSosialStatusId, 
                                     da.AppRepresenterId, 
                                     da.AppAddress1, 
                                     da.AppPhone1, 
                                     da.AppEmail1
                        ) AS app ON d.DocId = app.AppDocId
                        WHERE d.DocDoctypeId = @docTypeId
                              AND UPPER(app.AppFirstname) LIKE N'' +  UPPER(@firstName) + '%'
                        ORDER BY d.DocId DESC;
                END;
                    ELSE
                    IF(@firstName IS NULL
                       AND @surName IS NOT NULL)
                        BEGIN
                            SELECT d.DocId, -- Senedin id-si      
                                   d.DocEnterno, --Qeydiyyat nomresi
                                   d.DocEnterdate, --Qeydiyyat tarixi
                                   d.DocApplytypeId, --Müraciətin növü,

                                   d.DocTopicType, -- Movzu
                                   d.DocTopicId, --Alt Movzu
                                   app.AppFirstname, 
                                   app.AppSurname, 
                                   app.AppLastName, 
                                   app.CountryName, 
                                   app.RegionName, 
                                   app.AppCountry1Id AS AppCountryId, 
                                   app.AppRegion1Id AS AppRegionId, 
                                   app.AppSosialStatusId, 
                                   app.AppRepresenterId, 
                                   app.Representer, 
                                   app.AppAddress1 AS AppAddress, 
                                   app.AppPhone1 AS AppPhone, 
                                   app.AppEmail1 AS AppEmail, 
                                   dt.TopicName -- Mövzu 
                            -- app.applicantName -- Vetendasin melumatlari
                            FROM dbo.VW_DOC_INFO d
                                 LEFT JOIN dbo.DOC_DOCUMENTSTATUS dd ON d.DocDocumentstatusId = dd.DocumentstatusId
                                 LEFT JOIN dbo.DOC_TOPIC dt ON d.DocTopicId = dt.TopicId
                                 LEFT JOIN
                            (
                                SELECT da.AppDocId, 
                                       da.AppFirstname, 
                                       da.AppSurname, 
                                       da.AppLastName, 
                                       da.AppCountry1Id, 
                                (
                                    SELECT dc.CountryName
                                    FROM dbo.DC_COUNTRY dc
                                    WHERE dc.CountryId = da.AppCountry1Id
                                ) AS CountryName, 
                                       da.AppRegion1Id, 
                                (
                                    SELECT dr.RegionName
                                    FROM dbo.DC_REGION dr
                                    WHERE dr.RegionId = da.AppRegion1Id
                                ) AS RegionName, 
                                       da.AppSosialStatusId, 
                                       da.AppRepresenterId, 
                                (
                                    SELECT dr.RepresenterName
                                    FROM dbo.DC_REPRESENTER dr
                                    WHERE dr.RepresenterId = da.AppRepresenterId
                                ) AS Representer, 
                                       da.AppAddress1, 
                                       da.AppPhone1, 
                                       da.AppEmail1, 
                                       applicantName = STUFF(
                                (
                                    SELECT ',' + CONCAT(da2.AppFirstname, ' ', da2.AppSurname, ' ', da2.AppLastName)
                                    FROM dbo.DOCS_APPLICATION da2
                                    WHERE da.AppDocId = da2.AppDocId FOR XML PATH('')
                                ), 1, 1, '')
                                FROM dbo.DOCS_APPLICATION da
                                GROUP BY da.AppDocId, 
                                         da.AppFirstname, 
                                         da.AppSurname, 
                                         da.AppLastName, 
                                         da.AppCountry1Id, 
                                         da.AppRegion1Id, 
                                         da.AppSosialStatusId, 
                                         da.AppRepresenterId, 
                                         da.AppAddress1, 
                                         da.AppPhone1, 
                                         da.AppEmail1
                            ) AS app ON d.DocId = app.AppDocId
                            WHERE d.DocDoctypeId = @docTypeId
                                  AND UPPER(app.AppSurname) LIKE N'' + UPPER(@surName) + '%'
                            ORDER BY d.DocId DESC;
                    END;
                        ELSE
                        BEGIN
                            SELECT d.DocId, -- Senedin id-si      
                                   d.DocEnterno, --Qeydiyyat nomresi
                                   d.DocEnterdate, --Qeydiyyat tarixi
                                   d.DocApplytypeId, --Müraciətin növü,
                                   d.DocTopicType, -- Movzu
                                   d.DocTopicId, --Alt Movzu
                                   app.AppFirstname, 
                                   app.AppSurname, 
                                   app.AppLastName, 
                                   app.CountryName, 
                                   app.RegionName, 
                                   app.AppCountry1Id AS AppCountryId, 
                                   app.AppRegion1Id AS AppRegionId, 
                                   app.AppSosialStatusId, 
                                   app.AppRepresenterId, 
                                   app.Representer, 
                                   app.AppAddress1 AS AppAddress, 
                                   app.AppPhone1 AS AppPhone, 
                                   app.AppEmail1 AS AppEmail, 
                                   dt.TopicName -- Mövzu 
                            -- app.applicantName -- Vetendasin melumatlari
                            FROM dbo.VW_DOC_INFO d
                                 LEFT JOIN dbo.DOC_DOCUMENTSTATUS dd ON d.DocDocumentstatusId = dd.DocumentstatusId
                                 LEFT JOIN dbo.DOC_TOPIC dt ON d.DocTopicId = dt.TopicId
                                 LEFT JOIN
                            (
                                SELECT da.AppDocId, 
                                       da.AppFirstname, 
                                       da.AppSurname, 
                                       da.AppLastName, 
                                       da.AppCountry1Id, 
                                (
                                    SELECT dc.CountryName
                                    FROM dbo.DC_COUNTRY dc
                                    WHERE dc.CountryId = da.AppCountry1Id
                                ) AS CountryName, 
                                       da.AppRegion1Id, 
                                (
                                    SELECT dr.RegionName
                                    FROM dbo.DC_REGION dr
                                    WHERE dr.RegionId = da.AppRegion1Id
                                ) AS RegionName, 
                                       da.AppSosialStatusId, 
                                       da.AppRepresenterId, 
                                (
                                    SELECT dr.RepresenterName
                                    FROM dbo.DC_REPRESENTER dr
                                    WHERE dr.RepresenterId = da.AppRepresenterId
                                ) AS Representer, 
                                       da.AppAddress1, 
                                       da.AppPhone1, 
                                       da.AppEmail1, 
                                       applicantName = STUFF(
                                (
                                    SELECT ',' + CONCAT(da2.AppFirstname, ' ', da2.AppSurname, ' ', da2.AppLastName)
                                    FROM dbo.DOCS_APPLICATION da2
                                    WHERE da.AppDocId = da2.AppDocId FOR XML PATH('')
                                ), 1, 1, '')
                                FROM dbo.DOCS_APPLICATION da
                                GROUP BY da.AppDocId, 
                                         da.AppFirstname, 
                                         da.AppSurname, 
                                         da.AppLastName, 
                                         da.AppCountry1Id, 
                                         da.AppRegion1Id, 
                                         da.AppSosialStatusId, 
                                         da.AppRepresenterId, 
                                         da.AppAddress1, 
                                         da.AppPhone1, 
                                         da.AppEmail1
                            ) AS app ON d.DocId = app.AppDocId
                            WHERE d.DocDoctypeId = @docTypeId
                                  AND UPPER(app.AppFirstname) LIKE N'' + UPPER(@firstName) + '%'
                                  AND UPPER(app.AppSurname) LIKE N'' + UPPER(@surName) + '%'
                            ORDER BY d.DocId DESC;
                    END;
        END;
            ELSE
            BEGIN
                SELECT d.DocId, -- Senedin id-si      
                       d.DocEnterno, --Qeydiyyat nomresi
                       d.DocEnterdate, --Qeydiyyat tarixi,
                       d.DocApplytypeId, --Müraciətin növü,
                       d.DocTopicType, -- Movzu
                       d.DocTopicId, --Alt Movzu
                       app.AppFirstname, 
                       app.AppSurname, 
                       app.AppLastName, 
                       app.CountryName, 
                       app.RegionName, 
                       app.AppCountry1Id AS AppCountryId, 
                       app.AppRegion1Id AS AppRegionId, 
                       app.AppSosialStatusId, 
                       app.AppRepresenterId, 
                       app.Representer, 
                       app.AppAddress1 AS AppAddress, 
                       app.AppPhone1 AS AppPhone, 
                       app.AppEmail1 AS AppEmail, 
                       dt.TopicName -- Mövzu 
                -- app.applicantName -- Vetendasin melumatlari
                FROM dbo.VW_DOC_INFO d
                     LEFT JOIN dbo.DOC_DOCUMENTSTATUS dd ON d.DocDocumentstatusId = dd.DocumentstatusId
                     LEFT JOIN dbo.DOC_TOPIC dt ON d.DocTopicId = dt.TopicId
                     LEFT JOIN
                (
                    SELECT da.AppDocId, 
                           da.AppFirstname, 
                           da.AppSurname, 
                           da.AppLastName, 
                           da.AppCountry1Id, 
                    (
                        SELECT dc.CountryName
                        FROM dbo.DC_COUNTRY dc
                        WHERE dc.CountryId = da.AppCountry1Id
                    ) AS CountryName, 
                           da.AppRegion1Id, 
                    (
                        SELECT dr.RegionName
                        FROM dbo.DC_REGION dr
                        WHERE dr.RegionId = da.AppRegion1Id
                    ) AS RegionName, 
                           da.AppSosialStatusId, 
                           da.AppRepresenterId, 
                    (
                        SELECT dr.RepresenterName
                        FROM dbo.DC_REPRESENTER dr
                        WHERE dr.RepresenterId = da.AppRepresenterId
                    ) AS Representer, 
                           da.AppAddress1, 
                           da.AppPhone1, 
                           da.AppEmail1, 
                           applicantName = STUFF(
                    (
                        SELECT ',' + CONCAT(da2.AppFirstname, ' ', da2.AppSurname, ' ', da2.AppLastName)
                        FROM dbo.DOCS_APPLICATION da2
                        WHERE da.AppDocId = da2.AppDocId FOR XML PATH('')
                    ), 1, 1, '')
                    FROM dbo.DOCS_APPLICATION da
                    GROUP BY da.AppDocId, 
                             da.AppFirstname, 
                             da.AppSurname, 
                             da.AppLastName, 
                             da.AppCountry1Id, 
                             da.AppRegion1Id, 
                             da.AppSosialStatusId, 
                             da.AppRepresenterId, 
                             da.AppAddress1, 
                             da.AppPhone1, 
                             da.AppEmail1
                ) AS app ON d.DocId = app.AppDocId
                WHERE d.DocId = @docId
                      AND app.AppRepresenterId = 1;
        END;
    END;

