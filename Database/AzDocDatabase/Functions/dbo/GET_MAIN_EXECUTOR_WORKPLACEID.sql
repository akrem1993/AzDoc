CREATE FUNCTION [dbo].[GET_MAIN_EXECUTOR_WORKPLACEID]
(
 @docId int
)
 RETURNS Int
AS
BEGIN

  return ISNULL((
  SELECT        TOP (1) dbo.DOCS_EXECUTOR.ExecutorWorkplaceId
FROM            dbo.DOCS_EXECUTOR INNER JOIN
                         dbo.DOCS_DIRECTIONS ON dbo.DOCS_EXECUTOR.ExecutorDirectionId = dbo.DOCS_DIRECTIONS.DirectionId
WHERE        (dbo.DOCS_EXECUTOR.DirectionTypeId = 1) AND (dbo.DOCS_EXECUTOR.ExecutorMain = 1) AND (dbo.DOCS_DIRECTIONS.DirectionDocId = @docId)
ORDER BY dbo.DOCS_DIRECTIONS.DirectionDate DESC
  ),0) 
END

