-- =============================================
-- Author:  Səfərov Şəhriyar
-- Create date: 15.02.2019
-- =============================================

CREATE function [dbo].[fnPropertyByWorkPlaceId]
(
 @WorkPlaceId int,@PropertyFormat int
)
returns int
as
begin
 Declare @Result int;

 --Userin WorkplaceId -ni daxil edib userin UserId return eliyirik (Userin oz id-si)
 --if @PropertyFormat=1 
 --  select @Result=u.UserId 
 --  from DC_USER u 
 -- where u.UserId=(select w.WorkplaceUserId from dbo.DC_WORKPLACE w where w.WorkplaceId=@WorkPlaceId)
    
  /*  performans baximindan calisin "where ve column seviyyesinde" subquerylerden az istifade edin  */
  if @PropertyFormat=1 
   select @Result=u.UserId 
   from DC_USER u 
   join dbo.DC_WORKPLACE w on u.UserId=w.WorkplaceUserId and w.WorkplaceId=@WorkPlaceId

 else if @PropertyFormat=2 
   select @Result=d.DepartmentId 
   from dbo.DC_DEPARTMENT d
  where d.DepartmentId=(select w.WorkplaceDepartmentId from dbo.DC_WORKPLACE w where w.WorkplaceId=@WorkPlaceId)
 
 --Userin WorkplaceId -ni daxil edib userin OrganizationId return eliyirik (Userin isdediyi qurumun id-si)
 else if @PropertyFormat=12 
   select @Result=o.OrganizationId 
   from dbo.DC_ORGANIZATION o 
  where o.OrganizationId=(select w.WorkplaceOrganizationId from dbo.DC_WORKPLACE w where w.WorkplaceId=@WorkPlaceId)




    return @result;   
end

