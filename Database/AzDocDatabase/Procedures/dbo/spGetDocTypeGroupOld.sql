/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [dbo].[spGetDocTypeGroupOld]
as 
begin
  set nocount on;
  select a.* from (
          select 0 TreeId,0 TreeSchemaId,0 TreeDocTypeId,g.DocTypeGroupId TreeDocTypeGroupId,g.DocTypeGroupName TreeTreeName, g.DocTypeGroupOrderIndex TreeOrderIndex  from DOC_TYPE_GROUP g where g.DocTypeGroupStatus=1
          union 
          select t.TreeId,t.TreeSchemaId,t.TreeDocTypeId,t.TreeDocTypeGroupId,t.TreeTreeName,t.TreeOrderIndex from DC_TREE t ) a
  order by a.TreeDocTypeGroupId asc,a.TreeOrderIndex asc
end

