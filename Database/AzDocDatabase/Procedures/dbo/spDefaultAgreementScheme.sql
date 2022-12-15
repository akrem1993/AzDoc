/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [dbo].[spDefaultAgreementScheme] @fileInfoId   INT, 
                                                 @answerDocIds  nvarchar(max) = NULL, 
                                                 @relatedDocId  INT = NULL, 
                                                 @signerWorkPlaceId INT = NULL,
                                                 @workPlaceId  INT, 
                                                 @currentDocId int=NULL,
                                                 @docTypeId    INT, 
                                                 @result       INT OUTPUT
WITH EXEC AS CALLER
AS
BEGIN TRY
     BEGIN TRANSACTION 
  EXEC dbo.spSetFileAsMain 
          @fileInfoId = @fileInfoId, 
          @result = @result OUT;

  SELECT @currentDocId = df.FileDocId 
  FROM dbo.DOCS_FILE df 
  WHERE df.FileInfoId=@fileInfoId;     


    IF EXISTS(SELECT dv.VizaId FROM dbo.DOCS_VIZA dv WHERE dv.VizaDocId=@currentDocId AND dv.IsDeleted=0)
    BEGIN
		SET @result = 1;
		COMMIT TRANSACTION
		RETURN;
    END;


     IF @result = 1
         BEGIN

             IF(@docTypeId IN(12, 18, 3))
                 BEGIN
                     DECLARE @fileId INT;

                     SET @fileId =
                     (
                         SELECT f.FileId
                         FROM dbo.docs_file f
                         WHERE f.FileInfoId = @fileInfoId
                     );

						EXEC dbo.spAddExecutorChiefsNew-- shobe mudurunu ,sektor m. ,qurum r. v.s elave edilir
                          @fileId = @fileId, 
                          @vizaDocId = @currentDocId, 
                          @relatedDocId=@relatedDocId,
						  @answerDocIds=@answerDocIds,
                          @signerWorkPlaceId = @signerWorkPlaceId,
                          @docTypeId = @docTypeId, 
                          @workPlaceId = @workPlaceId, 
                          @result = @result OUT;

                     IF(@docTypeId IN(12, 18))
                      BEGIN
                        DECLARE @answerIdCount int = 0;
                        SELECT @answerIdCount=count(0) FROM OPENJSON(@answerDocIds);
                        
                        DECLARE @answerDocId int;
                        
                        WHILE(@answerIdCount>0)
                        BEGIN
                         SELECT @answerDocId = S.[Value] 
                         FROM (
                           SELECT A.[Value], row_number() over(ORDER BY A.[Value]) AS [row] 
                           FROM OPENJSON(@answerDocIds) AS A) AS S 
                         WHERE S.[row] = @answerIdCount
                        
                         EXEC dbo.spAddDefaultVizaExecutors 
                           @fileId = @fileId, 
                           @answerDocId = @answerDocId, 
                           @signerWorkPlaceId = @signerWorkPlaceId,
                           @vizaDocId = @currentDocId, 
                           @workPlaceId = @workPlaceId, 
                           @result = @result OUT;
                        
                         SET @answerIdCount-=1;
                        END
                      END;
             END;
     END;

  COMMIT TRANSACTION
END TRY
BEGIN CATCH  
 ROLLBACK TRANSACTION;
 SET @result = 0;
 DECLARE @ErrorProcedure NVARCHAR(MAX), @ErrorMessage NVARCHAR(MAX), @ErrorSeverity INT, @ErrorState INT;
 SELECT @ErrorProcedure = 'Procedure:' + ERROR_PROCEDURE(), 
        @ErrorMessage = @ErrorProcedure + '.Message:' + ERROR_MESSAGE() + ' Line ' + CAST(ERROR_LINE() AS NVARCHAR(5)), 
        @ErrorSeverity = ERROR_SEVERITY(), 
        @ErrorState = ERROR_STATE();

  RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);

 INSERT INTO dbo.debugTable
 ([text], 
  insertDate
 )
 VALUES
 (@ErrorMessage, 
  dbo.SYSDATETIME()
 );

END CATCH

