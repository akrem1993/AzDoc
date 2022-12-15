CREATE FUNCTION [dbo].[fnGetPersonnelbyWorkPlaceId]
(
 @workPlaceId int, @personnelFormat int = 100
)
RETURNS nvarchar(MAX)
AS
BEGIN
 DECLARE @result nvarchar(MAX); 
 
 IF @personnelFormat = 203
  select @result=p.PersonnelName from [dbo].[DC_PERSONNEL] p 
  where p.PersonnelId=
       (select u.UserPersonnelId from [dbo].DC_USER u where u.UserId=
       (select w.WorkplaceUserId from [dbo].[DC_WORKPLACE] w where w.WorkplaceId=@workPlaceId))
   
 ELSE IF @personnelFormat = 100
   select @result=p.PersonnelName + ' ' + substring(p.PersonnelName, 1, 1) + '.' from [dbo].[DC_PERSONNEL] p 
   where p.PersonnelId=
       (select u.UserPersonnelId from [dbo].DC_USER u where u.UserId=
       (select w.WorkplaceUserId from [dbo].[DC_WORKPLACE] w where w.WorkplaceId=@workPlaceId))

 ELSE IF @personnelFormat = 101     -- A.N.
   select @result=substring(p.PersonnelName, 1, 1)  + '.' + substring(p.PersonnelSurname, 1, 1) + '.'  from [dbo].[DC_PERSONNEL] p 
  where p.PersonnelId=
       (select u.UserPersonnelId from [dbo].DC_USER u where u.UserId=
       (select w.WorkplaceUserId from [dbo].[DC_WORKPLACE] w where w.WorkplaceId=@workPlaceId))

 ELSE IF @personnelFormat = 102     --A.Ə.Novruzova
  
   select @result=substring(p.PersonnelName, 1, 1)  + '.' + substring(p.PersonnelLastname, 1, 1)  + '.' +PersonnelSurname from [dbo].[DC_PERSONNEL] p 
  where p.PersonnelId=
       (select u.UserPersonnelId from [dbo].DC_USER u where u.UserId=
       (select w.WorkplaceUserId from [dbo].[DC_WORKPLACE] w where w.WorkplaceId=@workPlaceId))

 ELSE IF @personnelFormat = 103

   select @result=p.PersonnelSurname + ' ' + p.PersonnelName from [dbo].[DC_PERSONNEL] p 
  where p.PersonnelId=
       (select u.UserPersonnelId from [dbo].DC_USER u where u.UserId=
       (select w.WorkplaceUserId from [dbo].[DC_WORKPLACE] w where w.WorkplaceId=@workPlaceId))

 ELSE IF @personnelFormat = 104

   select @result= p.PersonnelSurname + ' ' + substring(p.PersonnelName, 1, 1)+'.'+substring(p.PersonnelLastname,1,1)+'.' from [dbo].[DC_PERSONNEL] p 
  where p.PersonnelId=
       (select u.UserPersonnelId from [dbo].DC_USER u where u.UserId=
       (select w.WorkplaceUserId from [dbo].[DC_WORKPLACE] w where w.WorkplaceId=@workPlaceId))

 ELSE IF @personnelFormat = 105     -- R.Mehdiyev
   select @result=substring(p.PersonnelName,1,1) + '.' + p.PersonnelSurname from [dbo].[DC_PERSONNEL] p 
  where p.PersonnelId=
       (select u.UserPersonnelId from [dbo].DC_USER u where u.UserId=
       (select w.WorkplaceUserId from [dbo].[DC_WORKPLACE] w where w.WorkplaceId=@workPlaceId))

 ELSE IF @personnelFormat = 106                   -- Ramiz Mehdiyev
   select @result= p.PersonnelName + ' ' + p.PersonnelSurname from [dbo].[DC_PERSONNEL] p 
  where p.PersonnelId=
       (select u.UserPersonnelId from [dbo].DC_USER u where u.UserId=
       (select w.WorkplaceUserId from [dbo].[DC_WORKPLACE] w where w.WorkplaceId=@workPlaceId))

 ELSE IF @personnelFormat = 206     -- R.Mehdiyevə
   select @result=substring(p.PersonnelName,1,1) + '.' + p.PersonnelSurname from [dbo].[DC_PERSONNEL] p 
  where p.PersonnelId=
       (select u.UserPersonnelId from [dbo].DC_USER u where u.UserId=
       (select w.WorkplaceUserId from [dbo].[DC_WORKPLACE] w where w.WorkplaceId=@workPlaceId))
 
 RETURN @result;

END

