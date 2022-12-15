/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [resolution].[spDeleteDirection] 
@directionId int


AS
declare @directionSendStatus int;

begin transaction;
select @directionSendStatus=DirectionSendStatus from DOCS_DIRECTIONS with(rowlock,holdlock) 
where DirectionId=@directionId
if(@directionSendStatus=1)
 begin
   DELETE w FROM  DOCS_EXECUTOR w with(rowlock,holdlock) 
   INNER JOIN   DOCS_DIRECTIONS e ON ExecutorDirectionId=DirectionId
   WHERE DirectionId=@directionId and w.SendStatusId!=5
   
   ----update DOCS_DIRECTIONS set DirectionConfirmed=1 
   ----WHERE DirectionId=@directionId;--kamran 20190704
   
   update w set SendStatusId=15 FROM  DOCS_EXECUTOR w 
   INNER JOIN   DOCS_DIRECTIONS e  ON ExecutorDirectionId=DirectionId
   WHERE DirectionId=@directionId and w.SendStatusId=5;
 end
else 
 begin
   DELETE w FROM  DOCS_EXECUTOR w with(rowlock,holdlock) INNER JOIN   DOCS_DIRECTIONS e with(rowlock,holdlock)  ON ExecutorDirectionId=DirectionId
   WHERE DirectionId=@directionId 
   delete from DOCS_DIRECTIONS where DirectionId=@directionId 
 end
commit transaction;

