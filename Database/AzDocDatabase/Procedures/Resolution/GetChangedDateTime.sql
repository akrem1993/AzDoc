/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

-- =============================================
-- Author:  <A.Gular>
-- Create date: <7/22/2019>
-- Description: <Change Main Executor>
-- =============================================
CREATE PROCEDURE [resolution].[GetChangedDateTime]  
--@workplaceId int,
@docId int
--@directionId int

AS
BEGIN
 -- SET NOCOUNT ON added to prevent extra result sets from
 -- interfering with SELECT statements.
 SET NOCOUNT ON;
 --declare @oldExecutor nvarchar(500),@executorNote nvarchar(4000),@oldExecutorWorkplaceId int;
 --select @docId=DirectionDocId from DOCS_DIRECTIONS where DirectionId=@directionId    
select  isnull(OldDirectionPlannedDate,(SELECT dbo.DOCS.DocPlannedDate FROM DOCS WHERE dbo.DOCS.DocId=@docId)) OldPlannedDate,NewDirectionPlannedDate NewPlannedDate,DirectionChangeNote ExecutorNote
  from DOCS_DIRECTIONCHANGE where DocId=@docId  and ChangeType=2 ORDER BY dbo.DOCS_DIRECTIONCHANGE.DirectionChangeId desc
END

