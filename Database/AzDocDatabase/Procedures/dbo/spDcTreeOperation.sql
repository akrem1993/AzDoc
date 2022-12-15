/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [dbo].[spDcTreeOperation]
@userId int,
@treeId int,
@result int output
as
set NOCOUNT on;
begin
  if exists(select * from dbo.DC_USER u where u.UserId=@userId and u.UserStatus=1)
  begin
      update dbo.DC_USER set DefaultPage=@treeId where UserId=@userId;
      set @result=1;
  end
  else
  begin
      set @result=-1;
  end
 
end;

