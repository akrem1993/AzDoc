/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [dbo].[spPostActionOperation] @actionId    INT, 
                                              @docId       INT, 
                                              @workPlaceId INT, 
                                              @note        NVARCHAR(MAX) = NULL, 
                                              @result      INT OUTPUT
AS
    BEGIN
        BEGIN TRY
            BEGIN TRANSACTION;
   DECLARE @docTypeId int;
   set @docTypeId=(select d.DocDoctypeId FROM dbo.DOCS d WHERE d.DocId=@docId);
   
   insert into dbo.debugTable
   values(@note , dbo.SYSDATETIME() )
  
            IF(@docTypeId = 1)
                BEGIN
                    EXEC orgrequests.spPostActionOperation 
                         @actionId = @actionId, 
                         @docId = @docId, 
                         @docTypeId = @docTypeId, 
                         @workPlaceId = @workPlaceId,
                         @note= @note,
                         @result = @result OUT;
            END;
                ELSE
                IF(@docTypeId = 2)
                    BEGIN
                        EXEC citizenrequests.spPostActionOperation 
                             @actionId = @actionId, 
                             @docId = @docId, 
                             @docTypeId = @docTypeId, 
                             @workPlaceId = @workPlaceId, 
                             @note= @note,
                             @result = @result OUT;
                END;
                    ELSE
                    IF(@docTypeId = 3)
                        BEGIN
                            EXEC dms_insdoc.spPostActionOperation 
                                 @actionId = @actionId, 
                                 @docId = @docId, 
                                 @docTypeId = @docTypeId, 
                                 @workPlaceId = @workPlaceId, 
                                 @note = @note, 
                                 @result = @result OUT;
                    END;
                        ELSE
                        IF(@docTypeId = 12)
                            BEGIN
                                EXEC outgoingdoc.spPostActionOperation 
                                     @actionId = @actionId, 
                                     @docId = @docId, 
                                     @docTypeId = @docTypeId, 
                                     @workPlaceId = @workPlaceId, 
                                     @note = @note, 
                                     @result = @result OUT;
                        END;
                            ELSE
                            IF(@docTypeId = 18)
                                BEGIN
                                    EXEC serviceletters.spPostActionOperation 
                                         @actionId = @actionId, 
                                         @docId = @docId, 
                                         @docTypeId = @docTypeId, 
                                         @workPlaceId = @workPlaceId, 
                                         @note = @note, 
                                         @result = @result OUT;
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
             dbo.SYSDATETIME()
            );
            RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
        END CATCH;--========================================CATCH======================================================

    END;

