
/*
Migrated by Kamran A-eff 23.08.2019
*/
/*
Migrated by Kamran A-eff 06.08.2019
*/
/*
Migrated by Kamran A-eff 11.07.2019
*/

-- =============================================
-- Author:  Musayev Nurlan
-- Create date: 21.06.2019
-- Description: Senedin emeliyyatlarini getirmek
-- =============================================
CREATE PROCEDURE [smdo].[GetDocumentActions] @docId       INT, 
                                                      @workPlaceId INT, 
                                                      @menuTypeId  INT = 0
AS
    BEGIN
        DECLARE @Actions TABLE
        (Id          INT, 
         Name        NVARCHAR(MAX), 
         ActionIndex INT
        );
        DECLARE @documentStatusId INT, @documentStatusName NVARCHAR(MAX), @directionType INT, @docCreatorWorkPLaceId INT, @docTypeId INT, @executorReadStatus INT, @sendStatus INT, @positonGroupId INT, @isViza BIT= 0, @orgId INT, @docOrgId INT;
        SELECT @orgId =
        (
            SELECT dbo.fnPropertyByWorkPlaceId(@workPlaceId, 12)
        );
        SELECT @docTypeId = d.DocDoctypeId, 
               @documentStatusId = d.DocDocumentstatusId, 
               @documentStatusName = ds.DocumentstatusName, 
               @docCreatorWorkPLaceId = d.DocInsertedById, 
               @docOrgId = d.DocOrganizationId
        FROM dbo.DOCS d
             JOIN dbo.DOC_DOCUMENTSTATUS ds ON ds.DocumentstatusId = d.DocDocumentstatusId
        WHERE d.DocId = @docId;

        ----/* Muveqqeti redakte aciram */
        IF EXISTS
        (
            SELECT dew.*
            FROM dbo.DOCS_EDIT_WORKPLACE dew
            WHERE dew.WorkPlaceId = @workPlaceId
                  AND dew.DocId = @docId
                  AND dew.IsStatus = 1
        )
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
                  AND de.ExecutorReadStatus = 1
        )
            BEGIN
                IF EXISTS
                (
                    SELECT de.*
                    FROM dbo.DOCS_EXECUTOR de
                    WHERE de.ExecutorDocId = @docId
                          AND de.ExecutorWorkplaceId = @workPlaceId
                          AND de.ExecutorReadStatus = 0
                )
                    BEGIN
                        SELECT @directionType = e.DirectionTypeId, 
                               @executorReadStatus = e.ExecutorReadStatus, 
                               @sendStatus = e.SendStatusId
                        FROM dbo.DOCS_EXECUTOR e
                        WHERE e.ExecutorDocId = @docId
                              AND e.ExecutorWorkplaceId = @workPlaceId
                              AND e.ExecutorReadStatus = 0;
                END;
                    ELSE
                    BEGIN
                        SELECT @directionType = e.DirectionTypeId, 
                               @executorReadStatus = e.ExecutorReadStatus, 
                               @sendStatus = e.SendStatusId
                        FROM dbo.DOCS_EXECUTOR e
                        WHERE e.ExecutorDocId = @docId
                              AND e.ExecutorWorkplaceId = @workPlaceId;
                END;
        END;
            ELSE
            BEGIN
                SELECT @directionType = e.DirectionTypeId, 
                       @executorReadStatus = e.ExecutorReadStatus, 
                       @sendStatus = e.SendStatusId
                FROM dbo.DOCS_EXECUTOR e
                WHERE e.ExecutorDocId = @docId
                      AND e.ExecutorWorkplaceId = @workPlaceId;
        END;
        SELECT @positonGroupId = ddp.PositionGroupId
        FROM dbo.DC_WORKPLACE dw
             LEFT JOIN dbo.DC_DEPARTMENT_POSITION ddp ON dw.WorkplaceDepartmentPositionId = ddp.DepartmentPositionId
        WHERE dw.WorkplaceId = @workPlaceId;
        IF(((@sendStatus IS NULL)
            OR (@sendStatus IN(0, 7, 8, 12)))
           AND @executorReadStatus = 0)
            BEGIN
                IF @directionType = 3
                   AND EXISTS
                (
                    SELECT dv.VizaId
                    FROM dbo.DOCS_VIZA dv
                    WHERE dv.VizaDocId = @docId
                          AND dv.VizaWorkPlaceId = @workPlaceId
                          AND dv.VizaFromWorkflow IN(3, 4)
                )
                    SET @isViza = 1;
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
                            AND dat.ActionId NOT IN
                       (
                           SELECT CASE
                                      WHEN @isViza = 1
                                      THEN 2
                                      ELSE-1
                                  END
                       )
                       ORDER BY dan.ActionIndex ASC;
        END;

                --IF EXISTS
                --(
                --    SELECT dap.*
                --    FROM dbo.DOC_ACTION_POSITION dap
                --    WHERE dap.SendStatus = ISNULL(@sendStatus, 0)
                --          AND dap.ExecutorReadStatus = @executorReadStatus
                --)
            ELSE
            IF(@sendStatus = 1
               AND @executorReadStatus = 0
               AND @positonGroupId IN(5, 6, 17)) -- Icra ucun Oxunmamis veziyyeti
                BEGIN
                    IF(@orgId <> 1
                       AND @positonGroupId >= 5)
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
                                   ), 3, 9, 18
                                   )
                                   ORDER BY dan.ActionIndex ASC;
                    END;
                        ELSE
                        BEGIN
                            IF(@orgId <> 1
                               AND @positonGroupId >= 5)
                                BEGIN
                                    IF(@docOrgId = @orgId)
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
                                                   ), 3, 9, 18
                                                   )
                                                   ORDER BY dan.ActionIndex ASC;
                                    END;
                            END;
                                ELSE
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
                    END;
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
                               ), 3, 18
                               )
                               ORDER BY dan.ActionIndex ASC;
                END;
                    ELSE
                    IF(@sendStatus = 1
                       AND @executorReadStatus = 0
                       AND (@positonGroupId = 21
                            OR @positonGroupId = 22
                            OR @positonGroupId = 23)) -- Icra ucun Oxunmamis veziyyeti adi ishci ucun
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
                                   ), 8, 3
                                   )
                                   ORDER BY dan.ActionIndex ASC;
                    END;
                        ELSE
                        IF(@sendStatus = 1
                           AND @executorReadStatus = 1
                           AND @positonGroupId IN(5, 6, 9, 17, 26)) -- Icra ucun Oxunmus veziyyeti
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
                                       ), 11, 13, 14, 3, 9
                                       )
                                       ORDER BY dan.ActionIndex ASC;
                        END;
                            ELSE
                            IF(@sendStatus = 2
                               AND @executorReadStatus = 0
                               AND @positonGroupId IN(5, 6, 9, 17, 26)) -- Icra ve melumat ucun Oxunmamis veziyyeti
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
                                           ), 3, 11, 13, 14, 9
                                           )
                                           ORDER BY dan.ActionIndex ASC;
                            END;
                                ELSE
                                IF(@sendStatus = 2
                                   AND @executorReadStatus = 1
                                   AND @positonGroupId IN(5, 6, 9, 17, 26)) -- Icra ve melumat ucun oxunmus veziyyeti
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
                                               ), 3, 11, 13, 14, 9
                                               )
                                               ORDER BY dan.ActionIndex ASC;
                                END;
                                    ELSE
                                    IF(@sendStatus = 2
                                       AND @executorReadStatus = 0
                                       AND (@positonGroupId = 21
                                            OR @positonGroupId = 22
                                            OR @positonGroupId = 23)) -- Icra ve melumat ucun Oxunmamis veziyyeti adi ishci ucun
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
                                                   ), 8, 3, 11, 13, 14, 9
                                                   )
                                                   ORDER BY dan.ActionIndex ASC;
                                    END;
                                        ELSE
                                        IF((@sendStatus = 3
                                            OR @sendStatus = 4)
                                           AND @executorReadStatus = 0
                                           AND @directionType IN(17, 18)
                                           AND (@positonGroupId = 1
                                                OR @positonGroupId = 2
                                                OR @positonGroupId = 33
                                                OR @positonGroupId = 5
                                                OR @positonGroupId = 17
                                                OR @positonGroupId = 26)) --Melumat ucun Oxunmamis veziyyeti -- Kime unbanlanibdan daxil olub
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
                                                       ), 11, 12, 13, 14, 9
                                                       )
                                                       ORDER BY dan.ActionIndex ASC;
                                        END;
                                            ELSE
                                            IF((@sendStatus = 3)
                                               AND @directionType = 1) --Melumat ucun Oxunmamis veziyyeti -- Derkenardan  daxil olub
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
                                                           ),  11, 12, 13, 14, 9
                                                           )
                                                           ORDER BY dan.ActionIndex ASC;
                                            END;
											ELSE
                                            IF(( @sendStatus = 4)
                                               AND @executorReadStatus = 0
                                               AND @directionType = 1) --Melumat ucun Oxunmamis veziyyeti -- Derkenardan  daxil olub
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
                                                           ), 8, 11, 12, 13, 14, 9
                                                           )
                                                           ORDER BY dan.ActionIndex ASC;
                                            END;
                                                ELSE
                                                IF((@sendStatus = 3
                                                    OR @sendStatus = 4)
                                                   AND @executorReadStatus = 1
                                                   AND @directionType <> 2
                                                   AND (@positonGroupId = 1
                                                        OR @positonGroupId = 2
                                                        OR @positonGroupId = 33
                                                        OR @positonGroupId = 5
                                                        OR @positonGroupId = 17
                                                        OR @positonGroupId = 26)) --Melumat ucun Oxunmus veziyyeti
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
                                                               ), 3, 11, 12, 13, 14, 9
                                                               )
                                                               ORDER BY dan.ActionIndex ASC;
                                                END;
                                                    ELSE
                                                    IF((@sendStatus = 3
                                                        OR @sendStatus = 4)
                                                       AND @directionType <> 2
                                                       AND @executorReadStatus = 0
                                                       AND (@positonGroupId = 21
                                                            OR @positonGroupId = 22
                                                            OR @positonGroupId = 23)) --Melumat ucun Oxunmamis veziyyeti adi ishci ucun
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
                                                                   ), 8, 11, 12, 13, 14, 9
                                                                   )
                                                                   ORDER BY dan.ActionIndex ASC;
                                                    END;
                                                        ELSE
                                                        IF(@sendStatus = 3
                                                           AND @directionType = 2
                                                           AND (@positonGroupId NOT IN(1, 2, 33))) --Melumat ucun Oxunmamis veziyyeti -- Derkenardan  daxil olub
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
                                                                       ), 8, 11, 12, 13, 14, 9
                                                                       )
                                                                       ORDER BY dan.ActionIndex ASC;
                                                        END;
                                                            ELSE
                                                            IF(@sendStatus = 3
                                                               AND @directionType = 2
                                                               AND (@positonGroupId IN(1, 2, 33))) --Melumat ucun Oxunmamis veziyyeti -- Derkenardan  daxil olub
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
                                                                           ), 11, 12, 13, 14, 9
                                                                           )
                                                                           ORDER BY dan.ActionIndex ASC;
                                                            END;
                                                                ELSE
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
                                                                           WHERE dan.ActionId = 4;
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

