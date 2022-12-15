CREATE procedure [admin].[UpdateWorkplaceStatus] @workplaceId  INT NULL
                                  
AS
    
    BEGIN
        BEGIN TRY
            BEGIN TRANSACTION;

			UPDATE DC_WORKPLACE 
			SET  WorkPlaceStatus = CASE WHEN WorkPlaceStatus = 0 THEN 1 Else 0 END
		    WHERE WorkplaceId = @workplaceId
             
            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            ROLLBACK;
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
        END CATCH;
    END;

