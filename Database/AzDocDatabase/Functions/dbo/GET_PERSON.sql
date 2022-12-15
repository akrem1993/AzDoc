/*
Migrated by Kamran A-eff 07.09.2019
*/

/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

CREATE FUNCTION [dbo].[GET_PERSON](@ViewForm int , @WorkPlaceId int)
RETURNS NVARCHAR(250)
AS
BEGIN
DECLARE @PersonName Nvarchar(250),
        @PositionGroup int
IF @ViewForm=1
BEGIN
SELECT @PersonName = 
     ISNULL(PE.PersonnelName, '')+
        ISNULL(' ' + PE.PersonnelSurname, '')+
        ISNULL(' ' + PE.PersonnelLastname, '')+
        ISNULL(' ' + DO.DepartmentPositionName, '')+
        ISNULL(' ' + DP.DepartmentName, '') FROM  DC_WORKPLACE WP
INNER JOIN  DC_USER DU ON WP.WorkplaceUserId=DU.UserId
INNER JOIN DC_PERSONNEL PE ON DU.UserPersonnelId=PE.PersonnelId 
INNER JOIN DC_DEPARTMENT DP ON WP.WorkplaceDepartmentId= DP.DepartmentId
INNER JOIN DC_DEPARTMENT_POSITION DO ON WP.WorkplaceDepartmentPositionId=DO.DepartmentPositionId
WHERE  wp.WorkplaceId=@WorkPlaceId;
END
ELSE IF @ViewForm=2
BEGIN
SELECT @PersonName = 
     ISNULL(PE.PersonnelName, '')+
        ISNULL(' ' + PE.PersonnelSurname, '') 
  FROM  DC_WORKPLACE WP
INNER JOIN  DC_USER DU ON WP.WorkplaceUserId=DU.UserId
INNER JOIN DC_PERSONNEL PE ON DU.UserPersonnelId=PE.PersonnelId  
WHERE  wp.WorkplaceId=@WorkPlaceId;
END
RETURN @PersonName;
END

