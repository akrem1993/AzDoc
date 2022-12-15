/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [dbo].[spGetSettings]
@userId int
as
begin
 select *, (select t.TreeDocTypeId,t.TreeTreeName as TreeName from dbo.DC_TREE t for json auto) as JsonTree from dbo.DC_USER u where u.UserId=@userId for json auto
end

