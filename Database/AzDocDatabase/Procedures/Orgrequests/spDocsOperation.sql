
/*
Migrated by Kamran A-eff 23.08.2019
*/
/*
Migrated by Kamran A-eff 06.08.2019
*/
/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [orgrequests].[spDocsOperation] @operationType     INT, 
                                                @workPlaceId       INT                        = NULL, 
                                                @docTypeId         INT                        = NULL, 
                                                @docDeleted        INT                        = NULL, 
                                                @documentStatusId  INT                        = NULL, 
                                                @docEnterDate      DATE                       = NULL, 
                                                @topicTypeId       INT                        = NULL, 
                                                @docNo             NVARCHAR(MAX)              = NULL, 
                                                @whomAddressId     INT                        = NULL, 
                                                @receivedFormId    INT                        = NULL, 
                                                @docDate           DATE                       = NULL, 
                                                @typeOfDocumentId  INT                        = NULL, 
                                                @executionStatusId INT                        = NULL, 
                                                @plannedDate       DATE                       = NULL, 
                                                @docIsAppealBoard  BIT                        = NULL, 
                                                @docDuplicateId    BIT                        = NULL, 
                                                @supervision       BIT                        = NULL, 
                                                @shortContent      NVARCHAR(MAX)              = NULL, 
                                                @rowId             INT                        = NULL, 
                                                @formTypeId        INT                        = NULL, 
                                                @related           [dbo].[UdttRelated] READONLY, 
                                                @author            [orgrequests].[UdttAuthor] READONLY, 
                                                @tasks             [orgrequests].[UdttTask] READONLY, 
                                                @taskId            INT                        = NULL, 
                                                @docId             INT                        = NULL OUTPUT, 
                                                @result            INT OUTPUT
AS
    BEGIN
        SET NOCOUNT ON;
        SET TRANSACTION ISOLATION LEVEL READ COMMITTED; -- turn it on
        BEGIN TRANSACTION;
        BEGIN TRY
            DECLARE @date DATE= dbo.SYSDATETIME(), @periodId INT, @orgId INT, @docDocno NVARCHAR(20)= NULL, @docEnterNo NVARCHAR(30)= NULL, @docIndex NVARCHAR(20)= NULL, @organizationIndex INT, @answerCount INT= 0, @docEnterop2 INT= NULL;
            SET @docTypeId = 1;
			IF NOT EXISTS (SELECT d.* FROM dbo.DOCS d WHERE d.DocId=@docId AND d.DocDoctypeId=@docTypeId AND d.DocDeleted IN (CASE WHEN @operationType=0 then 3 ELSE 0 end))
			BEGIN					
				THROW 56000,N'Sənədin yaradılmasında problem yarandı.Zəhmət olmasa sənədin yaradılmasına yenidən cəhd edin',1;
			END;
            --Periodu tapiram
            SELECT @periodId = dp.PeriodId            --periodId=1
            FROM DOC_PERIOD dp
            WHERE dp.PeriodDate1 <= @date
                  AND dp.PeriodDate2 >= @date;

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
                        SELECT @organizationIndex = o.OrganizationIndex
                        FROM dbo.DC_ORGANIZATION o
                        WHERE o.OrganizationId =
                        (
                            SELECT wp.WorkplaceOrganizationId
                            FROM dbo.DC_WORKPLACE wp
                            WHERE wp.WorkplaceId = @workPlaceId
                        );
                        IF(@executionStatusId = 5)    --Raziliq
                            BEGIN
                                SELECT @docEnterop2 =isnull(COUNT(DISTINCT d.DocEnternop2),0) + 1
                                FROM dbo.VW_DOC_INFO d WITH (TABLOCKX, HOLDLOCK)
                                WHERE d.DocDoctypeId = @docTypeId
                                      AND d.DocEnterno IS NOT NULL
                                      AND d.DocExecutionStatusId = 5
                                      AND d.DocPeriodId = @periodId
                                      AND d.DocOrganizationId = @orgId;
                                IF(@orgId = 1)
                                    BEGIN
                                        SELECT @docEnterop2 = @docEnterop2 + 1;
                                END;
                                SELECT @docIndex = 'V';
                                SELECT @docEnterno =
                                (
                                    SELECT @docIndex
                                ) + RIGHT(CONVERT(VARCHAR(MAX), (@docEnterop2)), 5);
                        END;
                            ELSE
                            IF(@docIsAppealBoard = 1)
                                BEGIN
                                    SELECT @docEnterop2 = isnull(COUNT(DISTINCT d.DocEnternop2),0) + 1
                                    FROM dbo.VW_DOC_INFO d WITH (TABLOCKX, HOLDLOCK)
                                    WHERE d.DocDoctypeId = @docTypeId
                                          AND d.DocEnterno IS NOT NULL
                                          AND d.DocIsAppealBoard = 1
                                          AND d.DocPeriodId = @periodId
                                          AND d.DocOrganizationId = @orgId;
                                    SELECT @docEnterno = N'AŞ' + RIGHT(CONVERT(VARCHAR(MAX), (@docEnterop2)), 5);
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
                                    --SELECT @docEnterop2= COUNT(DISTINCT d.DocEnternop2) + 1
                                    --                             FROM dbo.VW_DOC_INFO d WITH(tablockx,holdlock)
                                    --                             WHERE d.DocDoctypeId = @docTypeId AND d.DocEnterno IS not NULL
                                    --		AND d.DocPeriodId=@periodId
                                    --		AND d.DocOrganizationId=@orgId;

                                    SELECT @docEnterop2 =isnull(MAX(s.rowOrder),0) + 1
                                    FROM
                                    (
                                        SELECT CONVERT(INT, LEFT(SUBSTRING(d.DocEnterno, CHARINDEX('/', d.DocEnterno) + 1, LEN(d.DocEnterno)), CHARINDEX('-', SUBSTRING(d.DocEnterno, CHARINDEX('/', d.DocEnterno) + 1, LEN(d.DocEnterno))) - 1)) AS rowOrder
                                        FROM dbo.VW_DOC_INFO d
                                        WHERE d.DocDoctypeId = 1
                                              AND d.DocEnterno IS NOT NULL
                                              AND d.DocPeriodId = @periodId
                                              AND d.DocOrganizationId = @orgId
                                              AND d.DocIsAppealBoard <> 1
                                              AND d.DocExecutionStatusId <> 5
                                    ) s;
                                    SELECT @docEnterno = CONVERT(NVARCHAR(MAX), @organizationIndex) + '/' + RIGHT(CONVERT(VARCHAR(MAX), (@docEnterop2)), 5) + '-' +
                                    (
                                        SELECT FORMAT(@date, 'yy')
                                    );
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
                              DocTopicType = @topicTypeId, 
                              DocDocno = @docNo, 
                              DocReceivedFormId = @receivedFormId, 
                              DocDocdate = @docDate, 
                              DocFormId = @typeOfDocumentId, 
                              DocExecutionStatusId = @executionStatusId, 
                              DocPlannedDate = @plannedDate, 
                              DocIsAppealBoard = @docIsAppealBoard, 
                              DocDuplicateId = @docDuplicateId, 
                              DocUndercontrolStatusId = @supervision, 
                              DocDocumentstatusId = @documentStatusId, 
                              DocDescription = @shortContent, 
                              DocDeleted = @docDeleted, 
                              DocDeletedByDate = dbo.SYSDATETIME(), 
                              DocDocumentOldStatusId =
                        (
                            SELECT d.DocDocumentstatusId
                            FROM dbo.docs d
                            WHERE d.DocId = @docId
                        )
                        WHERE DocId = @docId;
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
                               FROM @related r
                               UNION
                               SELECT r.DocId RelatedDocumentId, 
                                      @docId RelatedDocId, 
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
                        IF(@typeOfDocumentId = 12)
                            BEGIN
                                INSERT INTO dbo.DOC_TASK
                                (TaskDocId, 
                                 TypeOfAssignmentId, 
                                 TaskNo, 
                                 TaskDecription, 
                                 WhomAddressId, 
                                 OrganizationId, 
                                 TaskStatus, 
                                 TaskCreateWorkPlaceId, 
                                 TaskCreateDate
                                )
                                       SELECT @docId, 
                                              t.TypeOfAssignment, 
                                              t.TaskNo, 
                                              t.Task, 
                                              t.WhomAddressId, 
                                              @orgId, 
                                              @documentStatusId TaskStatus, 
                                              @workPlaceId TaskCreateWorkPlaceId, 
                                              dbo.SYSDATETIME() TaskCreateDate
                                       FROM @tasks t;
                        END;
                END;
                    ELSE
                    IF(@operationType = 2) -- Update
                        BEGIN
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
                            UPDATE dbo.DOCS
                              SET 
                                  DocEnterdate = @docEnterDate, 
                                  DocTopicType = @topicTypeId, 
                                  DocDocno = @docNo, 
                                  DocReceivedFormId = @receivedFormId, 
                                  DocDocdate = @docDate, 
                                  DocFormId = @typeOfDocumentId, 
                                  DocExecutionStatusId = @executionStatusId, 
                                  DocPlannedDate = @plannedDate, 
                                  DocIsAppealBoard = @docIsAppealBoard, 
                                  DocDuplicateId = @docDuplicateId, 
                                  DocUndercontrolStatusId = @supervision, 
                                  DocDescription = @shortContent, 
                                  DocDeleted = @docDeleted, 
                                  DocDeletedByDate = dbo.SYSDATETIME()
                            WHERE DocId = @docId;
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
                            IF(@typeOfDocumentId = 12)
                                BEGIN
                                    INSERT INTO dbo.DOC_TASK
                                    (TaskDocId, 
                                     TypeOfAssignmentId, 
                                     TaskNo, 
                                     TaskDecription, 
                                     WhomAddressId, 
                                     OrganizationId, 
                                     TaskStatus, 
                                     TaskCreateWorkPlaceId, 
                                     TaskCreateDate
                                    )
                                           SELECT @docId, 
                                                  t.TypeOfAssignment, 
                                                  t.TaskNo, 
                                                  t.Task, 
                                                  t.WhomAddressId, 
                                                  @orgId, 
                                                  @documentStatusId TaskStatus, 
                                                  @workPlaceId TaskCreateWorkPlaceId, 
                                                  dbo.SYSDATETIME() TaskCreateDate
                                           FROM @tasks t;
                            END;
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
                                        ELSE
                                        IF(@formTypeId = 2)
                                            BEGIN
                                                DELETE FROM dbo.DOC_TASK
                                                WHERE TaskId = @rowId;
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
