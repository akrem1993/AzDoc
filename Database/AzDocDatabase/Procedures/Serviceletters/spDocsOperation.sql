
/*
Migrated by Kamran A-eff 23.08.2019
*/
/*
Migrated by Kamran A-eff 06.08.2019
*/
/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [serviceletters].[spDocsOperation] @operationType      INT, 
                                                   @workPlaceId        INT                                = NULL, 
                                                   @docTypeId          INT                                = NULL, 
                                                   @docDeleted         INT                                = NULL, 
                                                   @documentStatusId   INT                                = NULL, 
                                                   @docEnterDate       DATE                               = NULL, 
                                                   @signatoryPersonId  INT                                = NULL, 
                                                   @confirmingPersonId INT                                = NULL, 
                                                   @plannedDate        DATE                               = NULL, 
                                                   @shortContent       NVARCHAR(MAX)                      = NULL, 
                                                   @formTypeId         INT                                = NULL, 
                                                   @rowId              INT                                = NULL, 
												   @taskId			   INT                                = NULL, 
                                                   @whomAddress        [serviceletters].[UdttWhomAddress] READONLY, 
                                                   @related            [dbo].[UdttRelated] READONLY, 
                                                   @answer             [dbo].[UdttAnswer] READONLY, 
                                                   @docId              INT                                = NULL OUTPUT, 
                                                   @result             INT OUTPUT
AS
    BEGIN
		
        SET NOCOUNT ON;
        SET TRANSACTION ISOLATION LEVEL READ COMMITTED; -- turn it on
        BEGIN TRANSACTION;
        BEGIN TRY
            DECLARE @date DATE= dbo.SYSDATETIME(), @periodId INT, @orgId INT, @docDocno NVARCHAR(20)= NULL, @docIndex INT, @answerCount INT= 0, @docEnterno NVARCHAR(MAX)= NULL, @organizationIndex INT, @organizationId INT, @departmentId INT, @departmentTopId INT;   
            --Periodu tapiram
            SET @docTypeId = 18;
			IF(@docId IS NOT NULL)
			begin
				IF NOT EXISTS (SELECT d.* FROM dbo.DOCS d WHERE d.DocId=@docId AND d.DocDoctypeId=@docTypeId AND d.DocDeleted IN (CASE WHEN @operationType=0 then 3 ELSE 0 end))
				BEGIN					
					THROW 56000,N'Sənədin yaradılmasında problem yarandı.Zəhmət olmasa sənədin yaradılmasına yenidən cəhd edin',1;
				END;

				IF EXISTS (SELECT a.* FROM @answer a WHERE a.DocId=@docId)
				BEGIN
					THROW 56000,N'Cavab sənədinin əlavə olunmasında problem yarandı.Zəhmət olmasa sənədin yaradılmasına yenidən cəhd edin',1;
				end;

				if(@plannedDate IS NOT NULL AND @plannedDate<dbo.sysdatetime())
				BEGIN
					THROW 56000,N'İcra müddəti cari tarixdən kicikdir.Zəhmət olmasa icra müddətini artırın',1;
				end
			 end

            SELECT @periodId = dp.PeriodId
            FROM DOC_PERIOD dp
            WHERE dp.PeriodDate1 <= @date
                  AND dp.PeriodDate2 >= @date;
            -- Organization Id-sini tapiram
            SELECT @orgId =
            (
                SELECT dbo.fnPropertyByWorkPlaceId(@workPlaceId, 12)
            );
            --SELECT @docIndex = (COUNT(0) + 1)
            --FROM dbo.VW_DOC_INFO d WITH (TABLOCKX, HOLDLOCK)
            --WHERE d.DocDoctypeId = @docTypeId
            --      AND d.DocDocno IS NOT NULL
            --      AND d.DocPeriodId = @periodId;
            -- DocDocumentstatusId=31  ==> Ilk defe sened yaradilanda qaralama statusunda dusur..(Table: dbo.DOC_DOCUMENTSTATUS)

            --IF(@operationType = 1) --Insert
            --    BEGIN
            --        INSERT INTO dbo.DOCS
            --        (DocPeriodId, 
            --         DocOrganizationId, 
            --         DocDoctypeId, 
            --         DocDeleted, 
            --         DocDeletedByDate, 
            --         DocInsertedById, 
            --         DocInsertedByDate
            --        )
            --        VALUES
            --        (@periodId, 
            --         @orgId, 
            --         @docTypeId, 
            --         @docDeleted, 
            --         dbo.SYSDATETIME(), 
            --         @workPlaceId, 
            --         dbo.SYSDATETIME()
            --        );
            --        SET @docId = SCOPE_IDENTITY();
            --END;
            --    ELSE

                IF(@operationType = 0) -- Save 
                    BEGIN
                        DECLARE @docOrder INT= 0;
                        SELECT @organizationId = dw.WorkplaceOrganizationId, 
                               @departmentId = dw.WorkplaceDepartmentId
                        FROM dbo.DC_WORKPLACE dw
                        WHERE dw.WorkplaceId = @workPlaceId;
                        SELECT @departmentTopId = dd.DepartmentTopId
                        FROM dbo.DC_DEPARTMENT dd
                        WHERE dd.DepartmentId = @departmentId;
                        IF EXISTS
                        (
                            SELECT dd.DepartmentId
                            FROM dbo.DC_DEPARTMENT dd
                            WHERE dd.DepartmentId = @departmentTopId
                                  AND dd.DepartmentTypeId = 4
                        )
                            BEGIN
                                IF(@organizationId in(11, 20))
                                    BEGIN
                                        SELECT @docEnterno = CONVERT(NVARCHAR(MAX),
                                        (
                                        (
                                            SELECT TRIM(do.OrganizationIndex)
                                            FROM dbo.DC_ORGANIZATION do
                                            WHERE do.OrganizationId = @organizationId
                                        )
                                        ) + '-' + CONVERT(NVARCHAR(MAX),
                                        (
                                            SELECT TRIM(dd.DepartmentIndex)
                                            FROM dbo.DC_DEPARTMENT dd
                                            WHERE dd.DepartmentId = @departmentTopId
                                        )) + '/' + CONVERT(NVARCHAR(MAX),
                                        (
                                            SELECT TRIM(dd.DepartmentIndex)
                                            FROM dbo.DC_DEPARTMENT dd
                                            WHERE dd.DepartmentId = @departmentId
                                        )) + '/' + CONVERT(NVARCHAR(MAX),
                                        (
                                            SELECT COUNT(0) + 1
                                            FROM dbo.VW_DOC_INFO d WITH (TABLOCKX, HOLDLOCK)
                                            WHERE d.DocDoctypeId = 18
                                                  AND d.DocEnterno IS NOT NULL
                                                  AND d.DocOrganizationId = @organizationId
                                                  AND d.DocTopDepartmentId = CASE
                                                                                 WHEN @organizationId in(11, 20)
                                                                                 THEN @departmentId
                                                                                 ELSE d.DocTopDepartmentId
                                                                             END
                                                  AND d.DocPeriodId = @periodId
                                        )) + '-' +
                                        (
                                            SELECT FORMAT(dbo.SYSDATETIME(), 'yy')
                                        ));
									END;
                                    ELSE
                                    BEGIN
                                        SELECT @docOrder = (MAX(CONVERT(INT, s.rowOrder))) + 1
                                        FROM
                                        (
                                            SELECT msdb.dbo.[fnRegexReplace](d.DocEnterno, '.*/(\d+)-\d+', '$1') AS rowOrder, 
                                                   d.DocOrganizationId
                                            FROM dbo.VW_DOC_INFO d WITH (TABLOCKX, HOLDLOCK)
                                            WHERE d.DocDoctypeId = 18
                                                  AND d.DocEnterno IS NOT NULL
                                                  AND d.DocOrganizationId = @organizationId
                                                  AND d.DocPeriodId = @periodId
                                        ) s;
                                        SELECT @docEnterno = CONVERT(NVARCHAR(MAX),
                                        (
                                        (
                                            SELECT TRIM(do.OrganizationIndex)
                                            FROM dbo.DC_ORGANIZATION do
                                            WHERE do.OrganizationId = @organizationId
                                        )
                                        ) + '-' + CONVERT(NVARCHAR(MAX),
                                        (
                                            SELECT TRIM(dd.DepartmentIndex)
                                            FROM dbo.DC_DEPARTMENT dd
                                            WHERE dd.DepartmentId = @departmentId
                                        )) + '/' + CONVERT(NVARCHAR(MAX),
                                        (
                                            SELECT TRIM(dd.DepartmentIndex)
                                            FROM dbo.DC_DEPARTMENT dd
                                            WHERE dd.DepartmentId = @departmentTopId
                                        )) + '/' + CONVERT(NVARCHAR(MAX),
                                        (
                                            SELECT @docOrder
                                        )) + '-' +
                                        (
                                            SELECT FORMAT(dbo.SYSDATETIME(), 'yy')
                                        ));
                                END;
                        END;
                            ELSE
                            BEGIN
                                IF(@organizationId in(11, 20))
                                    BEGIN
                                        SELECT @docEnterno = CONVERT(NVARCHAR(MAX),
                                        (
                                        (
                                            SELECT TRIM(do.OrganizationIndex)
                                            FROM dbo.DC_ORGANIZATION do
                                            WHERE do.OrganizationId = @organizationId
                                        )
                                        ) + '-' + CONVERT(NVARCHAR(MAX),
                                        (
                                            SELECT TRIM(dd.DepartmentIndex)
                                            FROM dbo.DC_DEPARTMENT dd
                                            WHERE dd.DepartmentId = @departmentId
                                        )) + '/' + CONVERT(NVARCHAR(MAX),
                                        (
                                            SELECT COUNT(0) + 1
                                            FROM dbo.VW_DOC_INFO d WITH (TABLOCKX, HOLDLOCK)
                                            WHERE d.DocDoctypeId = 18
                                                  AND d.DocEnterno IS NOT NULL
                                                  AND d.DocOrganizationId = @organizationId
                                                  AND d.DocTopDepartmentId = CASE
                                                                                 WHEN @organizationId IN (11 , 20)
                                                                                 THEN @departmentId
                                                                                 ELSE d.DocTopDepartmentId
                                                                             END
                                                  AND d.DocPeriodId = @periodId
                                        )) + '-' +
                                        (
                                            SELECT FORMAT(dbo.SYSDATETIME(), 'yy')
                                        ));
                                END;
                                    ELSE
                                    BEGIN
                                        SELECT @docOrder = (MAX(CONVERT(INT, s.rowOrder))) + 1
                                        FROM
                                        (
                                            SELECT msdb.dbo.[fnRegexReplace](d.DocEnterno, '.*/(\d+)-\d+', '$1') AS rowOrder, 
                                                   d.DocOrganizationId
                                            FROM dbo.VW_DOC_INFO d WITH (TABLOCKX, HOLDLOCK)
                                            WHERE d.DocDoctypeId = 18
                                                  AND d.DocEnterno IS NOT NULL
                                                  AND d.DocOrganizationId = @organizationId
                                                  AND d.DocPeriodId = @periodId
                                        ) s;
                                        SELECT @docEnterno = CONVERT(NVARCHAR(MAX),
                                        (
                                        (
                                            SELECT TRIM(do.OrganizationIndex)
                                            FROM dbo.DC_ORGANIZATION do
                                            WHERE do.OrganizationId = @organizationId
                                        )
                                        ) + '-' + CONVERT(NVARCHAR(MAX),
                                        (
                                            SELECT TRIM(dd.DepartmentIndex)
                                            FROM dbo.DC_DEPARTMENT dd
                                            WHERE dd.DepartmentId = @departmentId
                                        )) + '/' + CONVERT(NVARCHAR(MAX),
                                        (
                                            SELECT @docOrder
                                        )) + '-' +
                                        (
                                            SELECT FORMAT(dbo.SYSDATETIME(), 'yy')
                                        ));
                                END;
                        END;
                        UPDATE dbo.DOCS
                          SET 
                              DocEnterno = @docEnterno, 
                              DocEnterdate = @docEnterDate, 
                              DocDocdate = GETDATE(), 
                              DocPlannedDate = @plannedDate, 
                              DocDocumentstatusId = @documentStatusId, 
                              DocDescription = @shortContent, 
                              DocDeleted = @docDeleted, 
                              DocDeletedByDate = dbo.SYSDATETIME(), 
                              DocDocumentOldStatusId =
                        (
                            SELECT d.DocDocumentstatusId
                            FROM dbo.docs d
                            WHERE d.DocId = @docId
                        ), 
                              DocTopDepartmentId = @departmentId
                        WHERE DocId = @docId;

                        --İmza edən şəxs (AdrTypeId = 1)
                        --Təsdiq edən şəxs (AdrTypeId = 2)
                        --Təşkilat məlumatları (AdrTypeId = 3)  
                        IF NOT EXISTS
                        (
                            SELECT da.*
                            FROM dbo.DOCS_ADDRESSINFO da
                            WHERE da.AdrDocId = @docId
                                  AND da.AdrTypeId IN(1, 2)
                        )
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
                                 1, 
                                 CONVERT(INT,
                                (
                                    SELECT [dbo].[fnGetPersonnelDetailsbyWorkPlaceId](@signatoryPersonId, 3)
                                )), 
                                 NULL, 
                                 CONVERT(NVARCHAR(MAX),
                                (
                                    SELECT [dbo].[fnGetPersonnelDetailsbyWorkPlaceId](@signatoryPersonId, 2)
                                )), 
                                 @signatoryPersonId, 
                                 NULL, 
                                 0, 
                                 0, 
                                 CONVERT(NVARCHAR(MAX),
                                (
                                    SELECT [dbo].[fnGetPersonnelDetailsbyWorkPlaceId](@signatoryPersonId, 1)
                                )), 
                                 NULL
                                ),
                                (@docId, 
                                 2, 
                                 CONVERT(INT,
                                (
                                    SELECT [dbo].[fnGetPersonnelDetailsbyWorkPlaceId](@confirmingPersonId, 3)
                                )), 
                                 NULL, 
                                 CONVERT(NVARCHAR(MAX),
                                (
                                    SELECT [dbo].[fnGetPersonnelDetailsbyWorkPlaceId](@confirmingPersonId, 2)
                                )), 
                                 @confirmingPersonId, 
                                 NULL, 
                                 0, 
                                 0, 
                                 CONVERT(NVARCHAR(MAX),
                                (
                                    SELECT [dbo].[fnGetPersonnelDetailsbyWorkPlaceId](@confirmingPersonId, 1)
                                )), 
                                 NULL
                                );
                                INSERT INTO dbo.DOC_TASK
                                (
                                --TaskId - column value is auto-generated
                                TaskDocId, 
                                TypeOfAssignmentId, 
                                WhomAddressId, 
                                OrganizationId, 
                                TaskStatus, 
                                TaskCreateWorkPlaceId, 
                                TaskCreateDate
                                )
                                       SELECT @docId AS TaskDocId, 
                                              w.ExecutionStatus AS TypeOfAssignmentId, 
                                              w.WhomAddress AS WhomAddressId, 
                                              @orgId AS OrganizationId, 
                                              @documentStatusId AS TaskStatus, 
                                              @workPlaceId AS TaskCreateWorkPlaceId, 
                                              dbo.SYSDATETIME() AS TaskCreateDate
                                       FROM @whomAddress w;
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
                        INSERT INTO dbo.DOCS_RELATED
                        (RelatedDocId, 
                         RelatedDocumentId, 
                         RelatedTypeId
                        )
                               SELECT @docId RelatedDocId, 
                                      a.DocId RelatedDocumentId, 
                                      2 RelatedTypeId
                               FROM @answer a;
                        SELECT @answerCount = COUNT(0)
                        FROM @answer;
                        IF(@answerCount > 0)
                            BEGIN
                                IF EXISTS
                                (
                                    SELECT de.ExecutorId
                                    FROM dbo.DOCS_EXECUTOR de
                                    WHERE de.ExecutorDocId IN
                                    (
                                        SELECT s.DocId
                                        FROM @answer s
                                    )
                                          AND de.ExecutorWorkplaceId = @workPlaceId
                                          AND de.ExecutorTopId IS NOT NULL
                                )
                                    BEGIN
                                        UPDATE dbo.DOCS_EXECUTOR
                                          SET 
                                              ExecutorReadStatus = 1, 
                                              ExecutorControlStatus = 1
                                        WHERE ExecutorDocId IN
                                        (
                                            SELECT s.DocId
                                            FROM @answer s
                                        )
                                              AND ExecutorWorkplaceId = @workPlaceId
                                              AND SendStatusId = 1
                                              AND ExecutorReadStatus = 0;
                                END;
                                        --    ELSE
                                        --    BEGIN
                                        --        UPDATE dbo.DOCS_EXECUTOR
                                        --          SET 
                                        --              ExecutorReadStatus = 1, 
                                        --              ExecutorControlStatus = 1, 
                                        --              ExecutorTopId =
                                        --        (
                                        --            SELECT de.ExecutorId
                                        --            FROM dbo.DOCS_EXECUTOR de
                                        --            WHERE de.ExecutorDocId in
                                        --            (
                                        --                SELECT s.DocId
                                        --                FROM @answer s
                                        --            )
                                        --                  AND de.ExecutorWorkplaceId = @workPlaceId
                                        --                  AND de.ExecutorReadStatus = 0
                                        --        )
                                        --        WHERE ExecutorDocId IN
                                        --        (
                                        --            SELECT s.DocId
                                        --            FROM @answer s
                                        --        )
                                        --              AND ExecutorWorkplaceId = @workPlaceId
                                        --              AND SendStatusId = 1
                                        --              AND ExecutorReadStatus = 0;
                                        --END;
                        END;
                        WHILE(@answerCount > 0)
                            BEGIN
                                IF EXISTS
                                (
                                    SELECT de.ExecutorId
                                    FROM dbo.DOCS_EXECUTOR de
                                    WHERE de.ExecutorDocId IN
                                    (
                                        SELECT s.DocId
                                        FROM @answer s
                                    )
                                          AND de.ExecutorWorkplaceId = @workPlaceId
                                          AND de.ExecutorTopId IS NULL
										  AND de.ExecutorMain=1
                                )
                                    BEGIN
                                        UPDATE dbo.DOCS_EXECUTOR
                                          SET 
                                              ExecutorReadStatus = 1, 
                                              ExecutorControlStatus = 1, 
                                              ExecutorTopId =
                                        (
                                            SELECT de.ExecutorId
                                            FROM dbo.DOCS_EXECUTOR de
                                            WHERE de.ExecutorDocId IN
                                            (
                                                SELECT s1.DocId
                                                FROM
                                                (
                                                    SELECT s.DocId, 
                                                           ROW_NUMBER() OVER(
                                                           ORDER BY s.DocId) AS rownumber
                                                    FROM @answer s
                                                ) s1
                                                WHERE s1.rownumber = @answerCount
                                            )
                                                  AND de.ExecutorWorkplaceId = @workPlaceId
                                                  AND de.ExecutorReadStatus = 0
												  AND de.ExecutorMain=1
                                        )
                                        WHERE ExecutorDocId IN
                                        (
                                            SELECT s1.DocId
                                            FROM
                                            (
                                                SELECT s.DocId, 
                                                       ROW_NUMBER() OVER(
                                                       ORDER BY s.DocId) AS rownumber
                                                FROM @answer s
                                            ) s1
                                            WHERE s1.rownumber = @answerCount
                                        )
                                              AND ExecutorWorkplaceId = @workPlaceId
                                              AND SendStatusId = 1
                                              AND ExecutorReadStatus = 0
											  AND ExecutorMain=1;
                                END;
                                UPDATE dbo.docs
                                  SET 
                                      docs.DocResultId =
                                (
                                    SELECT s.ResultId
                                    FROM
                                    (
                                        SELECT a.ResultId, 
                                               ROW_NUMBER() OVER(
                                               ORDER BY a.DocId) AS rownumber
                                        FROM @answer a
                                    ) s
                                    WHERE s.rownumber = @answerCount
                                )
                                WHERE docs.DocId =
                                (
                                    SELECT s.DocId
                                    FROM
                                    (
                                        SELECT a.DocId, 
                                               ROW_NUMBER() OVER(
                                               ORDER BY a.DocId) AS rownumber
                                        FROM @answer a
                                    ) s
                                    WHERE s.rownumber = @answerCount
                                );
                                SET @answerCount-=1;
                END;
                END;
            IF(@operationType = 2) -- Update
                BEGIN
                    UPDATE dbo.DOCS
                      SET 
                          DocDescription = @shortContent, 
                          DocUpdatedByDate =dbo.SYSDATETIME(), 
                          DocUpdatedById = @workPlaceId,
						  dbo.DOCS.DocPlannedDate=@plannedDate
                    WHERE DocId = @docId;
                    UPDATE dbo.DOCS_ADDRESSINFO
                      SET 
                          AdrOrganizationId = CONVERT(INT,
                    (
                        SELECT [dbo].[fnGetPersonnelDetailsbyWorkPlaceId](@signatoryPersonId, 3)
                    )), 
                          AdrAuthorDepartmentName = CONVERT(NVARCHAR(MAX),
                    (
                        SELECT [dbo].[fnGetPersonnelDetailsbyWorkPlaceId](@signatoryPersonId, 2)
                    )), 
                          AdrPersonId = @signatoryPersonId, 
                          FullName = CONVERT(NVARCHAR(MAX),
                    (
                        SELECT [dbo].[fnGetPersonnelDetailsbyWorkPlaceId](@signatoryPersonId, 1)
                    ))
                    WHERE AdrDocId = @docId
                          AND AdrTypeId = 1;
                    UPDATE dbo.DOCS_ADDRESSINFO
                      SET 
                          AdrOrganizationId = CONVERT(INT,
                    (
                        SELECT [dbo].[fnGetPersonnelDetailsbyWorkPlaceId](@confirmingPersonId, 3)
                    )), 
                          AdrAuthorDepartmentName = CONVERT(NVARCHAR(MAX),
                    (
                        SELECT [dbo].[fnGetPersonnelDetailsbyWorkPlaceId](@confirmingPersonId, 2)
                    )), 
                          AdrPersonId = @confirmingPersonId, 
                          FullName = CONVERT(NVARCHAR(MAX),
                    (
                        SELECT [dbo].[fnGetPersonnelDetailsbyWorkPlaceId](@confirmingPersonId, 1)
                    ))
                    WHERE AdrDocId = @docId
                          AND AdrTypeId = 2;
                    DELETE FROM dbo.DOC_TASK
                    WHERE dbo.DOC_TASK.TaskDocId = @docId;
                    INSERT INTO dbo.DOC_TASK
                    (
                    --TaskId - column value is auto-generated
                    TaskDocId, 
                    TypeOfAssignmentId, 
                    WhomAddressId, 
                    OrganizationId, 
                    TaskStatus, 
                    TaskCreateWorkPlaceId, 
                    TaskCreateDate
                    )
                           SELECT @docId AS TaskDocId, 
                                  w.ExecutionStatus AS TypeOfAssignmentId, 
                                  w.WhomAddress AS WhomAddressId, 
                                  @orgId AS OrganizationId, 
                                  @documentStatusId AS TaskStatus, 
                                  @workPlaceId AS TaskCreateWorkPlaceId, 
                                  dbo.SYSDATETIME() AS TaskCreateDate
                           FROM @whomAddress w;
                    INSERT INTO dbo.DOCS_RELATED
                    (RelatedDocId, 
                     RelatedDocumentId, 
                     RelatedTypeId
                    )
                           SELECT @docId RelatedDocId, 
                                  r.DocId RelatedDocumentId, 
                                  1 RelatedTypeId
                           FROM @related r
                           WHERE r.docid NOT IN
                           (
                               SELECT dr.RelatedDocumentId
                               FROM dbo.DOCS_RELATED dr
                               WHERE dr.RelatedDocId = @docId
                                     AND dr.RelatedTypeId = 1
                           );
                    SELECT @answerCount = COUNT(0)
                    FROM @answer; -- cavab senedi

                    IF(@answerCount > 0)
                        BEGIN
                            INSERT INTO dbo.DOCS_RELATED
                            (RelatedDocId, 
                             RelatedDocumentId, 
                             RelatedTypeId
                            )
                                   SELECT @docId RelatedDocId, 
                                          a.DocId RelatedDocumentId, 
                                          2 RelatedTypeId
                                   FROM @answer a
                                   WHERE a.DocId NOT IN
                                   (
                                       SELECT dr.RelatedDocumentId
                                       FROM dbo.DOCS_RELATED dr
                                       WHERE dr.RelatedDocId = @docId
                                             AND dr.RelatedTypeId = 2
                                   );
                            IF EXISTS
                            (
                                SELECT de.ExecutorId
                                FROM dbo.DOCS_EXECUTOR de
                                WHERE de.ExecutorDocId IN
                                (
                                    SELECT s.DocId
                                    FROM @answer s
                                )
                                      AND de.ExecutorWorkplaceId = @workPlaceId
                                      AND de.ExecutorTopId IS NOT NULL
                            )
                                BEGIN
                                    UPDATE dbo.DOCS_EXECUTOR
                                      SET 
                                          ExecutorReadStatus = 1, 
                                          ExecutorControlStatus = 1
                                    WHERE ExecutorDocId IN
                                    (
                                        SELECT s.DocId
                                        FROM @answer s
                                    )
                                          AND ExecutorWorkplaceId = @workPlaceId
                                          AND SendStatusId = 1
                                          AND ExecutorReadStatus = 0;
                            END;
                                ELSE
                                BEGIN
                                    UPDATE dbo.DOCS_EXECUTOR
                                      SET 
                                          ExecutorReadStatus = 1, 
                                          ExecutorControlStatus = 1, 
                                          ExecutorTopId =
                                    (
                                        SELECT de.ExecutorId
                                        FROM dbo.DOCS_EXECUTOR de
                                        WHERE de.ExecutorDocId IN
                                        (
                                            SELECT s.DocId
                                            FROM @answer s
                                        )
                                              AND de.ExecutorWorkplaceId = @workPlaceId
                                              AND de.ExecutorReadStatus = 0
                                    )
                                    WHERE ExecutorDocId IN
                                    (
                                        SELECT s.DocId
                                        FROM @answer s
                                    )
                                          AND ExecutorWorkplaceId = @workPlaceId
                                          AND SendStatusId = 1
                                          AND ExecutorReadStatus = 0;
                            END;
                            WHILE(@answerCount > 0)
                                BEGIN
                                    UPDATE dbo.docs
                                      SET 
                                          docs.DocResultId =
                                    (
                                        SELECT s.ResultId
                                        FROM
                                        (
                                            SELECT a.ResultId, 
                                                   ROW_NUMBER() OVER(
                                                   ORDER BY a.DocId) AS rownumber
                                            FROM @answer a
                                        ) s
                                        WHERE s.rownumber = @answerCount
                                    )
                                    WHERE docs.DocId =
                                    (
                                        SELECT s.DocId
                                        FROM
                                        (
                                            SELECT a.DocId, 
                                                   ROW_NUMBER() OVER(
                                                   ORDER BY a.DocId) AS rownumber
                                            FROM @answer a
                                        ) s
                                        WHERE s.rownumber = @answerCount
                                    );
                                    SET @answerCount-=1;
                    END;
                    END;
            END;
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
                                IF EXISTS
                                (
                                    SELECT dr.*
                                    FROM dbo.DOCS_RELATED dr
                                    WHERE dr.RelatedDocumentId = @rowId
                                          AND dr.RelatedTypeId = 2
                                )
                                    BEGIN
                                        UPDATE dbo.DOCS_EXECUTOR
                                          SET
                                        --ExecutorId - column value is auto-generated

                                              dbo.DOCS_EXECUTOR.ExecutorReadStatus = 0, -- bit

                                              dbo.DOCS_EXECUTOR.ExecutorControlStatus = 0 -- bit
                                        WHERE dbo.DOCS_EXECUTOR.ExecutorId =
                                        (
                                            SELECT de.ExecutorId
                                            FROM dbo.DOCS_EXECUTOR de
                                            WHERE de.ExecutorDocId = @rowId
                                                  AND de.ExecutorWorkplaceId =
                                            (
                                                SELECT de.ExecutorWorkplaceId
                                                FROM dbo.DOCS_EXECUTOR de
                                                WHERE de.ExecutorDocId =
                                                (
                                                    SELECT dr.RelatedDocId
                                                    FROM dbo.DOCS_RELATED dr
                                                    WHERE dr.RelatedDocumentId = @rowId
                                                          AND dr.RelatedTypeId = 2
                                                )
                                                      AND de.DirectionTypeId = 4
                                            )
                                                  AND de.ExecutorMain = 1
                                        );

                                        UPDATE dbo.DOCS
                                          SET 
                                              dbo.DOCS.DocResultId = NULL
                                        WHERE dbo.DOCS.DocId =
                                        (
                                            SELECT dr.RelatedDocId
                                            FROM dbo.DOCS_RELATED dr
                                            WHERE dr.RelatedDocumentId = @rowId
                                                  AND dr.RelatedTypeId = 2
                                        );

                                        DELETE FROM dbo.DOCS_RELATED
                                        WHERE dbo.DOCS_RELATED.RelatedDocumentId = @rowId
                                              AND dbo.DOCS_RELATED.RelatedTypeId = 2;
                                END;
                                    ELSE
                                    BEGIN
                                       IF EXISTS(SELECT dr.* FROM dbo.DOCS_RELATED dr WHERE dr.RelatedDocumentId=@rowId AND dr.RelatedTypeId=1)
										begin
                                            DELETE FROM dbo.DOCS_RELATED
                                            WHERE dbo.DOCS_RELATED.RelatedDocumentId = @rowId
                                                  AND dbo.DOCS_RELATED.RelatedTypeId = 1;
										END
										IF EXISTS(SELECT dr.* FROM dbo.DOCS_RELATED dr WHERE dr.RelatedDocId=@rowId AND dr.RelatedTypeId=1)
										begin
                                            DELETE FROM dbo.DOCS_RELATED
                                            WHERE dbo.DOCS_RELATED.RelatedDocId = @rowId
                                                  AND dbo.DOCS_RELATED.RelatedTypeId = 1;
										end
                                END;
                        END
						ELSE IF(@formTypeId=2)
						BEGIN
							DELETE FROM dbo.DOC_TASK WHERE dbo.DOC_TASK.TaskId=@taskId
						END;
            END;
            IF @@ERROR = 0
                BEGIN
                    COMMIT TRANSACTION;
                    SET @result = 1; -- 1 IS FOR SUCCESSFULLY EXECUTED
            END;
                ELSE
                BEGIN
                    ROLLBACK TRANSACTION;
                    SET @result = 0; -- 0 WHEN AN ERROR HAS OCCURED
            END;
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION;
            SET @result = 0;
            DECLARE @ErrorProcedure NVARCHAR(MAX), @ErrorMessage NVARCHAR(MAX), @ErrorSeverity INT, @ErrorState INT;
            SELECT @ErrorProcedure = 'Procedure:' + ERROR_PROCEDURE(), 
                   @ErrorMessage = @ErrorProcedure + '.Message:' + ERROR_MESSAGE() + ' Line ' + CAST(ERROR_LINE() AS NVARCHAR(5)), 
                   @ErrorSeverity = ERROR_SEVERITY(), 
                   @ErrorState = ERROR_STATE();
            RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
            INSERT INTO dbo.debugTable
            ([text], 
             insertDate
            )
            VALUES
            (@ErrorMessage, 
             dbo.SYSDATETIME()
            );
        END CATCH;
    END;
