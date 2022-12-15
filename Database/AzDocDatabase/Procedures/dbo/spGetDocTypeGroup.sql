/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [dbo].[spGetDocTypeGroup]
as 
begin
  set nocount on;
   select g.DocTypeGroupId,g.SchemaId,g.DocTypeGroupName,g.DocTypeGroupOrderIndex,g.DocTypeGroupStatus  from DOC_TYPE_GROUP g where g.DocTypeGroupStatus=1
end

