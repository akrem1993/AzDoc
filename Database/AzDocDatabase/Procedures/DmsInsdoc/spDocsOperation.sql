/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [dms_insdoc].[spDocsOperation] @operationType       INT, 
                                               @workPlaceId         INT                        = NULL, 
                                               @docTypeId           INT                        = NULL, 
                                               @docDeleted          INT                        = NULL, 
                                               @documentStatusId    INT                        = NULL, 
                                               @typeOfDocumentId    INT                        = NULL, 
                                               @subtypeOfDocumentId INT                        = NULL, 
                                               @signatoryPersonId   INT                        = NULL, 
                                               @confirmingPersonId  INT                        = NULL, 
                                               @shortContent        NVARCHAR(MAX)              = NULL, 
                                               @tasks               [dms_insdoc].[UdttTask] READONLY, 
                                               @related             [dbo].[UdttRelated] READONLY, 
                                               @taskId              INT                        = NULL, 
                                               @docId               INT                        = NULL OUTPUT, 
                                               @result              INT OUTPUT
AS
    BEGIN
        SET NOCOUNT ON;
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED; -- turn it on
		BEGIN TRANSACTION
		BEGIN TRY

        DECLARE @date DATE= dbo.SYSDATETIME(), @periodId INT, @orgId INT, @docDocno NVARCHAR(20)= NULL, @docIndex INT;   
        --Periodu tapiram
		SET @docTypeId=3;
        SELECT @periodId = dp.PeriodId
        FROM DOC_PERIOD dp
        WHERE dp.PeriodDate1 <= @date
              AND dp.PeriodDate2 >= @date;
        -- Organization Id-sini tapiram
        SELECT @orgId =
        (
            SELECT dbo.fnPropertyByWorkPlaceId(@workPlaceId, 12)
        );
        SELECT @docIndex = (COUNT(0) + 1)
        FROM dbo.VW_DOC_INFO  d with(tablockx,holdlock)
        WHERE d.DocDoctypeId = @docTypeId AND d.DocPeriodId=@periodId;

        SELECT @docDocno = 'LS-' + CAST(@docIndex AS NVARCHAR(MAX)) + '/' +
        (
            SELECT FORMAT(@date, 'yy')
        );
        -- DocDocumentstatusId=31  ==> Ilk defe sened yaradilanda qaralama statusunda dusur..(Table: dbo.DOC_DOCUMENTSTATUS)
			IF(@operationType = 0) -- Save 
                BEGIN
                    UPDATE dbo.DOCS
                      SET 
                          DocFormId = @typeOfDocumentId, 
                          DocDocno =
                    (
                        SELECT @docDocno
                    ), 
                          DocDocdate = GETDATE(), 
                          DocEnternop2 = @docIndex, 
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

                    --İmza edən şəxs (AdrTypeId = 1)
                    --Təsdiq edən şəxs (AdrTypeId = 2)
                    --Təşkilat məlumatları (AdrTypeId = 3)  

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
                    (TaskDocId, 
                     TypeOfAssignmentId, 
                     TaskNo, 
                     TaskDecription, 
                     TaskCycleId, 
                     ExecutionPeriod, 
                     PeriodOfPerformance, 
                     OriginalExecutionDate, 
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
                                  t.TaskCycle, 
                                  t.ExecutionPeriod, 
                                  t.PeriodOfPerformance, 
                                  t.OriginalExecutionDate, 
                                  t.WhomAddressId, 
                                  @orgId, 
                                  @documentStatusId TaskStatus, 
                                  @workPlaceId TaskCreateWorkPlaceId, 
                                  dbo.SYSDATETIME() TaskCreateDate
                           FROM @tasks t;

						   INSERT INTO dbo.debugTable
						   (
						       --id - column value is auto-generated
						       [text],
						       insertDate
						   )
						   VALUES
						   (
						       -- id - int
						       (SELECT count(0) FROM @related), -- text - nvarchar
						       '2019-12-17 15:25:48' -- insertDate - datetime
						   )

                    INSERT INTO dbo.DOCS_RELATED
                    (RelatedDocId, 
                     RelatedDocumentId, 
                     RelatedTypeId
                    )
                           SELECT @docId RelatedDocId, 
                                  r.DocId RelatedDocumentId, 
                                  1 RelatedTypeId
                           FROM @related r;
            END;
                ELSE
                IF(@operationType = 2) -- Update
                    BEGIN
                        UPDATE dbo.DOCS
                          SET 
                              DocFormId = @typeOfDocumentId, 
                              DocDescription = @shortContent, 
                              DocUpdatedByDate = dbo.SYSDATETIME(), 
                              DocUpdatedById = @workPlaceId
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
                        IF EXISTS
                        (
                            SELECT *
                            FROM @tasks
                        )
                            BEGIN
                                INSERT INTO dbo.DOC_TASK
                                (TaskDocId, 
                                 TypeOfAssignmentId, 
                                 TaskNo, 
                                 TaskDecription, 
                                 TaskCycleId, 
                                 ExecutionPeriod, 
                                 PeriodOfPerformance, 
                                 OriginalExecutionDate, 
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
                                              t.TaskCycle, 
                                              t.ExecutionPeriod, 
                                              t.PeriodOfPerformance, 
                                              t.OriginalExecutionDate, 
                                              t.WhomAddressId, 
                                              @orgId, 
                                              31 TaskStatus, 
                                              @workPlaceId TaskCreateWorkPlaceId, 
                                              dbo.SYSDATETIME() TaskCreateDate
                                       FROM @tasks t;
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
                END;
                    ELSE
                    IF(@operationType = 3) -- Delete 
                        BEGIN
                            DELETE FROM dbo.DOC_TASK
                            WHERE TaskId = @taskId;
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
    SET @result=-1;
        DECLARE 
        @ErrorProcedure nvarchar(max),
        @ErrorMessage nvarchar(max), 
        @ErrorSeverity int, @ErrorState int;

        SELECT
        @ErrorProcedure='Procedure:'+ERROR_PROCEDURE(), 
        @ErrorMessage = @ErrorProcedure+'.Message:'+ERROR_MESSAGE() + ' Line ' + cast(ERROR_LINE() as nvarchar(5)),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE();

       INSERT INTO dbo.debugTable
       ([text],insertDate)
       VALUES
       (@ErrorMessage, dbo.SYSDATETIME())
         

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH
    END;

