/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [outgoingdoc].[spGetActionName] @docTypeId   INT, 
                                                   @docId       INT, 
                                                   @workPlaceId INT, 
                                                   @menuTypeId  INT
AS
    BEGIN
        DECLARE @documentStatusId INT, @directionType INT, @sendStatusId INT;
        SELECT @documentStatusId = d.DocDocumentstatusId
        FROM dbo.DOCS d
        WHERE d.docId = @docId;
        SELECT @directionType = e.DirectionTypeId
        FROM dbo.DOCS_EXECUTOR e
        WHERE e.ExecutorDocId = @docId
              AND e.ExecutorWorkplaceId = @workPlaceId
              AND e.ExecutorReadStatus = 0;
        SELECT @sendStatusId = dt.TypeOfAssignmentId
        FROM dbo.DOC_TASK dt
        WHERE dt.TaskDocId = @docId
              AND dt.WhomAddressId = @workPlaceId;
        IF(@directionType IS NOT NULL)
            BEGIN
                IF(@menuTypeId = 0)
                    BEGIN
                        IF(@documentStatusId <> 1)
                            BEGIN
                                SELECT an.ActionId Id, 
                                       an.ActionName Name
                                FROM dbo.DOC_ACTION_NAME an
                                     INNER JOIN dbo.DOC_ACTION_TYPE at ON an.ActionId = at.ActionId
                                WHERE an.ActionStatus = 1
                                      AND at.DocTypeId = @docTypeId
                                      AND at.DocumentStatusId = @documentStatusId
                                      AND at.DirectionType = @directionType
                                      AND an.MenuType IN(0)
                                ORDER BY an.ActionIndex ASC;
                        END;
                            ELSE
                            BEGIN
                                SELECT an.ActionId Id, 
                                       an.ActionName Name
                                FROM dbo.DOC_ACTION_NAME an
                                     INNER JOIN dbo.DOC_ACTION_TYPE at ON an.ActionId = at.ActionId
                                WHERE an.ActionStatus = 1
                                      AND at.DocTypeId = @docTypeId
                                      AND at.DocumentStatusId = @documentStatusId
                                      AND at.DirectionType = @directionType
                                      AND an.MenuType IN(0)
                                ORDER BY an.ActionIndex ASC;
                        END;
                END;
                    ELSE
                    BEGIN
                        SELECT an.ActionId Id, 
                               an.ActionName Name
                        FROM dbo.DOC_ACTION_NAME an
                             INNER JOIN dbo.DOC_ACTION_TYPE at ON an.ActionId = at.ActionId
                        WHERE an.ActionStatus = 1
                              AND at.DocTypeId = @docTypeId
                              AND at.DocumentStatusId = @documentStatusId
                              AND at.DirectionType = @directionType
                              AND an.MenuType IN(0, @menuTypeId)
                        ORDER BY an.ActionIndex ASC;
                END;
        END;
            ELSE
            BEGIN
                SELECT-1 AS Id, 
                      (N'Sənəd ' + LOWER(
                (
                    SELECT ds.DocumentstatusName
                    FROM dbo.DOC_DOCUMENTSTATUS ds
                    WHERE ds.DocumentstatusId = d.DocDocumentstatusId
                ))) Name
                FROM dbo.docs d
                WHERE d.DocId = @docId;
        END;
    END;

