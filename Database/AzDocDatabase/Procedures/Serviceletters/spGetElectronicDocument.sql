/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [serviceletters].[spGetElectronicDocument] @docId       INT = NULL, 
                                                       @docType     INT = NULL, 
                                                       @docInfoId   INT = NULL, 
                                                       @workPlaceId INT = NULL
AS
    BEGIN
        IF((@docId IS NOT NULL)
           AND (@doctype IS NOT NULL)
           AND (@docInfoId IS NULL))
            BEGIN
                DECLARE @directionType INT, @executorCount INT, @vizaMaxOrderIndex INT, @adrPersonId INT;

                update dbo.DOCS_EXECUTOR set ExecutorControlStatus=1 
				where ExecutorDocId=@docId 
				and ExecutorWorkplaceId = @workPlaceId;

                DECLARE @ActionTable TABLE
                (ActionId   INT, 
                 ActionName NVARCHAR(30)
                );
                INSERT INTO @ActionTable
                (ActionId, 
                 ActionName 
                )
                EXEC [dbo].[GetDocumentActions] 
                     @docId = @docId, 
                     @workPlaceId = @workPlaceId, 
                     @menuTypeId = 1
                SELECT @directionType = e.DirectionTypeId
                FROM dbo.DOCS_EXECUTOR e
                WHERE e.ExecutorDocId = @docId
                      AND e.ExecutorWorkplaceId = @workPlaceId;
                SELECT @executorCount = COUNT(0)
                FROM dbo.DOCS_EXECUTOR e
                WHERE e.ExecutorDocId = @docId
                      AND e.ExecutorWorkplaceId = @workPlaceId
                      AND e.DirectionTypeId = 18;
                SELECT @vizaMaxOrderIndex = MAX(v.VizaOrderindex)
                FROM dbo.DOCS_VIZA v
                WHERE v.VizaDocId = @docId
                      AND v.IsDeleted = 0;
                SELECT @adrPersonId = a.AdrPersonId
                FROM dbo.DOCS_ADDRESSINFO a
                WHERE a.AdrDocId = @docId;
                SELECT
                (
                    SELECT a.Caption
                    FROM dbo.AC_MENU a
                    WHERE a.DocTypeId = d.DocDoctypeId
                ) AS DocTypeName, 
                d.DocEnterno AS DocEnterNo, 
                d.DocEnterdate AS DocEnterDate, 
                d.DocDocno AS DocDocNo, 
                d.DocDocdate AS DocDocDate, 
                d.DocDocumentstatusId DocDocumentStatusId, 
                @directionType AS DirectionTypeId, 
                (
                    SELECT fi.FileInfoId, 
                           fi.FileInfoName
                    FROM dbo.DOCS_FILE f
                         INNER JOIN DOCS_FILEINFO fi ON f.FileInfoId = fi.FileInfoId
                    WHERE f.FileDocId = @docId
                          AND f.IsDeleted = 0
                          AND f.IsReject = 0
                    ORDER BY f.FileIsMain DESC FOR JSON AUTO
                ) AS JsonFileInfoSelected, 
                (
        --            SELECT f.FileInfoId -- evvelki select
        --            FROM dbo.DOCS_FILE f
        --            WHERE f.FileDocId = d.DocId
        --                  AND f.FileIsMain = 1
        --                  AND f.IsDeleted = 0
						  --AND f.FileVisaStatus<>0
        --                  AND f.IsReject = 0
						  --AND f.FileCurrentVisaGroup NOT IN (0)
						  ----AND f.FileCurrentVisaGroup in (1,2) /* arashdirmaq lazimdi */

						SELECT  top(1) df.FileInfoId FROM dbo.DOCS_FILEINFO df 
							INNER JOIN dbo.docs_file df2 ON df.FileInfoId = df2.FileInfoId
						WHERE df2.FileIsMain = 1 
							AND df2.IsDeleted = 0
							AND df2.IsReject=0
							--AND df2.FileVisaStatus<>0
							AND df2.FileCurrentVisaGroup NOT IN (0)
							AND df2.FileDocId=d.DocId
						ORDER BY df.FileInfoInsertdate DESC

                ) AS FileInfoId, 
				(
					SELECT  top(1) df2.SignatureStatusId 
					FROM dbo.DOCS_FILEINFO df 
						INNER JOIN dbo.docs_file df2 ON df.FileInfoId = df2.FileInfoId
					WHERE df2.FileIsMain = 1 
						AND df2.IsDeleted = 0
						AND df2.IsReject=0
						--AND df2.FileVisaStatus<>0
						--AND df2.FileCurrentVisaGroup NOT IN (0)
						AND df2.FileDocId=d.DocId
					ORDER BY df.FileInfoInsertdate DESC
                ) AS FileSignatureStatus,
                (
                    SELECT *
                    FROM
                    (
					
                        SELECT v.VizaOrderindex OrderIndex, 
                               dbo.fnGetPersonnelbyWorkPlaceId(v.VizaWorkPlaceId, 106) AS PersonTo, 
                               'Viza üçün' AS ExecutorMain, 
                               0 TypeOfAssignmentId
                        FROM dbo.DOCS_VIZA v
                        WHERE v.VizaDocId = @docId
                              AND v.IsDeleted = 0
							  AND v.VizaFromWorkflow!=2
                              AND v.VizaOrderindex IS NOT NULL
                        UNION
                        SELECT
                        (
                            SELECT @vizaMaxOrderIndex + 1
                        ) OrderIndex, 
                        dbo.fnGetPersonnelbyWorkPlaceId(a.AdrPersonId, 106) AS PersonTo, 
                        N'İmza üçün' AS ExecutorMain, 
                        0 TypeOfAssignmentId
                        FROM dbo.DOCS_ADDRESSINFO a
                        WHERE a.AdrDocId = @docId
                              AND a.AdrTypeId = 1
                        UNION
                        SELECT
                        (
                            SELECT @vizaMaxOrderIndex + 2
                        ) OrderIndex, 
                        dbo.fnGetPersonnelbyWorkPlaceId(a.AdrPersonId, 106) AS PersonTo, 						
                        N'Təsdiq üçün'
						 AS ExecutorMain, 
                        0 TypeOfAssignmentId
                        FROM dbo.DOCS_ADDRESSINFO a
						left join dbo.DOC_SENDSTATUS ds on a.AdrSendStatusId=ds.SendStatusId
                        WHERE a.AdrDocId = @docId
                              AND a.AdrTypeId= 2
                              AND a.AdrPersonId <> 0
                        UNION
                        SELECT CASE
                                   WHEN @adrPersonId > 0
                                   THEN
                        (
                            SELECT @vizaMaxOrderIndex + 3
                        )
                                   WHEN @adrPersonId = 0
                                   THEN
                        (
                            SELECT @vizaMaxOrderIndex + 2
                        )
                               END AS OrderIndex, 
                               dbo.fnGetPersonnelbyWorkPlaceId(t.WhomAddressId, 106) AS PersonTo, 
                        (
                            SELECT s.SendStatusName
                            FROM DOC_SENDSTATUS s
                            WHERE s.SendStatusId = t.TypeOfAssignmentId
                        ) AS ExecutorMain, 
                               t.TypeOfAssignmentId
                        FROM dbo.DOC_TASK t
                        WHERE t.TaskDocId = @docId AND t.TypeOfAssignmentId<>3
                    ) s
                    ORDER BY s.TypeOfAssignmentId FOR JSON AUTO
                ) AS JsonOperationHistory, 
                (
                    SELECT t.TaskId, 
                           t.TaskDocNo, 
                    (
                        SELECT s.SendStatusName
                        FROM dbo.DOC_SENDSTATUS s
                        WHERE s.SendStatusId = t.TypeOfAssignmentId
                    ) TypeOfAssignment, 
                           t.TaskNo, 
                           t.TaskDecription Task, 
                           t.TaskCycleId TaskCycle, 
                    (
                        SELECT tc.TaskCycleName
                        FROM dbo.DOC_TASK_CYCLE tc
                        WHERE tc.TaskCycleId = t.TaskCycleId
                              AND tc.DocTypeId = @docType
                    ) TaskCycleName, 
                           t.ExecutionPeriod, 
                           t.PeriodOfPerformance, 
                           t.OriginalExecutionDate, 
                    (
                        SELECT ISNULL(' ' + PE.PersonnelName, '') + ISNULL(' ' + PE.PersonnelSurname, '') + ISNULL(' ' + PE.PersonnelLastname, '')
                        FROM [dbo].DC_WORKPLACE WP
                             INNER JOIN [dbo].DC_USER DU ON WP.WorkplaceUserId = DU.UserId
                             INNER JOIN [dbo].DC_PERSONNEL PE ON DU.UserPersonnelId = PE.PersonnelId
                        WHERE PE.PersonnelStatus = 1
                              AND WP.WorkplaceId = t.WhomAddressId
                    ) WhomAddress
                    FROM dbo.DOC_TASK t
                    WHERE t.TaskDocId = @docId
                          AND t.WhomAddressId = CASE
                                                    WHEN @executorCount > 0
                                                    THEN @workPlaceId
                                                    WHEN @executorCount = 0
                                                    THEN t.WhomAddressId
                                                END FOR JSON AUTO
                ) AS JsonTask, 
                (
                    SELECT ActionId AS Id, 
                           ActionName AS Name
                    FROM @ActionTable  FOR json AUTO
                ) AS JsonActionName, 
                d.DocDescription AS Description
                FROM dbo.docs d
                WHERE d.docId = @docId
                      AND d.DocDoctypeId = @doctype FOR JSON AUTO;
        END;
            ELSE
            IF(@docInfoId IS NOT NULL)
                BEGIN
                    SELECT *
                    FROM dbo.DOCS_FILEINFO fi
                    WHERE fi.FileInfoId =
                    (
                        SELECT f.FileInfoId
                        FROM dbo.DOCS_FILE f
                        WHERE f.FileInfoId = @docInfoId
                              AND f.IsDeleted = 0
                              AND f.IsReject = 0
                    ) FOR JSON AUTO;
            END;
    END;

