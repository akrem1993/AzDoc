-- =============================================
-- Author:  Musayev Nurlan
-- Create date: 19.03.2019
-- Description: departament id-sine gore Şöbənin rəisinin wokrplaceni getirir
-- =============================================
CREATE FUNCTION [dbo].[fnGetChiefByDepartmentID]
(
@departmentId int,
@workPlaceId int
)
RETURNS int
AS
BEGIN
 DECLARE @result int,@DepartmentTypeId int ,@DepartmentTopId int;
 set @result=@workPlaceId;
 select @DepartmentTypeId=DepartmentTypeId,@DepartmentTopId=DepartmentTopId from DC_DEPARTMENT where DepartmentId=@departmentId;

 --if @DepartmentTypeId=6 and @DepartmentTopId is not null        --(DepartmentTypeId(6)='Sector')
 --begin 
 -- set @departmentId=@DepartmentTopId;
 --end;

  select @result=w.WorkplaceId 
  from DC_DEPARTMENT d 
  join DC_DEPARTMENT_POSITION dp on d.DepartmentId=dp.DepartmentId 
  join DC_WORKPLACE w on w.WorkplaceDepartmentPositionId=dp.DepartmentPositionId 
  where 
   dp.PositionGroupId in (17,26)            --(17=SectionChief,26=SectorChief) 
   and dp.DepartmentId=@departmentId
  order by dp.PositionGroupId desc;

  if @result is null
  begin
   set @result=@workPlaceId;
  end;
    
    return @result;
 

 --RETURN @workPlaceId;

END

