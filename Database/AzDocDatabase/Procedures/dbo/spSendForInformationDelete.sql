/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

CREATE PROCEDURE [dbo].[spSendForInformationDelete] @workPlaceId INT, 
                                            @docId       INT, 
                                            @result      INT OUTPUT
AS
    BEGIN
        DELETE dbo.DocOperationsLog
        WHERE dbo.DocOperationsLog.ExecutorId IN
        (
            SELECT de.ExecutorId
            FROM dbo.DOCS_EXECUTOR de
            WHERE de.ExecutorDocId = @docId
                  AND de.ExecutorWorkplaceId = @workPlaceId
        );
        SET @result = 1;
    END;

