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
CREATE PROCEDURE [resolution].[GetChangedExecutor]  
--@workplaceId int,
@directionId int

AS
BEGIN
 -- SET NOCOUNT ON added to prevent extra result sets from
 -- interfering with SELECT statements.
 SET NOCOUNT ON;

 declare @docId int,@oldExecutor nvarchar(500),@executorNote nvarchar(4000),@oldExecutorWorkplaceId int;
 set  @docId =( select DirectionDocId from DOCS_DIRECTIONS where DirectionId=@directionId)
 select  [dbo].[GET_PERSON](2,OldExecutorWorkplaceId) OldExecutor ,[dbo].[GET_PERSON](2,NewExecutorWorkplaceId) NewExecutor,DirectionChangeNote  ExecutorNote from DOCS_DIRECTIONCHANGE where DirectionId=@directionId and
 DocId=@docId
 --select @oldExecutor =  [dbo].[GET_PERSON](2,SenderWorkPlaceId),@oldExecutorWorkplaceId=SenderWorkplaceId,@executorNote=OperationNote from DocOperationsLog where DocId=@docId  and OperationTypeId=10
 --select @oldExecutorWorkplaceId SenderWorkplaceId,@oldExecutor OldExecutor,@executorNote ExecutorNote,ExecutorFullName NewExecutor from DOCS_EXECUTOR where ExecutorDirectionId=@directionId  and ExecutorMain=1
 
END

