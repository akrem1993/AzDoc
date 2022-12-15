/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [dbo].[spDcRequestCount]
@requestCount int output,
@unAnswered int output
as
set nocount on;
begin
 select @requestCount=COUNT(0) from [dbo].[DC_REQUEST];
 select @unAnswered=count(0) from [dbo].[DC_REQUEST] r where r.RequestStatusId in(3,4)
end

