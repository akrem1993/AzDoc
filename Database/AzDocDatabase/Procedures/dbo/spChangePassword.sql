/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE PROCEDURE [dbo].[spChangePassword]
 @userId int,
 @oldPassword nvarchar(max),
 @newPassword nvarchar(max),
 @result int output
as
 set nocount on;
 IF EXISTS (SELECT * from dbo.DC_USER u WHERE u.UserId =@userId and u.UserPassword=@oldPassword and u.UserStatus=1)
  BEGIN
        update dbo.DC_USER set UserPassword=@newPassword where UserId= @userId;
        set @result=1;
  END

