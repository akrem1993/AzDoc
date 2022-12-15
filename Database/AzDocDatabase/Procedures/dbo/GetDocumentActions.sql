/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [dbo].[GetDocumentActions] @docId       INT, 
                                                @workPlaceId INT = NULL, 
            @menuTypeId int=0
         
AS
    BEGIN
            DECLARE @docTypeId INT;
            SELECT @docTypeId = d.DocDoctypeId
            FROM dbo.DOCS d
            WHERE d.DocId = @docId; 
            IF(@docTypeId = 1)
                BEGIN
                    EXEC orgrequests.GetDocumentActions 
       @docId = @docId,
       @workPlaceId = @workPlaceId,
       @menuTypeId = @menuTypeId;
            END;
                ELSE
                IF(@docTypeId = 2)
                    BEGIN
                        EXEC citizenrequests.GetDocumentActions 
       @docId = @docId,
       @workPlaceId = @workPlaceId,
       @menuTypeId = @menuTypeId;
                END;
                    ELSE
                    IF(@docTypeId = 3)
                        BEGIN
                             EXEC dms_insdoc.GetDocumentActions 
       @docId = @docId,
       @workPlaceId = @workPlaceId,
       @menuTypeId = @menuTypeId;
                    END;
                        ELSE
                        IF(@docTypeId = 12)
                            BEGIN
                                EXEC outgoingdoc.GetDocumentActions
        --@docTypeId = @docTypeId,
        @docId = @docId,
        @workPlaceId = @workPlaceId,
        @menuTypeId = @menuTypeId;
                        END;
                            ELSE
                            IF(@docTypeId = 18)
                                BEGIN
                                   EXEC serviceletters.GetDocumentActions 
       @docId = @docId,
       @workPlaceId = @workPlaceId,
       @menuTypeId = @menuTypeId;
                            END;

    END;

