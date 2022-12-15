/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

-- =============================================
-- Author:  <Abdullayeva Gular>
-- Create date: <6/23/2019>
-- Description: <Get Authors for Direction>
-- =============================================
CREATE PROCEDURE [resolution].[GetSendStatus]
@docId int=null,
@executorWorkplaceId int=null



AS
BEGIN
 -- SET NOCOUNT ON added to prevent extra result sets from
 -- interfering with SELECT statements.
 SET NOCOUNT ON;

 
if exists(select ExecutorId from DOCS_EXECUTOR where ExecutorDocId=@docId and ExecutorMain=1  and ExecutorWorkplaceId=@executorWorkplaceId)--gulten xanim icraci oldugu halda derkenar yazibsa 
begin
if exists (select DirectionId from DOCS_DIRECTIONS where DirectionDocId=@docId and DirectionTypeId=1 and DirectionWorkplaceId=@executorWorkplaceId)
select ExecutorId,ExecutorMain,ExecutorWorkplaceId from DOCS_EXECUTOR where ExecutorDirectionId=
(SELECT top 1 DirectionId from DOCS_DIRECTIONS where DirectionDocId=@docId and DirectionTypeId=1 and DirectionWorkplaceId=@executorWorkplaceId) and ExecutorMain=1
else 
select 111111 ExecutorId, CAST(0 AS tinyint) ExecutorMain ,24 ExecutorWorkplaceId from DOCS_EXECUTOR where ExecutorDocId=@docId and ExecutorWorkplaceId=@executorWorkplaceId and DirectionTypeId=1
end
else 
select  ExecutorId,ExecutorMain,ExecutorWorkplaceId from DOCS_EXECUTOR where ExecutorDocId=@docId and ExecutorWorkplaceId=@executorWorkplaceId and DirectionTypeId=1


 

END

