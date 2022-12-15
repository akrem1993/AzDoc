/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [dbo].[spGetUser]
@userId int
as
begin
 select * from dbo.DC_USER u where u.UserId=@userId;
end

