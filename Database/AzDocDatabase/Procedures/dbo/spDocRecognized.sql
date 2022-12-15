/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

CREATE PROCEDURE [dbo].[spDocRecognized] @docId       INT, 
                          @workPlaceId INT, 
                          @result      INT OUTPUT
AS
    BEGIN
        UPDATE dbo.DOCS_EXECUTOR
          SET 
              dbo.DOCS_EXECUTOR.ExecutorReadStatus = 1, -- bit
              dbo.DOCS_EXECUTOR.ExecutorControlStatus = 1 -- bit
        WHERE dbo.DOCS_EXECUTOR.ExecutorDocId = @docId
              AND dbo.DOCS_EXECUTOR.ExecutorWorkplaceId = @workPlaceId;
        SET @result = 1;
    END;

