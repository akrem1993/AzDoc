-- =============================================
-- Author:  Musayev Nurlan
-- Create date: 28.06.2019
-- Description: Departamentin shobe mudurunu tapir
-- =============================================
CREATE FUNCTION [dbo].[fnGetDepartmentChief]
(
@workPlaceId int
)
RETURNS int
AS
BEGIN
 DECLARE @result int,
 @DepartmentTypeId int,
 @DepartmentTopId int,
 @departmentId int,
  @positionGroupId int;

 select 
 @departmentId=d.DepartmentId,
 @DepartmentTypeId=d.DepartmentTypeId,
 @DepartmentTopId=d.DepartmentTopId 
 from 
 DC_DEPARTMENT d 
join DC_WORKPLACE w on d.DepartmentId=w.WorkplaceDepartmentId
 where w.WorkplaceId=@workPlaceId AND w.WorkPlaceStatus=1;

	IF @DepartmentTypeId=6    --(DepartmentTypeId(6)='Sector')
	begin 
	if(@departmentId=2487)
	BEGIN
		set @departmentId=@departmentId;
	END
	ELSE
	BEGIN
		set @departmentId=@DepartmentTopId;
	END    
    SET @positionGroupId=17;
END

else
begin 
    IF @DepartmentTopId is null RETURN @workPlaceId;
        --set @departmentId=@DepartmentTopId; 
    IF @DepartmentTypeId IN (2,5) SET @positionGroupId=17;
end; 
  
    
  select @result=w.WorkplaceId 
  from DC_DEPARTMENT d 
  join DC_DEPARTMENT_POSITION dp on d.DepartmentId=dp.DepartmentId 
  join DC_WORKPLACE w on w.WorkplaceDepartmentPositionId=dp.DepartmentPositionId 
JOIN dbo.DC_USER du ON w.WorkplaceUserId = du.UserId
  where 
   dp.PositionGroupId=@positionGroupId            --(17=SectionChief,26=SectorChief) 
   and dp.DepartmentId=@departmentId
AND du.UserStatus=1
  order by dp.PositionGroupId desc;

  if @result is null
   return @workPlaceId;
    
    return @result;
END

