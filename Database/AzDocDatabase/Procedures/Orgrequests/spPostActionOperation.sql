/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [orgrequests].[spPostActionOperation] @actionId    INT, 
                                                      @docId       INT, 
                                                      @docTypeId   INT, 
                                                      @workPlaceId INT,
                                                      @note nvarchar(max)=null, 
                                                      @result      INT OUTPUT
AS
BEGIN
BEGIN TRY
      BEGIN TRANSACTION
        DECLARE @documentStatusId INT= 0;
        IF(@actionId = 1) --Göndər
        BEGIN
                        EXEC orgrequests.spOperationSend 
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
                 
        --IF(@actionId = 6) --Imtina et
        --BEGIN
        --     EXEC dms_insdoc.spCancelDocumentRequest 
        --          @workPlaceId = @workPlaceId, 
        --          @docId = @docId, 
        --          @result = @result OUT;
        --     SET @result = 6;
        --END;

        IF(@actionId = 9) -- Senedin geri qaytarilmasi
        BEGIN
           exec orgrequests.ReturnDocumentRequest
                            @docId=@docId,
                            @workPlaceId=@workPlaceId,
                            @note=@note;
           SET @result = 9;
        END;
                   
        IF(@actionId = 11) -- Xidməti məktubla cavabla
        BEGIN
           SET @result = 11;
        END;
                      
        IF(@actionId = 12) -- Əlaqəli sənəd - Xidməti məktub
        BEGIN
             SET @result = 12;
        END;
                             
        IF(@actionId = 13) -- Xidməti məktubla cavabla
        BEGIN
              SET @result = 13;
        END;
                              
        IF(@actionId = 14) -- Əlaqəli sənəd - Xidməti məktub
        BEGIN
           SET @result = 14;
        END;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH--=======================================CATCH===================================================
       ROLLBACK TRANSACTION;
        
        SET @result=-1;
        DECLARE 
        @ErrorProcedure nvarchar(max),
        @ErrorMessage nvarchar(max), 
        @ErrorSeverity int, @ErrorState int;

        SELECT
        @ErrorProcedure='Procedure:'+ERROR_PROCEDURE(), 
        @ErrorMessage = @ErrorProcedure+'.Message:'+ERROR_MESSAGE() + ' Line ' + cast(ERROR_LINE() as nvarchar(5)),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE();

       INSERT INTO dbo.debugTable
       ([text],insertDate)
       VALUES
       (@ErrorMessage, dbo.SYSDATETIME())
         

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH--========================================CATCH======================================================


END;

