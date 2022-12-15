/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [serviceletters].[spPostActionOperation] @actionId    INT, 
                                                         @docId       INT, 
                                                         @docTypeId   INT, 
                                                         @workPlaceId INT, 
                                                         @note        NVARCHAR(MAX) = NULL, 
                                                         @result      INT OUTPUT
AS
    BEGIN
    
            DECLARE @documentStatusId INT= 0;
            SELECT @documentStatusId = d.DocDocumentstatusId
            FROM dbo.DOCS d
            WHERE d.DocId = @docId;
            IF(@actionId = 1) --Göndər
                BEGIN
                    EXEC serviceletters.spOperationSend 
                         @docId = @docId, 
                         @workPlaceId = @workPlaceId, 
                         @result = @result OUT;
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
            END;
            IF(@actionId = 4) -- Məlumat üçün göndərmək
                BEGIN
                    SET @result = 4;
            END;
            IF(@actionId = 5) --Təsdiq et 
                BEGIN
                    IF(@documentStatusId IN(28, 16)) --Əgər vizadadirsa
                        BEGIN
                            EXEC serviceletters.spOperationVisaAccept 
                                 @docId = @docId, 
                                 @docTypeId = @docTypeId, 
                                 @workPlaceId = @workPlaceId, 
                                 @note = @note, 
                                 @result = @result OUT;
                            SET @result = @result;
                    END;
                        ELSE
                        BEGIN
                            EXEC serviceletters.spOperationWhomAddress -- Tapshiriqlara gedir
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
                    EXEC serviceletters.spCancelDocumentRequest 
                         @workPlaceId = @workPlaceId, 
                         @docId = @docId, 
                         @note = @note, 
                         @result = @result OUT;
                    SET @result = 6;
            END;
            IF(@actionId = 7) --İmza et
                BEGIN
                    EXEC serviceletters.spOperationConfirmSignature 
                         @docId = @docId, 
                         @docTypeId = @docTypeId, 
                         @workPlaceId = @workPlaceId, 
                         @note=@note,
                         @result = @result OUT;
                    SET @result = @result;
            END;
            IF(@actionId = 9) --Geri
                BEGIN
                    EXEC serviceletters.spReturnDocumentRequest 
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
         

    END;

