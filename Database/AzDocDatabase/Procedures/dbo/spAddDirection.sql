/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [dbo].[spAddDirection] 
@directionDate datetime, 
@directionDocId int,
@directionTypeId int,
@directionWorkplaceId int,
@directionInsertedDate datetime, 
@directionPersonFullName nvarchar(500),
@directionCreatorWorkplaceId int,
@directionId int OUTPUT,
@result int OUTPUT

WITH EXEC AS CALLER
AS
INSERT INTO dbo.DOCS_DIRECTIONS
(
        DirectionDocId, DirectionDate, 
        DirectionWorkplaceId, DirectionPersonFullName, 
        DirectionTemplateId, DirectionTypeId, 
        DirectionControlStatus, DirectionPlanneddate, 
        DirectionPlannedDay, DirectionExecutionStatusId, 
        DirectionVizaId, DirectionConfirmed, 
        DirectionSendStatus, DirectionCreatorWorkplaceId, 
        DirectionInsertedDate, DirectionPersonId
) 
VALUES 
(
        @directionDocId, @directionDate, 
        @directionWorkplaceId, @directionPersonFullName, 
        NULL, @directionTypeId, 
        NULL, dbo.SYSDATETIME(), 
        NULL, NULL, 
        NULL, 1, --deyisiklik Shahriyar
        1, @directionCreatorWorkplaceId, 
        @directionInsertedDate, NULL
);

set @directionId = SCOPE_IDENTITY();
set @result=1;

