/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [dbo].[spGetWorkPlaceIdByRequestId]
@requestId int,
@workPlaceId int output
as
begin
 set nocount on;
 select @workPlaceId=r.WorkPlaceId from [dbo].[DC_REQUEST] r where r.RequestId=@requestId;
end

