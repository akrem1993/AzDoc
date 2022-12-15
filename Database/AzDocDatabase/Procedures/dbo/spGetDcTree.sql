/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [dbo].[spGetDcTree]
as
begin
  set nocount on;
  select t.TreeId,t.TreeSchemaId,t.TreeDocTypeId,t.TreeDocTypeGroupId,t.TreeTreeName,t.TreeOrderIndex from DC_TREE t
end

