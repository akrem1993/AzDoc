Create FUNCTION [dbo].[fnGetPersonnelbyPersonnelId]
(
 @PersonnelId int, @PersonnelFormat int = 100
)
RETURNS nvarchar(MAX)
AS
BEGIN
 DECLARE @Result nvarchar(MAX);
 
 IF @PersonnelFormat = 203
  SELECT @Result = PersonnelName
    FROM DC_PERSONNEL 
   WHERE PersonnelId = @PersonnelId
   
 ELSE IF @PersonnelFormat = 100
  SELECT @Result = PersonnelSurname + ' ' + substring(PersonnelName, 1, 1) + '.' 
    FROM DC_PERSONNEL 
   WHERE PersonnelId = @PersonnelId

 ELSE IF @PersonnelFormat = 101     -- A.N.
  SELECT @Result = substring(PersonnelName, 1, 1)  + '.' + substring(PersonnelSurname, 1, 1) + '.' 
    FROM DC_PERSONNEL 
   WHERE PersonnelId = @PersonnelId

 ELSE IF @PersonnelFormat = 102     --A.Ə.Novruzova
  SELECT @Result = substring(PersonnelName, 1, 1)  + '.' + substring(PersonnelLastname, 1, 1)  + '.' +PersonnelSurname
    FROM DC_PERSONNEL 
   WHERE PersonnelId = @PersonnelId

 ELSE IF @PersonnelFormat = 103
  SELECT @Result = PersonnelSurname + ' ' + PersonnelName
    FROM DC_PERSONNEL 
   WHERE PersonnelId = @PersonnelId

 ELSE IF @PersonnelFormat = 104
  SELECT @Result = PersonnelSurname + ' ' + substring(PersonnelName, 1, 1)+'.'+substring(PersonnelLastname,1,1)+'.'
    FROM DC_PERSONNEL 
   WHERE PersonnelId = @PersonnelId

 ELSE IF @PersonnelFormat = 105     -- R.Mehdiyev
  SELECT @Result = substring(PersonnelName,1,1) + '.' + PersonnelSurname
    FROM DC_PERSONNEL 
   WHERE PersonnelId = @PersonnelId

 ELSE IF @PersonnelFormat = 106                   -- Ramiz Mehdiyev
  SELECT @Result = PersonnelName + ' ' + PersonnelSurname
    FROM DC_PERSONNEL 
   WHERE PersonnelId = @PersonnelId

 ELSE IF @PersonnelFormat = 206     -- R.Mehdiyevə
  SELECT @Result = substring(PersonnelName,1,1) + '.' + PersonnelSurname  
    FROM DC_PERSONNEL 
   WHERE PersonnelId = @PersonnelId
 
 RETURN @Result;

END

