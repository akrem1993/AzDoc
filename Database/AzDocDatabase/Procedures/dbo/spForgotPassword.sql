/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE procedure [dbo].[spForgotPassword]
 @resetCode nvarchar(6),
 @userName nvarchar(30),
 @password nvarchar(max),
 @result int output
as
 set nocount on;
  Declare @UserID int;
  select @UserID=(select u.UserId from dbo.DC_USER u where u.UserName=@userName)
 IF EXISTS (SELECT * from dbo.DC_USER u  
                      WHERE u.UserId =(select @UserID) and u.UserStatus=1)
  BEGIN
       IF EXISTS (select * from dbo.DC_USER_RESET_CODE r where r.UserId=(select @UserID) and r.ResetCode=@resetCode and r.ResetStatus=1)
       BEGIN
         update dbo.DC_USER set UserPassword=@password where UserId=(select @UserID);
         update dbo.DC_USER_RESET_CODE  set ResetStatus=0 where UserId=(select @UserID) and ResetCode=@resetCode and ResetStatus=1;
         set @result=1;
       END
       else
       begin
         set @result=2;
       end
  END
  ELSE IF EXISTS(SELECT * from dbo.DC_USER u WHERE u.UserId =(select @UserID) and u.UserStatus=0)
  BEGIN
    set @result=0;
  END
  ELSE
  BEGIN
    set @result=-1;
  END

