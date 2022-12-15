CREATE function [dbo].[fnGetPersonnelDetailsbyWorkPlaceId]
(
 @workPlaceId int,@operationType int
)
returns  sql_variant
as
begin
 Declare @result sql_variant; 
 if(@operationType=1) -- FullName
 begin
    select @result=(SELECT 
       ISNULL(' ' + PE.PersonnelName, '') +     
       ISNULL(' ' + PE.PersonnelSurname, '')+                 
       ISNULL(' ' + PE.PersonnelLastname, '')+               
       ISNULL(' ' + DO.DepartmentPositionName, '') AS Name )
       FROM [dbo].DC_WORKPLACE WP INNER JOIN [dbo].DC_USER DU ON WP.WorkplaceUserId=DU.UserId       
         INNER JOIN [dbo].DC_PERSONNEL PE ON DU.UserPersonnelId=PE.PersonnelId        
         INNER JOIN [dbo].DC_DEPARTMENT DP ON WP.WorkplaceDepartmentId= DP.DepartmentId        
         INNER JOIN [dbo].DC_DEPARTMENT_POSITION DO ON WP.WorkplaceDepartmentPositionId=DO.DepartmentPositionId        
         where WP.WorkplaceId=@workPlaceId 
 end
 if(@operationType=2) -- DepartmentName
 begin
  select @result=(select ISNULL(' ' + DP.DepartmentName, '') AS Name) from DC_DEPARTMENT DP 
   where DP.DepartmentId=(select WP.WorkplaceDepartmentId from dbo.DC_WORKPLACE WP where WP.WorkplaceId=@workPlaceId)
 end
 if(@operationType=3) -- WorkplaceOrganizationId
 begin
  select @result = wp.WorkplaceOrganizationId from DC_WORKPLACE WP where WP.WorkplaceId=@workPlaceId

 end
 
  
  if(@operationType=4) -- WorkplaceDepartmentId
 begin
  select @result = wp.WorkplaceDepartmentId from DC_WORKPLACE WP where WP.WorkplaceId=@workPlaceId

 end  
  
  if(@operationType=5)
  begin
    select @result=(SELECT 
       ISNULL(' ' + PE.PersonnelName, '') +     
       ISNULL(' ' + PE.PersonnelSurname, '')+                 
       ISNULL(' ' + PE.PersonnelLastname, '') AS Name )
       FROM [dbo].DC_WORKPLACE WP INNER JOIN [dbo].DC_USER DU ON WP.WorkplaceUserId=DU.UserId       
         INNER JOIN [dbo].DC_PERSONNEL PE ON DU.UserPersonnelId=PE.PersonnelId        
         where WP.WorkplaceId=@workPlaceId 
  end
 
 
 return @result;
end

