
/*
Migrated by Kamran A-eff 23.08.2019
*/
/*
Migrated by Kamran A-eff 06.08.2019
*/
/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [citizenrequests].[spDocsOperation] @operationType      INT, 
                                                    @workPlaceId        INT                            = NULL, 
                                                    @docTypeId          INT                            = NULL, 
                                                    @docDeleted         INT                            = NULL, 
                                                    @documentStatusId   INT                            = NULL, 
                                                    @docEnterDate       DATE                           = NULL, 
                                                    @applytypeId        INT                            = NULL, 
                                                    @whomAddressId      INT                            = NULL, 
                                                    @topicTypeId        INT                            = NULL, 
                                                    @subtitleId         INT                            = NULL, 
                                                    @executionStatusId  INT                            = NULL, 
                                                    @receivedFormId     INT                            = NULL, 
                                                    @numberOfApplicants INT                            = NULL, 
                                                    @plannedDate        DATE                           = NULL, 
                                                    @organizationId     INT                            = NULL, 
                                                    @subordinateId      INT                            = NULL, 
                                                    @typeOfDocumentId   INT                            = NULL, 
                                                    @docNo              NVARCHAR(MAX)                  = NULL, 
                                                    @docDate            DATE                           = NULL, 
                                                    @corruption         BIT                            = NULL, 
                                                    @supervision        BIT                            = NULL, 
                                                    @shortContent       NVARCHAR(MAX)                  = NULL, 
                                                    @rowId              INT                            = NULL, 
                                                    @formTypeId         INT                            = NULL, 
                                                    @related            [dbo].[UdttRelated] READONLY, 
                                                    @author             [citizenrequests].[UdttAuthor] READONLY, 
                                                    @application        [dbo].[UdttApplication] READONLY, 
                                                    @taskId             INT                            = NULL, 
                                                    @docId              INT                            = NULL OUTPUT, 
                                                    @result             INT OUTPUT
AS
    BEGIN
        SET NOCOUNT ON;
        SET TRANSACTION ISOLATION LEVEL READ COMMITTED; -- turn it on
        BEGIN TRANSACTION;
        BEGIN TRY
            DECLARE @date DATE= dbo.SYSDATETIME(), @periodId INT, @orgId INT, @docDocno NVARCHAR(20)= NULL, @docEnterNo NVARCHAR(30)= NULL, @docEnterNoCount INT= NULL, @docIndex NVARCHAR(20)= NULL, @organizationIndex INT, @appFormType INT= NULL, @delegateCount INT= NULL, @collectivCount INT= NULL, @topicIndex INT= NULL, @docEnterop2 INT= NULL, @colIndexCount INT= NULL, @charIndex INT= NULL;

            --Periodu tapiram
            SET @docTypeId = 2;
            IF NOT EXISTS
            (
                SELECT d.*
                FROM dbo.DOCS d
                WHERE d.DocId = @docId
                      AND d.DocDoctypeId = @docTypeId
                      AND d.DocDeleted IN
                (CASE
                     WHEN @operationType = 0
                     THEN 3
                     ELSE 0
                 END
                )
            )
               AND @docId IS NOT NULL
                BEGIN
                    THROW 56000, N'Sənədin yaradılmasında problem yarandı.Zəhmət olmasa sənədin yaradılmasına yenidən cəhd edin', 1;
            END;
            SELECT @periodId = dp.PeriodId
            FROM DOC_PERIOD dp
            WHERE dp.PeriodDate1 <= @date
                  AND dp.PeriodDate2 >= @date;
            SELECT @topicIndex = dt.TopicIndex
            FROM dbo.DOC_TOPIC dt
            WHERE dt.TopicId = @subtitleId;

            -- Organization Id-sini tapiram
            SELECT @orgId =
            (
                SELECT dbo.fnPropertyByWorkPlaceId(@workPlaceId, 12)
            );
            IF(@operationType = 1) --Insert
                BEGIN
                    INSERT INTO dbo.DOCS
                    (DocPeriodId, 
                     DocOrganizationId, 
                     DocDoctypeId, 
                     DocDeleted, 
                     DocDeletedByDate, 
                     DocInsertedById, 
                     DocInsertedByDate
                    )
                    VALUES
                    (@periodId, 
                     @orgId, 
                     @docTypeId, 
                     @docDeleted, 
                     dbo.SYSDATETIME(), 
                     @workPlaceId, 
                     dbo.SYSDATETIME()
                    );
                    SET @docId = SCOPE_IDENTITY();
            END;
                ELSE
                IF(@operationType = 0) -- Save 
                    BEGIN
                        SELECT @collectivCount = COUNT(0)
                        FROM @application ap
                        WHERE ap.AppRepresenterId = 1;
                        IF(@collectivCount > 1)
                            BEGIN
                                SELECT @appFormType =
                                (
                                    SELECT TOP 1 ap.AppFormType
                                    FROM @application ap
                                    WHERE ap.AppRepresenterId = 1
                                );
                                IF((@appFormType IS NULL)
                                   OR @appFormType = 2)
                                    BEGIN
                                        --SELECT @docEnterop2 = COUNT(0) + 1
                                        --FROM dbo.VW_DOC_INFO d WITH (TABLOCKX, HOLDLOCK)
                                        --WHERE d.DocDoctypeId = 2
                                        --      AND d.DocEnterno IS NOT NULL
                                        --      AND d.DocDuplicateId IS NULL
                                        --      AND d.DocOrganizationId = @orgId
                                        --      AND d.DocPeriodId = @periodId;

                                        SELECT @docEnterop2 =isnull(MAX(s.rowOrder),0) + 1
                                        FROM
                                        (
                                            SELECT CONVERT(INT, LEFT(SUBSTRING(d.DocEnterno, CHARINDEX('-', d.DocEnterno) + 1, LEN(d.DocEnterno)), CHARINDEX('-', SUBSTRING(d.DocEnterno, CHARINDEX('-', d.DocEnterno) + 1, LEN(d.DocEnterno))) - 1)) AS rowOrder
                                            FROM dbo.VW_DOC_INFO d WITH (TABLOCKX, HOLDLOCK)
                                            WHERE d.DocDoctypeId = 2
                                                  AND d.DocEnterno IS NOT NULL
                                                  AND d.DocDuplicateId IS NULL
                                                  AND d.DocOrganizationId = @orgId
                                                  AND d.DocPeriodId = @periodId
                                        ) s;
                                        SELECT @docEnterNo = 'KOL-' + CONVERT(NVARCHAR(MAX), (@docEnterop2)) + '-' + RIGHT('000' + CONVERT(NVARCHAR(MAX), @topicIndex), 3);
                                END;
                                    ELSE
                                    IF(@appFormType IN(1, 3))
                                        BEGIN
                                            SELECT @charIndex = CHARINDEX('/', s.DocEnter)
                                            FROM
                                            (
                                                SELECT DISTINCT 
                                                       ap.DocEnterno AS DocEnter
                                                FROM @application ap
                                                WHERE ap.AppRepresenterId = 1
                                            ) s;
                                            IF(@charIndex = 0)
                                                BEGIN
                                                    SELECT @docIndex =
                                                    (
                                                        SELECT DISTINCT 
                                                               ap.DocEnterno AS DocEnter
                                                        FROM @application ap
                                                        WHERE ap.AppRepresenterId = 1
                                                    );
                                                    SELECT @colIndexCount = SUBSTRING(vdi.DocEnterno, CHARINDEX('/', vdi.DocEnterno) + 1, LEN(vdi.DocEnterno))
                                                    FROM dbo.VW_DOC_INFO vdi
                                                    WHERE vdi.DocEnterno LIKE '%' + @docIndex + '%';
                                            END;
                                                ELSE
                                                BEGIN
                                                    SELECT @docIndex =
                                                    (
                                                        SELECT LEFT(s.DocEnter, CHARINDEX('/', s.DocEnter) - 1)
                                                        FROM
                                                        (
                                                            SELECT DISTINCT 
                                                                   ap.DocEnterno AS DocEnter
                                                            FROM @application ap
                                                            WHERE ap.AppRepresenterId = 1
                                                        ) s
                                                    );
                                                    SELECT @colIndexCount = SUBSTRING(vdi.DocEnterno, CHARINDEX('/', vdi.DocEnterno) + 1, LEN(vdi.DocEnterno))
                                                    FROM dbo.VW_DOC_INFO vdi
                                                    WHERE vdi.DocEnterno LIKE '%' + @docIndex + '%';
                                            END;
                                            SELECT @docEnterop2 = LEFT(SUBSTRING(s.DocEnter, CHARINDEX('-', s.DocEnter) + 1, LEN(s.DocEnter)), CHARINDEX('-', SUBSTRING(s.DocEnter, CHARINDEX('-', s.DocEnter) + 1, LEN(s.DocEnter))) - 1)
                                            FROM
                                            (
                                                SELECT DISTINCT 
                                                       ap.DocEnterno AS DocEnter
                                                FROM @application ap
                                                WHERE ap.AppRepresenterId = 1
                                            ) s;
                                            SELECT @docEnterNo = 'KOL-' + CONVERT(NVARCHAR(MAX), (@docEnterop2)) + '-' + RIGHT('000' + CONVERT(NVARCHAR(MAX), @topicIndex), 3) + '/' + CONVERT(NVARCHAR(MAX), @colIndexCount);
                                    END;
                        END;
                            ELSE
                            BEGIN
                                SELECT @appFormType = ap.AppFormType
                                FROM @application ap
                                WHERE ap.AppRepresenterId = 1;
                                IF(@appFormType = 2)
                                    BEGIN
                                        IF EXISTS
                                        (
                                            SELECT d.DocEnterno, 
                                                   d.DocTopicType, 
                                                   d.DocTopicId
                                            FROM dbo.DOCS d
                                            WHERE d.DocEnterno =
                                            (
                                                SELECT ap.DocEnterno
                                                FROM @application ap
                                                WHERE ap.AppRepresenterId = 1
                                            )
                                                  AND d.DocTopicType = @topicTypeId
                                                  AND d.DocTopicId = @subtitleId
                                        )
                                            BEGIN
                                                SET @appFormType = 1;
                                        END;
                                END;
                                SELECT @delegateCount =
                                (
                                    SELECT COUNT(0)
                                    FROM @application ap
                                    WHERE ap.AppRepresenterId = 2
                                );
                                IF(@appFormType IS NULL)
                                    BEGIN
                                        SELECT @docEnterop2 =isnull(MAX(s.rowOrder),0) + 1
                                        FROM
                                        (
                                            SELECT CONVERT(INT, LEFT(SUBSTRING(d.DocEnterno, CHARINDEX('-', d.DocEnterno) + 1, LEN(d.DocEnterno)), CHARINDEX('-', SUBSTRING(d.DocEnterno, CHARINDEX('-', d.DocEnterno) + 1, LEN(d.DocEnterno))) - 1)) AS rowOrder
                                            FROM dbo.VW_DOC_INFO d WITH (TABLOCKX, HOLDLOCK)
                                            WHERE d.DocDoctypeId = 2
                                                  AND d.DocEnterno IS NOT NULL
                                                  AND d.DocDuplicateId IS NULL
                                                  AND d.DocOrganizationId = @orgId
                                                  AND d.DocPeriodId = @periodId
                                        ) s;
                                        IF(@delegateCount = 0)
                                            BEGIN
                                                SELECT @docEnterNo =
                                                (
                                                    SELECT SUBSTRING(ap.AppSurname, 1, 1)
                                                    FROM @application ap
                                                    WHERE ap.AppRepresenterId = 1
                                                ) + '-' + CONVERT(NVARCHAR(MAX), (@docEnterop2)) + '-' + RIGHT('000' + CONVERT(NVARCHAR(MAX), @topicIndex), 3);
                                        END;
                                            ELSE
                                            BEGIN
                                                SELECT @docEnterNo =
                                                (
                                                    SELECT SUBSTRING(ap.AppSurname, 1, 1)
                                                    FROM @application ap
                                                    WHERE ap.AppRepresenterId = 2
                                                ) + '-' + CONVERT(NVARCHAR(MAX), (@docEnterop2)) + '-' + RIGHT('000' + CONVERT(NVARCHAR(MAX), @topicIndex), 3);
                                        END;
                                END;
                                    ELSE
                                    IF(@appFormType = 1
                                       OR @appFormType = 3)
                                        BEGIN
                                            IF(@delegateCount = 0)
                                                BEGIN
                                                    SELECT @docIndex = SUBSTRING(ap.DocEnterno, 1, CHARINDEX('/', ap.DocEnterno + '/') - 1)
                                                    FROM @application ap
                                                    WHERE ap.AppRepresenterId = 1;
                                                    SELECT @docEnterop2 = COUNT(0) + 1
                                                    FROM dbo.VW_DOC_INFO d WITH (TABLOCKX, HOLDLOCK)
                                                    WHERE d.DocEnterno LIKE '' +
                                                    (
                                                        SELECT @docIndex
                                                    ) + '%'
                                                          AND d.DocEnterno IS NOT NULL
                                                          AND d.DocPeriodId = @periodId;
                                                    SELECT @docEnterNo =
                                                    (
                                                        SELECT @docIndex
                                                    ) + '/' + CONVERT(NVARCHAR(MAX), @docEnterop2);
                                            END;
                                                ELSE
                                                BEGIN
                                                    SELECT @docIndex =
                                                    (
                                                        SELECT SUBSTRING(ap.AppSurname, 1, 1)
                                                        FROM @application ap
                                                        WHERE ap.AppRepresenterId = 2
                                                    ) + '' + SUBSTRING(ap.DocEnterno, 2, CHARINDEX('/', ap.DocEnterno + '/') - 1)
                                                    FROM @application ap
                                                    WHERE ap.AppRepresenterId = 1;
                                                    SELECT @docEnterop2 = COUNT(0) + 1
                                                    FROM dbo.VW_DOC_INFO d WITH (TABLOCKX, HOLDLOCK)
                                                    WHERE d.DocEnterno LIKE '' +
                                                    (
                                                        SELECT @docIndex
                                                    ) + '%'
                                                          AND d.DocEnterno IS NOT NULL
                                                          AND d.DocPeriodId = @periodId;
                                                    SELECT @docEnterNo =
                                                    (
                                                        SELECT @docIndex
                                                    ) + '/' + CONVERT(NVARCHAR(MAX), @docEnterop2);
                                            END;
                                    END;
                                        ELSE
                                        IF(@appFormType = 2)
                                            BEGIN
                                                IF(@delegateCount = 0)
                                                    BEGIN
                                                        SELECT @docIndex = SUBSTRING(ap.DocEnterno, CHARINDEX('-', ap.DocEnterno) + 1, LEN(ap.DocEnterno))
                                                        FROM @application ap
                                                        WHERE ap.AppRepresenterId = 1;
                                                        SELECT @docEnterNo =
                                                        (
                                                            SELECT LEFT(ap.DocEnterno, CHARINDEX('-', ap.DocEnterno))
                                                        ) +
                                                        (
                                                            SELECT LEFT(
                                                            (
                                                                SELECT @docIndex
                                                            ), CHARINDEX('-',
                                                            (
                                                                SELECT @docIndex
                                                            )))
                                                        ) + RIGHT('000' + CONVERT(NVARCHAR(MAX), @topicIndex), 3)
                                                        FROM @application ap
                                                        WHERE ap.AppRepresenterId = 1;
                                                END;
                                                    ELSE
                                                    BEGIN
                                                        SELECT @docIndex =
                                                        (
                                                            SELECT SUBSTRING(ap.AppSurname, 1, 1)
                                                            FROM @application ap
                                                            WHERE ap.AppRepresenterId = 2
                                                        ) + '' + SUBSTRING(ap.DocEnterno, 2, CHARINDEX('/', ap.DocEnterno + '/') - 1)
                                                        FROM @application ap
                                                        WHERE ap.AppRepresenterId = 1;
                                                        SELECT @docEnterNo =
                                                        (
                                                            SELECT LEFT(ap.DocEnterno, CHARINDEX('-', ap.DocEnterno))
                                                        ) +
                                                        (
                                                            SELECT LEFT(
                                                            (
                                                                SELECT @docIndex
                                                            ), CHARINDEX('-',
                                                            (
                                                                SELECT @docIndex
                                                            )))
                                                        ) + RIGHT('000' + CONVERT(NVARCHAR(MAX), @topicIndex), 3)
                                                        FROM @application ap
                                                        WHERE ap.AppRepresenterId = 2;
                                                END;
                                        END;
                        END;
                        IF((@executionStatusId = 0)
                           OR @executionStatusId = 2
                           OR @executionStatusId = 3)
                            BEGIN
                                IF(@executionStatusId = 0)
                                    BEGIN
                                        SELECT @executionStatusId = 2;
                                        SELECT @plannedDate = DATEADD(DAY, 15, GETDATE());
                                END;
                                    ELSE
                                    IF(((@executionStatusId = 2)
                                        OR (@executionStatusId = 3))
                                       AND (@plannedDate IS NULL))
                                        BEGIN
                                            SELECT @plannedDate = DATEADD(DAY, 15, GETDATE());
                                    END;
                        END;
                        UPDATE dbo.DOCS
                          SET 
                              DocEnterno = @docEnterNo, 
                              DocEnternop2 = @docEnterop2, 
                              DocEnterdate = @docEnterDate, 
                              DocApplytypeId = @applytypeId, 
                              DocTopicType = @topicTypeId, 
                              DocTopicId = @subtitleId, 
                              DocExecutionStatusId = @executionStatusId, 
                              DocReceivedFormId = @receivedFormId, 
                              DocPlannedDate = @plannedDate, 
                              DocFormId = @typeOfDocumentId, 
                              DocDocno = @docNo, 
                              DocDocdate = @docDate, 
                              DocUndercontrolStatusId = @supervision, 
                              DocDocumentstatusId = @documentStatusId, 
                              DocDescription = @shortContent, 
                              DocDeleted = @docDeleted, 
                              DocDeletedByDate = dbo.SYSDATETIME(), 
                              DocDuplicateId = @appFormType, 
                              DocDocumentOldStatusId =
                        (
                            SELECT d.DocDocumentstatusId
                            FROM dbo.docs d
                            WHERE d.DocId = @docId
                        )
                        WHERE DocId = @docId;
                        INSERT INTO dbo.DOCS_ADDITION
                        (
                        --DocsAdditionId - column value is auto-generated
                        DocumentId, 
                        Field1, 
                        Field2, 
                        Field3, 
                        Field16
                        )
                        VALUES
                        (
                        -- DocsAdditionId - int
                        @docId, -- DocumentId - int
                        @numberOfApplicants, -- Field1 - float
                        @organizationId, -- Field2 - float
                        @subordinateId, -- Field3 - float 
                        @corruption -- Field 16 - bit                  
                        );
                        INSERT INTO dbo.DOCS_APPLICATION
                        (AppDocId, 
                         AppApplierTypeId, 
                         AppFirstname, 
                         AppSurname, 
                         AppLastName, 
                         AppSosialStatusId, 
                         AppCountry1Id, 
                         AppRegion1Id, 
                         AppAddress1, 
                         AppRepresenterId, 
                         AppPhone1, 
                         AppEmail1
                        )
                               SELECT @docId AppDocId, 
                                      @docTypeId AppApplierTypeId, 
                                      ap.AppFirstname, 
                                      ap.AppSurname, 
                                      ap.AppLastName, 
                                      ap.AppSosialStatusId, 
                                      ap.AppCountryId, 
                                      ap.AppRegionId, 
                                      ap.AppAddress, 
                                      ap.AppRepresenterId, 
                                      ap.AppPhone, 
                                      ap.AppEmail
                               FROM @application ap;
                        IF(@whomAddressId <> 0)
                            BEGIN
                                INSERT INTO dbo.DOCS_ADDRESSINFO
                                (AdrDocId, 
                                 AdrTypeId, 
                                 AdrOrganizationId, 
                                 AdrAuthorId, 
                                 AdrAuthorDepartmentName, 
                                 AdrPersonId, 
                                 AdrPositionId, 
                                 AdrUndercontrol, 
                                 AdrUndercontrolDays, 
                                 FullName, 
                                 AdrSendStatusId
                                )
                                VALUES
                                (@docId, 
                                 2, 
                                 CONVERT(INT,
                                (
                                    SELECT [dbo].[fnGetPersonnelDetailsbyWorkPlaceId](@whomAddressId, 3)
                                )), 
                                 NULL, 
                                 CONVERT(NVARCHAR(MAX),
                                (
                                    SELECT [dbo].[fnGetPersonnelDetailsbyWorkPlaceId](@whomAddressId, 2)
                                )), 
                                 @whomAddressId, 
                                 NULL, 
                                 0, 
                                 0, 
                                 CONVERT(NVARCHAR(MAX),
                                (
                                    SELECT [dbo].[fnGetPersonnelDetailsbyWorkPlaceId](@whomAddressId, 1)
                                )), 
                                 NULL
                                );
                        END;
                            ELSE
                            BEGIN
                                INSERT INTO dbo.DOCS_ADDRESSINFO
                                (AdrDocId, 
                                 AdrTypeId, 
                                 AdrOrganizationId, 
                                 AdrAuthorId, 
                                 AdrAuthorDepartmentName, 
                                 AdrPersonId, 
                                 AdrPositionId, 
                                 AdrUndercontrol, 
                                 AdrUndercontrolDays, 
                                 FullName, 
                                 AdrSendStatusId
                                )
                                VALUES
                                (@docId, 
                                 2, 
                                 CONVERT(INT,
                                (
                                    SELECT [dbo].[fnGetPersonnelDetailsbyWorkPlaceId](@workPlaceId, 3)
                                )), 
                                 NULL, 
                                 NULL, 
                                 NULL, 
                                 NULL, 
                                 0, 
                                 0, 
                                 NULL, 
                                 NULL
                                );
                        END;
                        INSERT INTO dbo.DOCS_RELATED
                        (RelatedDocId, 
                         RelatedDocumentId, 
                         RelatedTypeId
                        )
                               SELECT @docId RelatedDocId, 
                                      r.DocId RelatedDocumentId, 
                                      1 RelatedTypeId
                               FROM @related r;
                        INSERT INTO dbo.DOCS_ADDRESSINFO
                        (AdrDocId, 
                         AdrTypeId, 
                         AdrOrganizationId, 
                         AdrAuthorId, 
                         AdrAuthorDepartmentName, 
                         AdrPersonId, 
                         AdrPositionId, 
                         FullName, 
                         AuthorPrevOrganization
                        )
                               SELECT @docID, 
                                      3, 
                                      da.AuthorOrganizationId, 
                                      a.AuthorId, 
                                      da.AuthorDepartmentname, 
                                      NULL, 
                                      da.AuthorPositionId, 
                                      (da.AuthorName + ' ' + da.AuthorSurname + ' ' + da.AuthorLastname) FullName, 
                                      a.PrevOrganization
                               FROM @author a
                                    INNER JOIN dbo.DOC_AUTHOR da ON a.AuthorId = da.AuthorId;
                END;
                    ELSE
                    IF(@operationType = 2) -- Update
                        BEGIN
                            SELECT @collectivCount = COUNT(0)
                            FROM @application ap
                            WHERE ap.AppRepresenterId = 1;
                            IF(@collectivCount > 1)
                                BEGIN
                                    SELECT @appFormType =
                                    (
                                        SELECT TOP 1 ap.AppFormType
                                        FROM @application ap
                                        WHERE ap.AppRepresenterId = 1
                                    );
                                    IF((@appFormType IS NULL)
                                       OR @appFormType = 2)
                                        BEGIN
                                            --SELECT @docEnterop2 = COUNT(0) + 1
                                            --FROM dbo.VW_DOC_INFO d WITH (TABLOCKX, HOLDLOCK)
                                            --WHERE d.DocDoctypeId = 2
                                            --      AND d.DocEnterno IS NOT NULL
                                            --      AND d.DocDuplicateId IS NULL
                                            --      AND d.DocOrganizationId = @orgId
                                            --      AND d.DocPeriodId = @periodId;
                                            --SELECT @docEnterop2 = MAX(s.rowOrder) + 1
                                            --FROM
                                            --(
                                            --    SELECT CONVERT(INT, LEFT(SUBSTRING(d.DocEnterno, CHARINDEX('-', d.DocEnterno) + 1, LEN(d.DocEnterno)), CHARINDEX('-', SUBSTRING(d.DocEnterno, CHARINDEX('-', d.DocEnterno) + 1, LEN(d.DocEnterno))) - 1)) AS rowOrder
                                            --    FROM dbo.VW_DOC_INFO d WITH (TABLOCKX, HOLDLOCK)
                                            --    WHERE d.DocDoctypeId = 2
                                            --          AND d.DocEnterno IS NOT NULL
                                            --          AND d.DocDuplicateId IS NULL
                                            --          AND d.DocOrganizationId = @orgId
                                            --          AND d.DocPeriodId = @periodId
                                            --) s;
                                            SELECT @docEnterop2 = CONVERT(NVARCHAR(MAX),
                                            (
                                                SELECT d.DocEnternop2
                                                FROM dbo.VW_DOC_INFO d
                                                WHERE d.DocId = @docId
                                                      AND d.DocPeriodId = 3
                                            ));
                                            SELECT @charIndex = CHARINDEX('/', d.DocEnterno)
                                            FROM dbo.VW_DOC_INFO d
                                            WHERE d.DocId = @docId
                                                  AND d.DocPeriodId = 3;
                                            IF(@charIndex = 0)
                                                BEGIN
                                                    SELECT @docEnterNo = 'KOL-' + CONVERT(NVARCHAR(MAX), (@docEnterop2)) + '-' + RIGHT('000' + CONVERT(NVARCHAR(MAX), @topicIndex), 3);
                                            END;
                                                ELSE
                                                BEGIN
                                                    SELECT @collectivCount = SUBSTRING(d.DocEnterno, CHARINDEX('/', d.DocEnterno) + 1, LEN(d.DocEnterno))
                                                    FROM dbo.VW_DOC_INFO d
                                                    WHERE d.DocId = @docId
                                                          AND d.DocPeriodId = 3;
                                                    SELECT @docEnterNo = 'KOL-' + CONVERT(NVARCHAR(MAX), (@docEnterop2)) + '-' + RIGHT('000' + CONVERT(NVARCHAR(MAX), @topicIndex), 3) + '/' + CONVERT(NVARCHAR(MAX), @colIndexCount);
                                            END;
                                    END;
                                        ELSE
                                        IF(@appFormType IN(1, 3))
                                            BEGIN
                                                SELECT @charIndex = CHARINDEX('/', s.DocEnter)
                                                FROM
                                                (
                                                    SELECT DISTINCT 
                                                           ap.DocEnterno AS DocEnter
                                                    FROM @application ap
                                                    WHERE ap.AppRepresenterId = 1
                                                ) s;
                                                IF(@charIndex = 0)
                                                    BEGIN
                                                        SELECT @docIndex =
                                                        (
                                                            SELECT DISTINCT 
                                                                   ap.DocEnterno AS DocEnter
                                                            FROM @application ap
                                                            WHERE ap.AppRepresenterId = 1
                                                        );
                                                        SELECT @colIndexCount = COUNT(0) + 1
                                                        FROM dbo.VW_DOC_INFO vdi
                                                        WHERE vdi.DocEnterno LIKE '%' + @docIndex + '%';
                                                END;
                                                    ELSE
                                                    BEGIN
                                                        SELECT @docIndex =
                                                        (
                                                            SELECT LEFT(s.DocEnter, CHARINDEX('/', s.DocEnter) - 1)
                                                            FROM
                                                            (
                                                                SELECT DISTINCT 
                                                                       ap.DocEnterno AS DocEnter
                                                                FROM @application ap
                                                                WHERE ap.AppRepresenterId = 1
                                                            ) s
                                                        );
                                                        SELECT @colIndexCount = COUNT(0) + 1
                                                        FROM dbo.VW_DOC_INFO vdi
                                                        WHERE vdi.DocEnterno LIKE '%' + @docIndex + '%';
                                                END;
                                                SELECT @docEnterop2 = LEFT(SUBSTRING(s.DocEnter, CHARINDEX('-', s.DocEnter) + 1, LEN(s.DocEnter)), CHARINDEX('-', SUBSTRING(s.DocEnter, CHARINDEX('-', s.DocEnter) + 1, LEN(s.DocEnter))) - 1)
                                                FROM
                                                (
                                                    SELECT DISTINCT 
                                                           ap.DocEnterno AS DocEnter
                                                    FROM @application ap
                                                    WHERE ap.AppRepresenterId = 1
                                                ) s;
                                                SELECT @docEnterNo = 'KOL-' + CONVERT(NVARCHAR(MAX), (@docEnterop2)) + '-' + RIGHT('000' + CONVERT(NVARCHAR(MAX), @topicIndex), 3) + '/' + CONVERT(NVARCHAR(MAX), @colIndexCount);
                                        END;
                            END;
                                ELSE
                                BEGIN
                                    SELECT @appFormType = ap.AppFormType
                                    FROM @application ap
                                    WHERE ap.AppRepresenterId = 1;
                                    IF EXISTS
                                    (
                                        SELECT d.DocEnterno, 
                                               d.DocTopicType, 
                                               d.DocTopicId
                                        FROM dbo.DOCS d
                                        WHERE d.DocEnterno =
                                        (
                                            SELECT ap.DocEnterno
                                            FROM @application ap
                                            WHERE ap.AppRepresenterId = 1
                                        )
                                              AND d.DocTopicType = @topicTypeId
                                              AND d.DocTopicId = @subtitleId
                                              AND d.DocDuplicateId = 2
                                    )
                                        BEGIN
                                            SET @appFormType = 1;
                                    END;
                                    SELECT @delegateCount = COUNT(0)
                                    FROM @application ap
                                    WHERE ap.AppRepresenterId = 2;
                                    IF(@appFormType IS NULL)
                                        BEGIN
                                            IF(@delegateCount = 0)
                                                BEGIN
                                                    SELECT @docEnterNo =
                                                    (
                                                        SELECT SUBSTRING(ap.AppSurname, 1, 1)
                                                        FROM @application ap
                                                        WHERE ap.AppRepresenterId = 1
                                                    ) + '-' + CONVERT(VARCHAR(MAX),
                                                    (
                                                        SELECT d.DocEnternop2
                                                        FROM dbo.VW_DOC_INFO d
                                                        WHERE d.DocId = @docId
                                                              AND d.DocPeriodId = @periodId
                                                    )) + '-' + RIGHT('000' + CONVERT(NVARCHAR(MAX), @topicIndex), 3);
                                            END;
                                                ELSE
                                                BEGIN
                                                    SELECT @docEnterNo =
                                                    (
                                                        SELECT SUBSTRING(ap.AppSurname, 1, 1)
                                                        FROM @application ap
                                                        WHERE ap.AppRepresenterId = 2
                                                    ) + '-' + CONVERT(VARCHAR(MAX),
                                                    (
                                                        SELECT d.DocEnternop2
                                                        FROM dbo.VW_DOC_INFO d
                                                        WHERE d.DocId = @docId
                                                              AND d.DocPeriodId = @periodId
                                                    )) + '-' + RIGHT('000' + CONVERT(NVARCHAR(MAX), @topicIndex), 3);
                                            END;
                                    END;
                                        ELSE
                                        IF(@appFormType = 1
                                           OR @appFormType = 3)
                                            BEGIN
                                                IF(@delegateCount = 0)
                                                    BEGIN
                                                        SELECT @docIndex = SUBSTRING(ap.DocEnterno, 1, CHARINDEX('/', ap.DocEnterno + '/') - 1)
                                                        FROM @application ap
                                                        WHERE ap.AppRepresenterId = 1;
                                                        SELECT @docEnterNoCount = d.DocEnternop2
                                                        FROM dbo.VW_DOC_INFO d WITH (TABLOCKX, HOLDLOCK)
                                                        WHERE d.DocId = @docId
                                                              AND d.DocEnterno IS NOT NULL
                                                              AND d.DocPeriodId = @periodId;
                                                        SELECT @docEnterNo =
                                                        (
                                                            SELECT @docIndex
                                                        ) + '/' + CONVERT(NVARCHAR(MAX), @docEnterNoCount);
                                                END;
                                                    ELSE
                                                    BEGIN
                                                        SELECT @docIndex =
                                                        (
                                                            SELECT SUBSTRING(ap.AppSurname, 1, 1)
                                                            FROM @application ap
                                                            WHERE ap.AppRepresenterId = 2
                                                        ) + '' + SUBSTRING(ap.DocEnterno, 2, CHARINDEX('/', ap.DocEnterno + '/') - 1)
                                                        FROM @application ap
                                                        WHERE ap.AppRepresenterId = 1;
                                                        SELECT @docEnterNoCount = d.DocEnternop2
                                                        FROM dbo.VW_DOC_INFO d
                                                        WHERE d.DocId = @docId
                                                              AND d.DocEnterno IS NOT NULL
                                                              AND d.DocPeriodId = @periodId;
                                                        SELECT @docEnterNo =
                                                        (
                                                            SELECT @docIndex
                                                        ) + '/' + CONVERT(NVARCHAR(MAX), @docEnterNoCount);
                                                END;
                                        END;
                                            ELSE
                                            IF(@appFormType = 2)
                                                BEGIN
                                                    IF(@delegateCount = 0)
                                                        BEGIN
                                                            SELECT @docIndex = SUBSTRING(ap.DocEnterno, CHARINDEX('-', ap.DocEnterno) + 1, LEN(ap.DocEnterno))
                                                            FROM @application ap
                                                            WHERE ap.AppRepresenterId = 1;
                                                            SELECT @docEnterNo =
                                                            (
                                                                SELECT LEFT(ap.DocEnterno, CHARINDEX('-', ap.DocEnterno))
                                                            ) +
                                                            (
                                                                SELECT LEFT(
                                                                (
                                                                    SELECT @docIndex
                                                                ), CHARINDEX('-',
                                                                (
                                                                    SELECT @docIndex
                                                                )))
                                                            ) + RIGHT('000' + CONVERT(NVARCHAR(MAX), @topicIndex), 3)
                                                            FROM @application ap
                                                            WHERE ap.AppRepresenterId = 1;
                                                    END;
                                                        ELSE
                                                        BEGIN
                                                            SELECT @docIndex =
                                                            (
                                                                SELECT SUBSTRING(ap.AppSurname, 1, 1)
                                                                FROM @application ap
                                                                WHERE ap.AppRepresenterId = 2
                                                            ) + '' + SUBSTRING(ap.DocEnterno, 2, CHARINDEX('/', ap.DocEnterno + '/') - 1)
                                                            FROM @application ap
                                                            WHERE ap.AppRepresenterId = 1;
                                                            SELECT @docEnterNo =
                                                            (
                                                                SELECT LEFT(ap.DocEnterno, CHARINDEX('-', ap.DocEnterno))
                                                            ) +
                                                            (
                                                                SELECT LEFT(
                                                                (
                                                                    SELECT @docIndex
                                                                ), CHARINDEX('-',
                                                                (
                                                                    SELECT @docIndex
                                                                )))
                                                            ) + RIGHT('000' + CONVERT(NVARCHAR(MAX), @topicIndex), 3)
                                                            FROM @application ap
                                                            WHERE ap.AppRepresenterId = 2;
                                                    END;
                                            END;
                            END;
                            IF((@executionStatusId = 0)
                               OR @executionStatusId = 2
                               OR @executionStatusId = 3)
                                BEGIN
                                    IF(@executionStatusId = 0)
                                        BEGIN
                                            SELECT @executionStatusId = 2;
                                            SELECT @plannedDate = DATEADD(DAY, 15, GETDATE());
                                    END;
                                        ELSE
                                        IF(((@executionStatusId = 2)
                                            OR (@executionStatusId = 3))
                                           AND (@plannedDate IS NULL))
                                            BEGIN
                                                SELECT @plannedDate = DATEADD(DAY, 15, GETDATE());
                                        END;
                            END;
                                ELSE
                                BEGIN
                                    SELECT @plannedDate = NULL;
                            END;
                            IF(@numberOfApplicants = -1)
                                BEGIN
                                    SET @numberOfApplicants = 1;
                            END;
                            UPDATE dbo.DOCS
                              SET 
                                  DocEnterno = @docEnterNo, 
                                  DocEnterdate = @docEnterDate, 
                                  DocApplytypeId = @applytypeId, 
                                  DocTopicType = @topicTypeId, 
                                  DocTopicId = @subtitleId, 
                                  DocExecutionStatusId = @executionStatusId, 
                                  DocReceivedFormId = @receivedFormId, 
                                  DocPlannedDate = @plannedDate, 
                                  DocFormId = @typeOfDocumentId, 
                                  DocDocno = @docNo, 
                                  DocDocdate = @docDate, 
                                  DocUndercontrolStatusId = @supervision, 
                                  DocDescription = @shortContent, 
                                  DocDeleted = @docDeleted, 
                                  DocDeletedByDate = dbo.SYSDATETIME(), 
                                  DocDuplicateId = @appFormType
                            WHERE DocId = @docId;
                            UPDATE dbo.DOCS_ADDITION
                              SET 
                                  Field1 = @numberOfApplicants, -- float
                                  Field2 = @organizationId, -- float
                                  Field3 = @subordinateId, -- float         
                                  Field16 = @corruption -- bit
                            WHERE DocumentId = @docId;
                            IF(@whomAddressId <> 0)
                                BEGIN
                                    UPDATE dbo.DOCS_ADDRESSINFO
                                      SET 
                                          AdrOrganizationId = CONVERT(INT,
                                    (
                                        SELECT [dbo].[fnGetPersonnelDetailsbyWorkPlaceId](@whomAddressId, 3)
                                    )), 
                                          AdrAuthorDepartmentName = CONVERT(NVARCHAR(MAX),
                                    (
                                        SELECT [dbo].[fnGetPersonnelDetailsbyWorkPlaceId](@whomAddressId, 2)
                                    )), 
                                          AdrPersonId = @whomAddressId, 
                                          FullName = CONVERT(NVARCHAR(MAX),
                                    (
                                        SELECT [dbo].[fnGetPersonnelDetailsbyWorkPlaceId](@whomAddressId, 1)
                                    ))
                                    WHERE AdrDocId = @docId
                                          AND AdrTypeId = 2;
                            END;
                                ELSE
                                BEGIN
                                    UPDATE dbo.DOCS_ADDRESSINFO
                                      SET 
                                          AdrOrganizationId = CONVERT(INT,
                                    (
                                        SELECT [dbo].[fnGetPersonnelDetailsbyWorkPlaceId](@workPlaceId, 3)
                                    )), 
                                          dbo.DOCS_ADDRESSINFO.FullName = NULL, 
                                          dbo.DOCS_ADDRESSINFO.AdrPersonId = NULL
                                    WHERE AdrDocId = @docId
                                          AND AdrTypeId = 2;
                            END;
                            INSERT INTO dbo.DOCS_RELATED
                            (RelatedDocId, 
                             RelatedDocumentId, 
                             RelatedTypeId
                            )
                                   SELECT @docId RelatedDocId, 
                                          r.DocId RelatedDocumentId, 
                                          1 RelatedTypeId
                                   FROM @related r;
                            INSERT INTO dbo.DOCS_ADDRESSINFO
                            (AdrDocId, 
                             AdrTypeId, 
                             AdrOrganizationId, 
                             AdrAuthorId, 
                             AdrAuthorDepartmentName, 
                             AdrPersonId, 
                             AdrPositionId, 
                             FullName, 
                             AuthorPrevOrganization
                            )
                                   SELECT @docID, 
                                          3, 
                                          da.AuthorOrganizationId, 
                                          a.AuthorId, 
                                          da.AuthorDepartmentname, 
                                          NULL, 
                                          da.AuthorPositionId, 
                                          (da.AuthorName + ' ' + da.AuthorSurname + ' ' + da.AuthorLastname) FullName, 
                                          a.PrevOrganization
                                   FROM @author a
                                        INNER JOIN dbo.DOC_AUTHOR da ON a.AuthorId = da.AuthorId;
                            DELETE dbo.DOCS_APPLICATION
                            WHERE AppDocId = @docId;
                            INSERT INTO dbo.DOCS_APPLICATION
                            (AppDocId, 
                             AppApplierTypeId, 
                             AppFirstname, 
                             AppSurname, 
                             AppLastName, 
                             AppSosialStatusId, 
                             AppCountry1Id, 
                             AppRegion1Id, 
                             AppAddress1, 
                             AppRepresenterId, 
                             AppPhone1, 
                             AppEmail1
                            )
                                   SELECT @docId AppDocId, 
                                          @docTypeId AppApplierTypeId, 
                                          ap.AppFirstname, 
                                          ap.AppSurname, 
                                          ap.AppLastName, 
                                          ap.AppSosialStatusId, 
                                          ap.AppCountryId, 
                                          ap.AppRegionId, 
                                          ap.AppAddress, 
                                          ap.AppRepresenterId, 
                                          ap.AppPhone, 
                                          ap.AppEmail
                                   FROM @application ap;
                    END;
                        ELSE
                        IF(@operationType = 3) -- Delete 
                            BEGIN
                                IF(@formTypeId = 0)
                                    BEGIN
                                        DELETE FROM dbo.DOCS_ADDRESSINFO
                                        WHERE AdrId = @rowId;
                                END;
                                    ELSE
                                    IF(@formTypeId = 1)
                                        BEGIN
                                            DELETE FROM dbo.DOCS_RELATED
                                            WHERE RelatedId = @rowId;
                                    END;
                        END;
            IF @@ERROR = 0
                BEGIN
                    SET @result = 1; -- 1 IS FOR SUCCESSFULLY EXECUTED
                    COMMIT TRANSACTION;
            END;
                ELSE
                BEGIN
                    ROLLBACK TRANSACTION;
                    SET @result = 0; -- 0 WHEN AN ERROR HAS OCCURED
            END;
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION;
            SET @result = -1;
            DECLARE @ErrorProcedure NVARCHAR(MAX), @ErrorMessage NVARCHAR(MAX), @ErrorSeverity INT, @ErrorState INT;
            SELECT @ErrorProcedure = 'Procedure:' + ERROR_PROCEDURE(), 
                   @ErrorMessage = @ErrorProcedure + '.Message:' + ERROR_MESSAGE() + ' Line ' + CAST(ERROR_LINE() AS NVARCHAR(5)), 
                   @ErrorSeverity = ERROR_SEVERITY(), 
                   @ErrorState = ERROR_STATE();
            INSERT INTO dbo.debugTable
            ([text], 
             insertDate
            )
            VALUES
            (@ErrorMessage, 
             dbo.SYSDATETIME()
            );
            RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
        END CATCH;
    END;
