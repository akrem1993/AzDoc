
/*
Migrated by Kamran A-eff 23.08.2019
*/

create PROCEDURE [citizenrequests].[GetDocumentActionsBackup] @docId       INT, 
                                                       @workPlaceId INT, 
                                                       @menuTypeId  INT
AS
    BEGIN
        DECLARE @documentStatusId INT, @documentStatusName NVARCHAR(MAX), @directionType INT, @docCreatorWorkPLaceId INT, @docTypeId INT, @executorReadStatus INT, @sendStatus INT, @positonGroupId INT, @executorCount INT;
        DECLARE @Actions TABLE
        (Id          INT, 
         Name        NVARCHAR(MAX), 
         ActionIndex INT
        );
        SELECT @docTypeId = d.DocDoctypeId, 
               @documentStatusId = d.DocDocumentstatusId, 
               @documentStatusName = ds.DocumentstatusName, 
               @docCreatorWorkPLaceId = d.DocInsertedById
        FROM dbo.DOCS d
             JOIN dbo.DOC_DOCUMENTSTATUS ds ON ds.DocumentstatusId = d.DocDocumentstatusId
        WHERE d.DocId = @docId;
        --AND d.DocResultId IS NULL;
        SELECT @positonGroupId = ddp.PositionGroupId
        FROM dbo.DC_WORKPLACE dw
             LEFT JOIN dbo.DC_DEPARTMENT_POSITION ddp ON dw.WorkplaceDepartmentPositionId = ddp.DepartmentPositionId
        WHERE dw.WorkplaceId = @workPlaceId;
		
		--/* Muveqqeti redakte aciram */
        IF exists(SELECT dew.* FROM dbo.DOCS_EDIT_WORKPLACE dew WHERE dew.WorkPlaceId=@workPlaceId AND dew.DocId=@docId AND dew.IsStatus=1)
            BEGIN
                INSERT INTO @Actions
                (Id, 
                 Name, 
                 ActionIndex
                )
                       SELECT dan.ActionId, 
                              dan.ActionName, 
                              dan.ActionIndex
                       FROM dbo.DOC_ACTION_NAME dan
                       WHERE dan.ActionId = 2;
        END;
		/* Muveqqeti redakte aciram */
        IF EXISTS
        (
            SELECT de.*
            FROM dbo.DOCS_EXECUTOR de
            WHERE de.ExecutorDocId = @docId
                  AND de.ExecutorWorkplaceId = @workPlaceId
                  AND de.ExecutorReadStatus = 0
                  AND (de.ExecutionstatusId IS NULL
                       OR de.ExecutionstatusId = 1)
        )
            BEGIN
                SELECT @directionType = e.DirectionTypeId, 
                       @executorReadStatus = e.ExecutorReadStatus, 
                       @sendStatus = e.SendStatusId
                FROM dbo.DOCS_EXECUTOR e
                WHERE e.ExecutorDocId = @docId
                      AND e.ExecutorWorkplaceId = @workPlaceId
                      AND e.ExecutorReadStatus = 0;
                IF((@sendStatus IS NULL)
                   OR (@sendStatus = 0)
                   OR (@sendStatus IN(5,6,10, 15)))
                    BEGIN
                        INSERT INTO @Actions
                        (Id, 
                         Name, 
                         ActionIndex
                        )
                               SELECT dan.ActionId, 
                                      dan.ActionName, 
                                      dan.ActionIndex
                               FROM dbo.DOC_ACTION_TYPE dat
                                    INNER JOIN dbo.DOC_ACTION_NAME dan ON dat.ActionId = dan.ActionId
                               WHERE dat.DocTypeId = @docTypeId
                                     AND dat.DocumentStatusId = @documentStatusId
                                     AND dat.DirectionType = @directionType
                                     AND dan.MenuType IN(0, @menuTypeId)
                                    AND dan.ActionStatus = 1
                                    AND dat.ActionId NOT IN
                               (
                                   SELECT CASE
                                              WHEN @docCreatorWorkPLaceId = @workPlaceId
                                              THEN 9
                                              ELSE-1
                                          END
                               )
                               ORDER BY dan.ActionIndex ASC;
                END;
                    ELSE
                    IF(@sendStatus = 1
                       AND @positonGroupId IN(5,6, 17))  -- Icra ucun Oxunmamis veziyyeti
                        BEGIN
                            INSERT INTO @Actions
                            (Id, 
                             Name, 
                             ActionIndex
                            )
                                   SELECT dan.ActionId, 
                                          dan.ActionName, 
                                          dan.ActionIndex
                                   FROM dbo.DOC_ACTION_TYPE dat
                                        INNER JOIN dbo.DOC_ACTION_NAME dan ON dat.ActionId = dan.ActionId
                                   WHERE dat.DocTypeId = @docTypeId
                                         AND dat.DocumentStatusId = @documentStatusId
                                         AND dat.DirectionType = @directionType
                                         AND dan.MenuType IN(0, @menuTypeId)
                                        AND dan.ActionStatus = 1
                                        AND dat.ActionId NOT IN
                                   (
                                   (
                                       SELECT CASE
                                                  WHEN @docCreatorWorkPLaceId = @workPlaceId
                                                  THEN 9
                                                  ELSE-1
                                              END
                                   ), 3, 9
                                   )
                                   ORDER BY dan.ActionIndex ASC;
                    END;
                        ELSE
                        IF(@sendStatus = 1
                           AND @positonGroupId IN(9, 26))
                            BEGIN
                                INSERT INTO @Actions
                                (Id, 
                                 Name, 
                                 ActionIndex
                                )
                                       SELECT dan.ActionId, 
                                              dan.ActionName, 
                                              dan.ActionIndex
                                       FROM dbo.DOC_ACTION_TYPE dat
                                            INNER JOIN dbo.DOC_ACTION_NAME dan ON dat.ActionId = dan.ActionId
                                       WHERE dat.DocTypeId = @docTypeId
                                             AND dat.DocumentStatusId = @documentStatusId
                                             AND dat.DirectionType = @directionType
                                             AND dan.MenuType IN(0, @menuTypeId)
                                            AND dan.ActionStatus = 1
                                            AND dat.ActionId NOT IN
                                       (
                                       (
                                           SELECT CASE
                                                      WHEN @docCreatorWorkPLaceId = @workPlaceId
                                                      THEN 9
                                                      ELSE-1
                                                  END
                                       ), 3
                                       )
                                       ORDER BY dan.ActionIndex ASC;
                        END;
                            ELSE
                            IF(@sendStatus = 1
                               AND (@positonGroupId = 21
                                    OR @positonGroupId = 22
                                    OR @positonGroupId = 23))
                                BEGIN
                                    INSERT INTO @Actions
                                    (Id, 
                                     Name, 
                                     ActionIndex
                                    )
                                           SELECT dan.ActionId, 
                                                  dan.ActionName, 
                                                  dan.ActionIndex
                                           FROM dbo.DOC_ACTION_TYPE dat
                                                INNER JOIN dbo.DOC_ACTION_NAME dan ON dat.ActionId = dan.ActionId
                                           WHERE dat.DocTypeId = @docTypeId
                                                 AND dat.DocumentStatusId = @documentStatusId
                                                 AND dat.DirectionType = @directionType
                                                 AND dan.MenuType IN(0, @menuTypeId)
                                                AND dan.ActionStatus = 1
                                                AND dat.ActionId NOT IN
                                           (
                                           (
                                               SELECT CASE
                                                          WHEN @docCreatorWorkPLaceId = @workPlaceId
                                                          THEN 9
                                                          ELSE-1
                                                      END
                                           ), 3, 8
                                           )
                                           ORDER BY dan.ActionIndex ASC;
                            END;
                                ELSE
                                IF(@sendStatus = 2
                                   AND @positonGroupId IN(5,6, 17))
                                    BEGIN
                                        INSERT INTO @Actions
                                        (Id, 
                                         Name, 
                                         ActionIndex
                                        )
                                               SELECT dan.ActionId, 
                                                      dan.ActionName, 
                                                      dan.ActionIndex
                                               FROM dbo.DOC_ACTION_TYPE dat
                                                    INNER JOIN dbo.DOC_ACTION_NAME dan ON dat.ActionId = dan.ActionId
                                               WHERE dat.DocTypeId = @docTypeId
                                                     AND dat.DocumentStatusId = @documentStatusId
                                                     AND dat.DirectionType = @directionType
                                                     AND dan.MenuType IN(0, @menuTypeId)
                                                    AND dan.ActionStatus = 1
                                                    AND dat.ActionId NOT IN
                                               (
                                               (
                                                   SELECT CASE
                                                              WHEN @docCreatorWorkPLaceId = @workPlaceId
                                                              THEN 9
                                                              ELSE-1
                                                          END
                                               ), 3, 9, 11, 13, 14, 18, 19
                                               )
                                               ORDER BY dan.ActionIndex ASC;
                                END;
                                    ELSE
                                    IF(@sendStatus = 2
                                       AND @positonGroupId IN(9, 26))
                                        BEGIN
                                            INSERT INTO @Actions
                                            (Id, 
                                             Name, 
                                             ActionIndex
                                            )
                                                   SELECT dan.ActionId, 
                                                          dan.ActionName, 
                                                          dan.ActionIndex
                                                   FROM dbo.DOC_ACTION_TYPE dat
                                                        INNER JOIN dbo.DOC_ACTION_NAME dan ON dat.ActionId = dan.ActionId
                                                   WHERE dat.DocTypeId = @docTypeId
                                                         AND dat.DocumentStatusId = @documentStatusId
                                                         AND dat.DirectionType = @directionType
                                                         AND dan.MenuType IN(0, @menuTypeId)
                                                        AND dan.ActionStatus = 1
                                                        AND dat.ActionId NOT IN
                                                   (
                                                   (
                                                       SELECT CASE
                                                                  WHEN @docCreatorWorkPLaceId = @workPlaceId
                                                                  THEN 9
                                                                  ELSE-1
                                                              END
                                                   ), 3, 11, 13, 14, 18, 19
                                                   )
                                                   ORDER BY dan.ActionIndex ASC;
                                    END;
                                        ELSE
                                        IF(@sendStatus = 2
                                           AND @positonGroupId IN(21, 22))
                                            BEGIN
                                                INSERT INTO @Actions
                                                (Id, 
                                                 Name, 
                                                 ActionIndex
                                                )
                                                       SELECT dan.ActionId, 
                                                              dan.ActionName, 
                                                              dan.ActionIndex
                                                       FROM dbo.DOC_ACTION_TYPE dat
                                                            INNER JOIN dbo.DOC_ACTION_NAME dan ON dat.ActionId = dan.ActionId
                                                       WHERE dat.DocTypeId = @docTypeId
                                                             AND dat.DocumentStatusId = @documentStatusId
                                                             AND dat.DirectionType = @directionType
                                                             AND dan.MenuType IN(0, @menuTypeId)
                                                            AND dan.ActionStatus = 1
                                                            AND dat.ActionId NOT IN
                                                       (
                                                       (
                                                           SELECT CASE
                                                                      WHEN @docCreatorWorkPLaceId = @workPlaceId
                                                                      THEN 9
                                                                      ELSE-1
                                                                  END
                                                       ), 3, 8, 11, 13, 14, 18, 19
                                                       )
                                                       ORDER BY dan.ActionIndex ASC;
                                        END;
                                            ELSE
                                            IF(@sendStatus = 3
                                               OR @sendStatus = 4)
                                                BEGIN
                                                    SELECT @executorCount = COUNT(0)
                                                    FROM dbo.DOCS_EXECUTOR de
                                                    WHERE de.ExecutorDocId = @docId
                                                          AND de.ExecutorWorkplaceId = @workPlaceId;
                                                    IF(@executorCount = 1)
                                                        BEGIN
                                                            INSERT INTO @Actions
                                                            (Id, 
                                                             Name, 
                                                             ActionIndex
                                                            )
                                                                   SELECT dan.ActionId, 
                                                                          dan.ActionName, 
                                                                          dan.ActionIndex
                                                                   FROM dbo.DOC_ACTION_TYPE dat
                                                                        INNER JOIN dbo.DOC_ACTION_NAME dan ON dat.ActionId = dan.ActionId
                                                                   WHERE dat.DocTypeId = @docTypeId
                                                                         AND dat.DocumentStatusId = @documentStatusId
                                                                         AND dat.DirectionType = @directionType
                                                                         AND dan.MenuType IN(0, @menuTypeId)
                                                                        AND dan.ActionStatus = 1
                                                                        AND dat.ActionId NOT IN
                                                                   (
                                                                   (
                                                                       SELECT CASE
                                                                                  WHEN @docCreatorWorkPLaceId = @workPlaceId
                                                                                  THEN 9
                                                                                  ELSE-1
                                                                              END
                                                                   ), 8, 9, 11, 12, 13, 14, 18, 19
                                                                   )
                                                                   ORDER BY dan.ActionIndex ASC;
                                                    END;
                                                    IF(@executorCount = 2)
                                                        BEGIN
                                                            INSERT INTO @Actions
                                                            (Id, 
                                                             Name, 
                                                             ActionIndex
                                                            )
                                                                   SELECT dan.ActionId, 
                                                                          dan.ActionName, 
                                                                          dan.ActionIndex
                                                                   FROM dbo.DOC_ACTION_TYPE dat
                                                                        INNER JOIN dbo.DOC_ACTION_NAME dan ON dat.ActionId = dan.ActionId
                                                                   WHERE dat.DocTypeId = @docTypeId
                                                                         AND dat.DocumentStatusId = @documentStatusId
                                                                         AND dat.DirectionType = @directionType
                                                                         AND dan.MenuType IN(0, @menuTypeId)
                                                                        AND dan.ActionStatus = 1
                                                                        AND dat.ActionId NOT IN
                                                                   (
                                                                   (
                                                                       SELECT CASE
                                                                                  WHEN @docCreatorWorkPLaceId = @workPlaceId
                                                                                  THEN 9
                                                                                  ELSE-1
                                                                              END
                                                                   ), 9, 11, 12, 13, 14, 18, 19
                                                                   )
                                                                   ORDER BY dan.ActionIndex ASC;
                                                    END;
                                            END;
                                                ELSE
                                                IF(@sendStatus = 3)
                                                    BEGIN
                                                        INSERT INTO @Actions
                                                        (Id, 
                                                         Name, 
                                                         ActionIndex
                                                        )
                                                               SELECT dan.ActionId, 
                                                                      dan.ActionName, 
                                                                      dan.ActionIndex
                                                               FROM dbo.DOC_ACTION_TYPE dat
                                                                    INNER JOIN dbo.DOC_ACTION_NAME dan ON dat.ActionId = dan.ActionId
                                                               WHERE dat.DocTypeId = @docTypeId
                                                                     AND dat.DocumentStatusId = @documentStatusId
                                                                     AND dat.DirectionType = @directionType
                                                                     AND dan.MenuType IN(0, @menuTypeId)
                                                                    AND dan.ActionStatus = 1
                                                                    AND dat.ActionId NOT IN
                                                               (
                                                               (
                                                                   SELECT CASE
                                                                              WHEN @docCreatorWorkPLaceId = @workPlaceId
                                                                              THEN 9
                                                                              ELSE-1
                                                                          END
                                                               ), 8, 9, 11, 12, 13, 14, 18, 19
                                                               )
                                                               ORDER BY dan.ActionIndex ASC;
                                                END;
        END;
            ELSE
            IF EXISTS
            (
                SELECT de.*
                FROM dbo.DOCS_EXECUTOR de
                WHERE de.ExecutorDocId = @docId
                      AND de.ExecutorWorkplaceId = @workPlaceId
                      AND de.ExecutorReadStatus = 1
                      AND (de.ExecutionstatusId IS NULL
                           OR de.ExecutionstatusId = 1)
            )
                BEGIN
                    SELECT @directionType = e.DirectionTypeId, 
                           @executorReadStatus = e.ExecutorReadStatus, 
                           @sendStatus = e.SendStatusId
                    FROM dbo.DOCS_EXECUTOR e
                    WHERE e.ExecutorDocId = @docId
                          AND e.ExecutorWorkplaceId = @workPlaceId
                          AND e.ExecutorReadStatus = 1;
                    IF((@sendStatus IS NULL)
                       OR (@sendStatus = 0)
                       OR (@sendStatus IN(5,10, 15)))
                        BEGIN
                            INSERT INTO @Actions
                            (Id, 
                             Name, 
                             ActionIndex
                            )
                                   SELECT dan.ActionId, 
                                          dan.ActionName, 
                                          dan.ActionIndex
                                   FROM dbo.DOC_ACTION_TYPE dat
                                        INNER JOIN dbo.DOC_ACTION_NAME dan ON dat.ActionId = dan.ActionId
                                   WHERE dat.DocTypeId = @docTypeId
                                         AND dat.DocumentStatusId = @documentStatusId
                                         AND dat.DirectionType = @directionType
                                         AND dan.MenuType IN(0, @menuTypeId)
                                        AND dan.ActionStatus = 1
                                        AND dan.ActionId = 8
                                   ORDER BY dan.ActionIndex ASC;
                    END;
                    IF(@sendStatus = 1
                       AND @positonGroupId IN(5,6, 9, 17, 26))
                        BEGIN
                            INSERT INTO @Actions
                            (Id, 
                             Name, 
                             ActionIndex
                            )
                                   SELECT dan.ActionId, 
                                          dan.ActionName, 
                                          dan.ActionIndex
                                   FROM dbo.DOC_ACTION_TYPE dat
                                        INNER JOIN dbo.DOC_ACTION_NAME dan ON dat.ActionId = dan.ActionId
                                   WHERE dat.DocTypeId = @docTypeId
                                         AND dat.DocumentStatusId = @documentStatusId
                                         AND dat.DirectionType = @directionType
                                         AND dan.MenuType IN(0, @menuTypeId)
                                        AND dan.ActionStatus = 1
                                        AND dat.ActionId NOT IN
                                   (
                                   (
                                       SELECT CASE
                                                  WHEN @docCreatorWorkPLaceId = @workPlaceId
                                                  THEN 9
                                                  ELSE-1
                                              END
                                   ), 3, 9, 11, 13, 14, 18, 19
                                   )
                                   ORDER BY dan.ActionIndex ASC;
                    END;
                        ELSE
                        IF(@sendStatus = 1
                           AND @positonGroupId = 22)
                            BEGIN
                                INSERT INTO @Actions
                                (Id, 
                                 Name, 
                                 ActionIndex
                                )
                                       SELECT dan.ActionId, 
                                              dan.ActionName, 
                                              dan.ActionIndex
                                       FROM dbo.DOC_ACTION_TYPE dat
                                            INNER JOIN dbo.DOC_ACTION_NAME dan ON dat.ActionId = dan.ActionId
                                       WHERE dat.DocTypeId = @docTypeId
                                             AND dat.DocumentStatusId = @documentStatusId
                                             AND dat.DirectionType = @directionType
                                             AND dan.MenuType IN(0, @menuTypeId)
                                            AND dan.ActionStatus = 1
                                            AND dat.ActionId NOT IN
                                       (
                                       (
                                           SELECT CASE
                                                      WHEN @docCreatorWorkPLaceId = @workPlaceId
                                                      THEN 9
                                                      ELSE-1
                                                  END
                                       ), 3, 11, 13, 14, 18, 19
                                       )
                                       ORDER BY dan.ActionIndex ASC;
                        END;
                            ELSE
                            IF(@sendStatus = 2
                               AND (@positonGroupId IN(5, 6,17, 37, 38)))
                                BEGIN
                                    INSERT INTO @Actions
                                    (Id, 
                                     Name, 
                                     ActionIndex
                                    )
                                           SELECT dan.ActionId, 
                                                  dan.ActionName, 
                                                  dan.ActionIndex
                                           FROM dbo.DOC_ACTION_TYPE dat
                                                INNER JOIN dbo.DOC_ACTION_NAME dan ON dat.ActionId = dan.ActionId
                                           WHERE dat.DocTypeId = @docTypeId
                                                 AND dat.DocumentStatusId = @documentStatusId
                                                 AND dat.DirectionType = @directionType
                                                 AND dan.MenuType IN(0, @menuTypeId)
                                                AND dan.ActionStatus = 1
                                                AND dat.ActionId NOT IN
                                           (
                                           (
                                               SELECT CASE
                                                          WHEN @docCreatorWorkPLaceId = @workPlaceId
                                                          THEN 9
                                                          ELSE-1
                                                      END
                                           ), 3, 9, 11, 13, 14, 18, 19
                                           )
                                           ORDER BY dan.ActionIndex ASC;
                            END;
                                ELSE
                                IF(@sendStatus = 2
                                   AND @positonGroupId IN(9, 21, 22, 26))
                                    BEGIN
                                        INSERT INTO @Actions
                                        (Id, 
                                         Name, 
                                         ActionIndex
                                        )
                                               SELECT dan.ActionId, 
                                                      dan.ActionName, 
                                                      dan.ActionIndex
                                               FROM dbo.DOC_ACTION_TYPE dat
                                                    INNER JOIN dbo.DOC_ACTION_NAME dan ON dat.ActionId = dan.ActionId
                                               WHERE dat.DocTypeId = @docTypeId
                                                     AND dat.DocumentStatusId = @documentStatusId
                                                     AND dat.DirectionType = @directionType
                                                     AND dan.MenuType IN(0, @menuTypeId)
                                                    AND dan.ActionStatus = 1
                                                    AND dat.ActionId NOT IN
                                               (
                                               (
                                                   SELECT CASE
                                                              WHEN @docCreatorWorkPLaceId = @workPlaceId
                                                              THEN 9
                                                              ELSE-1
                                                          END
                                               ), 3, 8, 11, 13, 14, 18, 19
                                               )
                                               ORDER BY dan.ActionIndex ASC;
                                END;
                                    ELSE
                                    IF(@sendStatus = 3
                                       OR @sendStatus = 4)
                                        BEGIN
                                            SELECT @executorCount = COUNT(0)
                                            FROM dbo.DOCS_EXECUTOR de
                                            WHERE de.ExecutorDocId = @docId
                                                  AND de.ExecutorWorkplaceId = @workPlaceId;
                                            IF(@executorCount = 1)
                                                BEGIN
                                                    INSERT INTO @Actions
                                                    (Id, 
                                                     Name, 
                                                     ActionIndex
                                                    )
                                                           SELECT dan.ActionId, 
                                                                  dan.ActionName, 
                                                                  dan.ActionIndex
                                                           FROM dbo.DOC_ACTION_TYPE dat
                                                                INNER JOIN dbo.DOC_ACTION_NAME dan ON dat.ActionId = dan.ActionId
                                                           WHERE dat.DocTypeId = @docTypeId
                                                                 AND dat.DocumentStatusId = @documentStatusId
                                                                 AND dat.DirectionType = @directionType
                                                                 AND dan.MenuType IN(0, @menuTypeId)
                                                                AND dan.ActionStatus = 1
                                                                AND dat.ActionId NOT IN
                                                           (
                                                           (
                                                               SELECT CASE
                                                                          WHEN @docCreatorWorkPLaceId = @workPlaceId
                                                                          THEN 9
                                                                          ELSE-1
                                                                      END
                                                           ), 3, 8, 9, 11, 12, 13, 14, 18, 19
                                                           )
                                                           ORDER BY dan.ActionIndex ASC;
                                            END;
                                            IF(@executorCount = 2)
                                                BEGIN
                                                    INSERT INTO @Actions
                                                    (Id, 
                                                     Name, 
                                                     ActionIndex
                                                    )
                                                           SELECT dan.ActionId, 
                                                                  dan.ActionName, 
                                                                  dan.ActionIndex
                                                           FROM dbo.DOC_ACTION_TYPE dat
                                                                INNER JOIN dbo.DOC_ACTION_NAME dan ON dat.ActionId = dan.ActionId
                                                           WHERE dat.DocTypeId = @docTypeId
                                                                 AND dat.DocumentStatusId = @documentStatusId
                                                                 AND dat.DirectionType = @directionType
                                                                 AND dan.MenuType IN(0, @menuTypeId)
                                                                AND dan.ActionStatus = 1
                                                                AND dat.ActionId NOT IN
                                                           (
                                                           (
                                                               SELECT CASE
                                                                          WHEN @docCreatorWorkPLaceId = @workPlaceId
                                                                          THEN 9
                                                                          ELSE-1
                                                                      END
                                                           ), 3, 9, 11, 12, 13, 14, 18, 19
                                                           )
                                                           ORDER BY dan.ActionIndex ASC;
                                            END;
                                    END;
                                        ELSE
                                        IF(@sendStatus = 3
                                           OR @sendStatus = 4)
                                            BEGIN
                                                INSERT INTO @Actions
                                                (Id, 
                                                 Name, 
                                                 ActionIndex
                                                )
                                                       SELECT dan.ActionId, 
                                                              dan.ActionName, 
                                                              dan.ActionIndex
                                                       FROM dbo.DOC_ACTION_TYPE dat
                                                            INNER JOIN dbo.DOC_ACTION_NAME dan ON dat.ActionId = dan.ActionId
                                                       WHERE dat.DocTypeId = @docTypeId
                                                             AND dat.DocumentStatusId = @documentStatusId
                                                             AND dat.DirectionType = @directionType
                                                             AND dan.MenuType IN(0, @menuTypeId)
                                                            AND dan.ActionStatus = 1
                                                            AND dat.ActionId NOT IN
                                                       (
                                                       (
                                                           SELECT CASE
                                                                      WHEN @docCreatorWorkPLaceId = @workPlaceId
                                                                      THEN 9
                                                                      ELSE-1
                                                                  END
                                                       ), 3, 8, 9, 11, 12, 13, 14, 18, 19
                                                       )
                                                       ORDER BY dan.ActionIndex ASC;
                                        END;
            END;
        IF EXISTS
        (
            SELECT a.Id
            FROM @Actions a
        )
            BEGIN
                SELECT a.Id AS Id, 
                       a.Name
                FROM @Actions a
                ORDER BY a.ActionIndex ASC;
        END;
            ELSE
            BEGIN
                SELECT-1 AS Id, 
                      N'Sənəd ' + LOWER(@documentStatusName) AS Name;
        END;
    END;
