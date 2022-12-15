/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [dbo].[spUpdateDirection] 
@directionDate datetime, 
@directionDocId int,
@directionTypeId int, 
@directionUnixTime bigint, 
@directionWorkplaceId bit,
@directionInsertedDate datetime, 
@directionPersonFullName nvarchar(500),
@directionCreatorWorkplaceId int,
@directionId int,
@result int OUTPUT

WITH EXEC AS CALLER
AS
UPDATE dbo.DOCS_DIRECTIONS
SET 
DirectionDocId = @directionDocId , 
DirectionDate = @directionDate, 
DirectionWorkplaceId = @directionWorkplaceId, 
DirectionPersonFullName = @directionPersonFullName, 
DirectionTypeId = @directionTypeId,
DirectionCreatorWorkplaceId = @directionCreatorWorkplaceId, 
DirectionInsertedDate = @directionInsertedDate, 
DirectionUnixTime = @directionUnixTime 
WHERE DirectionId = @directionId;

set @result=1;

