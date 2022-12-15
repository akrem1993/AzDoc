/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [outgoingdoc].[spPostActionOperation] @actionId    INT, 
                                                         @docId       INT, 
                                                         @docTypeId   INT, 
                                                         @workPlaceId INT, 
                                                         @note        NVARCHAR(MAX) = NULL, 
                                                         @result      INT OUTPUT
AS
    BEGIN
        BEGIN TRY
           BEGIN TRANSACTION;
            DECLARE @documentStatusId INT= 0;
            SELECT @documentStatusId = d.DocDocumentstatusId
            FROM dbo.DOCS d
            WHERE d.DocId = @docId;
            IF(@actionId = 1) --Göndər
                BEGIN
                    EXEC [outgoingdoc].[spOperationSend]
                         @docId = @docId, 
                         @workPlaceId = @workPlaceId, 
                         @result = @result OUT;
                    SET @result = @result;
            END;
            IF(@actionId = 2) --Redaktə et
                BEGIN
                    SET @result = 2;
            END;
            IF(@actionId = 3) --Tanış oldum
                BEGIN
                    EXEC dbo.spDocRecognized 
                    @docId = @docId,
                    @workPlaceId = @workPlaceId,
                    @result = @result out;
                    set @result=@result;
            END;
            IF(@actionId = 4) -- Məlumat üçün göndərmək
                BEGIN
                    SET @result = 4;
            END;
            IF(@actionId = 5) --Təsdiq et 
                BEGIN
                    IF(@documentStatusId IN(28, 16)) --Əgər vizadadirsa
                        BEGIN
                            EXEC outgoingdoc.spOperationVisaAccept 
                                 @docId = @docId, 
                                 @docTypeId = @docTypeId, 
                                 @workPlaceId = @workPlaceId, 
                                 @note = @note, 
                                 @result = @result OUT;
                            SET @result = @result;
                    END;
                        ELSE
                        BEGIN
                            EXEC outgoingdoc.spOperationWhomAddress -- Tapshiriqlara gedir
                                 @docId = @docId, 
                                 @docTypeId = @docTypeId, 
                                 @workPlaceId = @workPlaceId, 
                                 @result = @result OUT;
                            SET @result = @result;
                    END;
                    SET @result = 5;
            END;
            IF(@actionId = 6) --Imtina et
                BEGIN
                    EXEC outgoingdoc.spCancelDocumentRequest 
                         @workPlaceId = @workPlaceId, 
                         @docId = @docId, 
                         @note = @note, 
                         @result = @result OUT;
                    SET @result = 6;
            END;
            IF(@actionId = 7) --İmza et
                BEGIN
                    EXEC outgoingdoc.spOperationConfirmSignature 
                         @docId = @docId, 
                         @docTypeId = @docTypeId, 
                         @workPlaceId = @workPlaceId, 
                         @note=@note,
                         @result = @result OUT;
                    SET @result = @result;
            END;
            IF(@actionId = 9) --Geri
                BEGIN
                    EXEC outgoingdoc.spReturnDocumentRequest 
                         @workPlaceId = @workPlaceId, 
                         @docId = @docId, 
                         @note = @note, 
                         @result = @result OUT;
                    SET @result = @result;
            END;
            IF(@actionId = 11) -- Xidməti məktubla cavabla
                BEGIN
                    SET @result = 11;
            END;
            IF(@actionId = 12) -- Əlaqəli sənəd - Xidməti məktub
                BEGIN
                    SET @result = 12;
            END;
   
            IF(@actionId = 13) -- Xaric olan sənədlə cavabla 
                BEGIN
                    SET @result = 13;
            END;
            IF(@actionId = 14) -- Əlaqəli sənəd - Xaric olan
                BEGIN
                    SET @result = 14;
            END;
    IF(@actionId = 15) -- Çap et
                   BEGIN
                    EXEC outgoingdoc.spOperationPrint 
                         @docId = @docId, 
                         @docTypeId = @docTypeId, 
                         @workPlaceId = @workPlaceId, 
                         @result = @result OUT;
                    SET @result = @result;
            END;
     IF(@actionId = 16) --Poçt et
                BEGIN
						   	INSERT dbo.debugTable
						(
						    --id - column value is auto-generated
						    [text],
						    insertDate
						)
						VALUES
						(
						    -- id - int
						    N'org', -- text - nvarchar
						    dbo.Sysdatetime() -- insertDate - datetime
						)
    EXEC outgoingdoc.spOperationPost
    @docId = @docId, 
                         @docTypeId = @docTypeId, 
                         @workPlaceId = @workPlaceId, 
                         @result = @result OUT;
                    SET @result = 16;
            END;
    IF(@actionId = 17) --Göndərmə
                BEGIN
                    EXEC outgoingdoc.spCancelPostOperation
                         @workPlaceId = @workPlaceId,
       @docTypeId = @docTypeId,  
                         @docId = @docId, 
                         @note = @note, 
                         @result = @result OUT;
                    SET @result = @result;
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

