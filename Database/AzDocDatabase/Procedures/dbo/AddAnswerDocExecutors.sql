/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

-- =============================================
-- Author:  Rufin Ahmadov
-- Create date: 17.07.2019
-- Description: Yeni cavab senedi elave eden zaman musterek icracilari vizaya elave edir
-- =============================================
CREATE PROCEDURE [dbo].[AddAnswerDocExecutors] @currentDocId      INT NULL, 
                                              @answerDocId       INT NULL, 
                                              @signerWorkPlaceId INT NULL, 
                                              @workPlaceId       INT NULL, 
                                              @result            INT OUT
AS
    BEGIN
        SET NOCOUNT ON;
        BEGIN TRY
            
			IF EXISTS(SELECT dv.VizaId
								FROM dbo.DOCS_VIZA dv
								WHERE dv.VizaDocId = @currentDocId
									  AND dv.IsDeleted=0
									  AND dv.VizaAnswerDocId=@answerDocId)
					begin 
						set @result=-1; -- movcud cavab senedi
						return @result;
					end;

                    DECLARE @fileId INT;
                    SELECT @fileId = df.FileId
                    FROM dbo.DOCS_FILE df
                    WHERE df.FileDocId = @currentDocId
                          AND df.FileIsMain = 1
                          AND df.IsDeleted = 0;

					IF NOT EXISTS(SELECT * FROM dbo.DOCS_VIZA dv WHERE dv.VizaDocId=@currentDocId AND dv.IsDeleted=0)
					BEGIN
						EXEC dbo.[spAddExecutorChiefsNew] 
                          @fileId = @fileId, 
                          @vizaDocId = @currentDocId, 
                          @relatedDocId=NULL,
                          @signerWorkPlaceId = @signerWorkPlaceId,
                          @docTypeId = NULL, 
                          @workPlaceId = @workPlaceId, 
                          @result = @result OUT;
					END;

                    EXEC dbo.spAddDefaultVizaExecutors 
                         @fileId = @fileId, 
                         @answerDocId = @answerDocId, 
                         @signerWorkPlaceId = @signerWorkPlaceId, 
                         @vizaDocId = @currentDocId, 
                         @workPlaceId = @workPlaceId, 
                         @result = @result OUT;

        END TRY
        BEGIN CATCH
            SET @result = 0;
            DECLARE @errorMessage NVARCHAR(MAX), @errorLine NVARCHAR(MAX);
            SELECT @errorMessage = ERROR_MESSAGE();
            SELECT @errorLine = 'Error Line: ' + CAST(ERROR_LINE() AS NVARCHAR(MAX));
            SELECT @errorMessage+=@errorLine;
            THROW 51000, @errorMessage, 1;
        END CATCH;
    END;

