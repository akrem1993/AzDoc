/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [outgoingdoc].[spCancelPostOperation] @docId       INT, 
                                                               @docTypeId   INT, 
                                                               @workPlaceId INT, 
                                                               @note        NVARCHAR(MAX) = NULL, 
                                                               @result      INT OUTPUT
AS
    BEGIN
        SET NOCOUNT ON;        
        UPDATE dbo.DocOperationsLog
          SET 
              dbo.DocOperationsLog.OperationStatus = 13, --daha sonra legv edildi olacag
              dbo.DocOperationsLog.OperationStatusDate = dbo.SYSDATETIME(), 
              dbo.DocOperationsLog.OperationNote = @note
        WHERE dbo.DocOperationsLog.DocId = @docId
              AND ReceiverWorkPlaceId = @workPlaceId;
        SET @result = 17;

    END;

