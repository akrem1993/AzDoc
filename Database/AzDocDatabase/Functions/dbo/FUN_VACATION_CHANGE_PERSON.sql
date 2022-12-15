CREATE FUNCTION [dbo].[FUN_VACATION_CHANGE_PERSON](@workplaceId int, @directionDate datetime, @personId int) 
RETURNS NVARCHAR(100)
AS
BEGIN

 
DECLARE @newUserId NVARCHAR(100)
DECLARE @oldUserId NVARCHAR(100)
DECLARE @oldPersonName NVARCHAR(100)
DECLARE @newPersonName NVARCHAR(100)

SELECT  @newUserId=VacationNewUserId, @oldUserId=VacationOldUserId  FROM DC_VACATION va
WHERE va.VacationWorkplaceId=@workplaceId AND 
VA.VacationBeginDate <= @directionDate AND VA.VacationEndDate >=@directionDate AND IsDeleted=0

IF @newUserId > 0
BEGIN

	SELECT @oldPersonName=CONCAT(pe.PersonnelName,' ',pe.PersonnelSurname) FROM DC_USER us 
	INNER JOIN DC_PERSONNEL pe on pe.PersonnelId=us.UserPersonnelId
	where us.UserId=@oldUserId

	SELECT @newPersonName=CONCAT(pe.PersonnelName,' ',pe.PersonnelSurname) FROM DC_USER us 
	INNER JOIN DC_PERSONNEL pe on pe.PersonnelId=us.UserPersonnelId
	where us.UserId=@newUserId

	RETURN CONCAT(@oldPersonName, N'(Əvəz edən-',@newPersonName ,')')

END
ELSE
	BEGIN
	   RETURN dbo.Get_person(4,  @personId)
	END 

return ''
END
