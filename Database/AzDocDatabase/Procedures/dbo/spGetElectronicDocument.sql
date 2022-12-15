/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [dbo].[spGetElectronicDocument] @docId       INT, 
                                                @docInfoId   INT = NULL, 
                                                @workPlaceId INT = NULL, 
                                            
                                                @result      INT OUTPUT
AS
    BEGIN
        BEGIN TRY
            BEGIN TRANSACTION;
   DECLARE @doctypeId int;
            SELECT @doctypeId= d.DocDoctypeId
            FROM dbo.DOCS d
            WHERE d.DocId = @docId;
  
            IF(@docTypeId = 1)
                BEGIN
                    EXEC orgrequests.spGetElectronicDocument 
                         @docId = @docId, 
                         @docType = @docTypeId, 
                         @docInfoId = @docInfoId, 
                         @workPlaceId = @workPlaceId;
            END;
                ELSE
                IF(@docTypeId = 2)
                    BEGIN
                        EXEC citizenrequests.spGetElectronicDocument 
                             @docId = @docId, 
                             @docType = @docTypeId, 
                             @docInfoId = @docInfoId, 
                             @workPlaceId = @workPlaceId;
                END;
                    ELSE
                    IF(@docTypeId = 3)
                        BEGIN
                            EXEC dms_insdoc.spGetElectronicDocument 
                                 @docId = @docId, 
                                 @docType = @docTypeId, 
                                 @docInfoId = @docInfoId, 
                                 @workPlaceId = @workPlaceId;
                    END;
                        ELSE
                        IF(@docTypeId = 12)
                            BEGIN
                                EXEC outgoingdoc.spGetElectronicDocument 
                                     @docId = @docId, 
                                     @docType = @docTypeId, 
                                     @docInfoId = @docInfoId, 
                                     @workPlaceId = @workPlaceId;
                        END;
                            ELSE
                            IF(@docTypeId = 18)
                                BEGIN
                                    EXEC serviceletters.spGetElectronicDocument 
                                         @docId = @docId, 
                                         @docType = @docTypeId, 
                                         @docInfoId = @docInfoId, 
                                         @workPlaceId = @workPlaceId;
                            END;
            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH--=======================================CATCH===================================================
            ROLLBACK TRANSACTION;
            SET @result = -1;
            DECLARE @ErrorProcedure NVARCHAR(MAX), @ErrorMessage NVARCHAR(MAX), @ErrorSeverity INT, @ErrorState INT;
            SELECT @ErrorProcedure = 'Procedure:' + ERROR_PROCEDURE(), 
                   @ErrorMessage = @ErrorProcedure + '.Message:' + ERROR_MESSAGE() + ' Line ' + CAST(ERROR_LINE() AS NVARCHAR(5)), 
                   @ErrorSeverity = ERROR_SEVERITY(), 
                   @ErrorState = ERROR_STATE();
            INSERT INTO dbo.debugTable
            ([text], 
             insertDate
            )
            VALUES
            (@ErrorMessage, 
             SYSDATETIME()
            );
            RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
        END CATCH;--========================================CATCH======================================================

    END;

