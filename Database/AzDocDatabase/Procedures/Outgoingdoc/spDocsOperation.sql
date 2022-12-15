
/*
Migrated by Kamran A-eff 23.08.2019
*/
/*
Migrated by Kamran A-eff 06.08.2019
*/
/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [outgoingdoc].[spDocsOperation] @operationType     INT, 
                                                @workPlaceId       INT                                = NULL, 
                                                @docTypeId         INT                                = NULL, 
                                                @docDeleted        INT                                = NULL, 
                                                @documentStatusId  INT                                = NULL, 
                                                @typeOfDocumentId  INT                                = NULL, 
                                                @signatoryPersonId INT                                = NULL, 
                                                @sendFormId        INT                                = NULL, 
                                                @shortContent      NVARCHAR(MAX)                      = NULL, 
                                                @docEnterDate      DATE                               = NULL, --@docDocDate
                                                @formTypeId        INT                                = NULL, 
                                                @rowId             INT                                = NULL,                                             
                                                --@taskId              INT= NULL, 
                                                @whomAddress       [serviceletters].[UdttWhomAddress] READONLY, 
                                                @author            [dbo].[UdttAuthor] READONLY, 
                                                @related           [dbo].[UdttRelated] READONLY, 
                                                @answer            [dbo].[UdttAnswer] READONLY, 
                                                @docId             INT                                = NULL OUTPUT, 
                                                @result            INT OUTPUT
AS
    BEGIN
        SET TRANSACTION ISOLATION LEVEL READ COMMITTED; -- turn it on
        SET NOCOUNT ON;
        BEGIN TRANSACTION;
        BEGIN TRY
            BEGIN
                DECLARE @date DATE= dbo.Sysdatetime(), @organizationId INT, @departmentId INT, @periodId INT, @orgId INT, @docDocno NVARCHAR(20)= NULL, @docIndex INT, @answerCount INT= 0;
                SET @docTypeId = 12;

				IF(@docId IS NOT NULL)
				begin
					IF NOT EXISTS (SELECT d.* FROM dbo.DOCS d WHERE d.DocId=@docId AND d.DocDoctypeId=@docTypeId AND d.DocDeleted IN (CASE WHEN @operationType=0 then 3 ELSE 0 end)) AND @docId IS NOT null
					BEGIN					
						THROW 56000,N'Sənədin yaradılmasında problem yarandı.Zəhmət olmasa sənədin yaradılmasına yenidən cəhd edin',1;
					END;

					IF EXISTS (SELECT a.* FROM @answer a WHERE a.DocId=@docId)
					BEGIN
						THROW 56000,N'Cavab sənədinin əlavə olunmasında problem yarandı.Zəhmət olmasa sənədin yaradılmasına yenidən cəhd edin',1;
					end;
				end;

                --Period 
                SELECT @periodId = dp.periodid
                FROM dbo.doc_period dp
                WHERE dp.perioddate1 <= @date
                      AND dp.perioddate2 >= @date;

                -- Organization Id 
                SELECT @orgId =
                (
                    SELECT dbo.Fnpropertybyworkplaceid(@workPlaceId, 12)
                );
                SELECT @docIndex = (COUNT(0) + 1)
                FROM dbo.VW_DOC_INFO d WITH (TABLOCKX, HOLDLOCK)
                WHERE d.docdoctypeid = @docTypeId
                      AND d.DocDocno IS NOT NULL
                      AND d.DocPeriodId = @periodId;
                SELECT @docDocno = 'L-' + CAST(@docIndex AS NVARCHAR(MAX)) + '/' +
                (
                    SELECT Format(@date, 'yy')
                );
                --IF(@operationType = 1) --Insert 

                --    BEGIN
                --        INSERT INTO dbo.docs
                --        (docperiodid, 
                --         docorganizationid, 
                --         docdoctypeid, 
                --         docdeleted, 
                --         docdeletedbydate, 
                --         docinsertedbyid, 
                --         docinsertedbydate
                --        )
                --        VALUES
                --        (@periodId, 
                --         @orgId, 
                --         @docTypeId, 
                --         @docDeleted, 
                --         dbo.Sysdatetime(), 
                --         @workPlaceId, 
                --         dbo.Sysdatetime()
                --        );
                --        SET @docId = SCOPE_IDENTITY();
                --END;
                --    ELSE
                    IF(@operationType = 0)--Save 
                        BEGIN
                            SELECT @organizationId = dw.workplaceorganizationid, 
                                   @departmentId = dw.workplacedepartmentid
                            FROM dbo.dc_workplace dw
                            WHERE dw.workplaceid = @workPlaceId;
                            UPDATE dbo.docs
                              SET 
                                  docdocdate = @docEnterDate, 
                                  docreceivedformid = @sendFormId, 
                                  docformid = @typeOfDocumentId, 
                                  docdocno = @docDocno, 
                                  docdocumentstatusid = @documentStatusId, 
                                  docdescription = @shortContent, 
                                  docdeleted = @docDeleted, 
                                  docdeletedbydate = dbo.Sysdatetime(), 
                                  docdocumentoldstatusid =
                            (
                                SELECT d.docdocumentstatusid
                                FROM dbo.docs d
                                WHERE d.docid = @docId
                            )
                            WHERE docid = @docId;

                            --İmza edən şəxs (AdrTypeId = 1) 
                            --Təsdiq edən şəxs (AdrTypeId = 2) 
                            --Təşkilat məlumatları (AdrTypeId = 3)   
                            INSERT INTO dbo.docs_addressinfo
                            (adrdocid, 
                             adrtypeid, 
                             adrorganizationid, 
                             adrauthorid, 
                             adrauthordepartmentname, 
                             adrpersonid, 
                             adrpositionid, 
                             adrundercontrol, 
                             adrundercontroldays, 
                             fullname, 
                             adrsendstatusid
                            )
                            VALUES
                            (@docId, 
                             1, 
                             CONVERT(INT,
                            (
                                SELECT [dbo].[Fngetpersonneldetailsbyworkplaceid](20, 3)
                            )), 
                             NULL, 
                             CONVERT(NVARCHAR(MAX),
                            (
                                SELECT [dbo].[Fngetpersonneldetailsbyworkplaceid](@signatoryPersonId, 2)
                            )), 
                             @signatoryPersonId, 
                             NULL, 
                             0, 
                             0, 
                             CONVERT(NVARCHAR(MAX),
                            (
                                SELECT [dbo].[Fngetpersonneldetailsbyworkplaceid](@signatoryPersonId, 1)
                            )), 
                             NULL
                            ); --               

                            INSERT INTO dbo.docs_addressinfo
                            (adrdocid, 
                             adrtypeid, 
                             adrorganizationid, 
                             adrauthorid, 
                             adrauthordepartmentname, 
                             adrpersonid, 
                             adrpositionid, 
                             fullname
                            )
                                   SELECT @docID, 
                                          3, 
                                          da.authororganizationid, 
                                          a.authorid, 
                                          da.authordepartmentname, 
                                          NULL, 
                                          da.authorpositionid, 
                                          (da.authorname + ' ' + da.authorsurname + ' ' + da.authorlastname) FullName
                                   FROM @author a
                                        INNER JOIN dbo.doc_author da ON a.authorid = da.authorid;
                            INSERT INTO dbo.doc_task
                            ( 
                            --TaskId - column value is auto-generated 
                            taskdocid, 
                            typeofassignmentid, 
                            whomaddressid, 
                            organizationid, 
                            taskstatus, 
                            taskcreateworkplaceid, 
                            taskcreatedate
                            )
                                   SELECT @docId AS TaskDocId, 
                                          3 AS TypeOfAssignmentId, 
                                          w.whomaddress AS WhomAddressId, 
                                          @orgId AS OrganizationId, 
                                          @documentStatusId AS TaskStatus, 
                                          @workPlaceId AS TaskCreateWorkPlaceId, 
                                          dbo.Sysdatetime() AS TaskCreateDate
                                   FROM @whomAddress w;
                            INSERT INTO dbo.docs_related
                            (relateddocid, 
                             relateddocumentid, 
                             relatedtypeid
                            )
                                   SELECT @docId RelatedDocId, 
                                          r.docid RelatedDocumentId, 
                                          1 RelatedTypeId
                                   FROM @related r;
                            INSERT INTO dbo.docs_related
                            (relateddocid, 
                             relateddocumentid, 
                             relatedtypeid
                            )
                                   SELECT @docId RelatedDocId, 
                                          a.docid RelatedDocumentId, 
                                          2 RelatedTypeId
                                   FROM @answer a;
                            SELECT @answerCount = COUNT(0)
                            FROM @answer;
                            --IF(@answerCount > 0)
                            --    BEGIN
                            --        UPDATE dbo.docs_executor
                            --          SET 
                            --              executorreadstatus = 1, 
                            --              executorcontrolstatus = 1
                            --        WHERE executordocid IN
                            --        (
                            --            SELECT s.docid
                            --            FROM @answer s
                            --        )
                            --              AND executorworkplaceid = @workPlaceId
                            --              AND sendstatusid = 1;
                            --END;
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
                                          docs.docresultid =
                                    (
                                        SELECT s.resultid
                                        FROM
                                        (
                                            SELECT a.resultid, 
                                                   ROW_NUMBER() OVER(
                                                   ORDER BY a.docid) AS rownumber
                                            FROM @answer a
                                        ) s
                                        WHERE s.rownumber = @answerCount
                                    )
                                    WHERE docs.docid =
                                    (
                                        SELECT s.docid
                                        FROM
                                        (
                                            SELECT a.docid, 
                                                   ROW_NUMBER() OVER(
                                                   ORDER BY a.docid) AS rownumber
                                            FROM @answer a
                                        ) s
                                        WHERE s.rownumber = @answerCount
                                    );
                                    SET @answerCount-=1;
                    END;
                    END;
                        ELSE
                        IF(@operationType = 2)
                            BEGIN
                                UPDATE dbo.docs
                                  SET 
                                      docdescription = @shortContent, 
                                      docupdatedbydate = dbo.Sysdatetime(), 
                                      DocDocumentstatusId = CASE
                                                                WHEN DocDocumentstatusId = 37
                                                                THEN 31
                                                                ELSE DocDocumentstatusId
                                                            END, --reserve sened redakte edilmesi hali ucun				
                                      docupdatedbyid = @workPlaceId, 
                                      docreceivedformid = @sendFormId, 
                                      docformid = @typeOfDocumentId
                                WHERE docid = @docId;
                                UPDATE dbo.docs_addressinfo
                                  SET 
                                      adrorganizationid = CONVERT(INT,
                                (
                                    SELECT [dbo].[Fngetpersonneldetailsbyworkplaceid](@signatoryPersonId, 3)
                                )), 
                                      adrauthordepartmentname = CONVERT(NVARCHAR(MAX),
                                (
                                    SELECT [dbo].[Fngetpersonneldetailsbyworkplaceid](@signatoryPersonId, 2)
                                )), 
                                      adrpersonid = @signatoryPersonId, 
                                      fullname = CONVERT(NVARCHAR(MAX),
                                (
                                    SELECT [dbo].[Fngetpersonneldetailsbyworkplaceid](@signatoryPersonId, 1)
                                ))
                                WHERE adrdocid = @docId
                                      AND adrtypeid = 1;
                                DELETE FROM dbo.doc_task
                                WHERE dbo.doc_task.taskdocid = @docId;
                                INSERT INTO dbo.doc_task
                                ( 
                                --TaskId - column value is auto-generated 
                                taskdocid, 
                                typeofassignmentid, 
                                whomaddressid, 
                                organizationid, 
                                taskstatus, 
                                taskcreateworkplaceid, 
                                taskcreatedate
                                )
                                       SELECT @docId AS TaskDocId, 
                                              3 AS TypeOfAssignmentId, --melumat  
                                              w.whomaddress AS WhomAddressId, 
                                              @orgId AS OrganizationId, 
                                              @documentStatusId AS TaskStatus, 
                                              @workPlaceId AS TaskCreateWorkPlaceId, 
                                              dbo.Sysdatetime() AS TaskCreateDate
                                       FROM @whomAddress w;
                                INSERT INTO dbo.docs_addressinfo
                                (adrdocid, 
                                 adrtypeid, 
                                 adrorganizationid, 
                                 adrauthorid, 
                                 adrauthordepartmentname, 
                                 adrpersonid, 
                                 adrpositionid, 
                                 fullname
                                )
                                       SELECT @docID, 
                                              3, 
                                              da.authororganizationid, 
                                              a.authorid, 
                                              da.authordepartmentname, 
                                              NULL, 
                                              da.authorpositionid, 
                                              (da.authorname + ' ' + da.authorsurname + ' ' + da.authorlastname) FullName
                                       FROM @author a
                                            INNER JOIN dbo.doc_author da ON a.authorid = da.authorid;
                                INSERT INTO dbo.docs_related
                                (relateddocid, 
                                 relateddocumentid, 
                                 relatedtypeid
                                )
                                       SELECT @docId RelatedDocId, 
                                              r.docid RelatedDocumentId, 
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
                                                    WHERE de.ExecutorDocId in
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
                                DELETE FROM dbo.docs_addressinfo
                                WHERE adrid = @rowId;
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

                                    /* Shahriyar elave etdi*/

                                        BEGIN
										IF EXISTS(SELECT dr.* FROM dbo.DOCS_RELATED dr WHERE dr.RelatedId=@rowId AND dr.RelatedTypeId=1)
										begin
                                            DELETE FROM dbo.DOCS_RELATED
                                            WHERE dbo.DOCS_RELATED.RelatedId = @rowId
                                                  AND dbo.DOCS_RELATED.RelatedTypeId = 1;
										END
										IF EXISTS(SELECT dr.* FROM dbo.DOCS_RELATED dr WHERE dr.RelatedId=@rowId AND dr.RelatedTypeId=1)
										begin
                                            DELETE FROM dbo.DOCS_RELATED
                                            WHERE dbo.DOCS_RELATED.RelatedId = @rowId
                                                  AND dbo.DOCS_RELATED.RelatedTypeId = 1;
										end
                                    END;
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
