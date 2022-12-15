/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

-- =============================================
-- Author:  Rufin Ahmadov
-- Create date: 17.07.2019
-- Description: Cavab senedini silende hemin senede bagli olan sexleri vizadan silir
-- =============================================
CREATE PROCEDURE [dbo].[DeleteAnswerDoc]
 @answerDocId int ,
 @currentDocId int,
 @result int out
AS
BEGIN
 SET NOCOUNT ON;
 BEGIN TRY
  BEGIN TRANSACTION
  DECLARE @otherWorkPlaces table(WorkPlaceId int);
  DECLARE @otherAnswerDocIds table(AnswerDocId int, RowNumber int);

  INSERT INTO @otherAnswerDocIds
   SELECT DISTINCT dv.VizaAnswerDocId , row_number() OVER(ORDER BY dv.VizaAnswerDocId)
   FROM dbo.DOCS_VIZA dv 
   WHERE dv.VizaDocId = @currentDocId 
      AND dv.VizaAnswerDocId != @answerDocId;

  DECLARE @count int;
  SELECT @count = count(0) FROM @otherAnswerDocIds

  IF (@count > 0)
  BEGIN
   while(@count>0)
   BEGIN
    DECLARE @currentAnswerDocId int;
    SELECT @currentAnswerDocId=AnswerDocId FROM @otherAnswerDocIds WHERE RowNumber=@count

    INSERT INTO @otherWorkPlaces
     SELECT de.ExecutorWorkplaceId 
     FROM dbo.DOCS_EXECUTOR de 
     WHERE de.ExecutorDocId = (SELECT AnswerDocId FROM @otherAnswerDocIds WHERE RowNumber=@count)
        AND de.DirectionTypeId = 1

    UPDATE dbo.DOCS_VIZA
    SET
        dbo.DOCS_VIZA.IsDeleted = 1
    WHERE
     dbo.DOCS_VIZA.VizaAnswerDocId = @answerDocId 
     AND dbo.DOCS_VIZA.VizaWorkPlaceId NOT IN (SELECT WorkPlaceId FROM @otherWorkPlaces) 
     AND dbo.DOCS_VIZA.VizaFromWorkflow!=1;

    SET @result = 1;
    SET @count=@count - 1;
   end;
  END
  ELSE
  BEGIN
   IF EXISTS(SELECT dv.VizaId FROM  dbo.DOCS_VIZA dv WHERE dv.VizaAnswerDocId=@answerDocId)
   begin
    UPDATE dbo.DOCS_VIZA
    SET
        dbo.DOCS_VIZA.IsDeleted = 1
    WHERE
     VizaAnswerDocId = @answerDocId;

    SET @result = 1;
   END
   ELSE
    SET @result = 1;
  END;
  COMMIT TRANSACTION;
 END TRY
BEGIN CATCH
 SET @result = 0;
  ROLLBACK TRANSACTION;
 insert INTO dbo.debugTable
 VALUES(cast(error_message() AS nvarchar(max)), dbo.sysdatetime());
END CATCH
END

